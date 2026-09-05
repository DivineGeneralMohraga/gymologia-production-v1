import { Injectable, Logger } from '@nestjs/common';
import { SecurityEventType } from '@prisma/client';

import { isExempt } from './ip-block.policy';

/**
 * The list of addresses currently refused, and nothing else.
 *
 * Held in memory on purpose. A block here is minutes long and exists to
 * make an attack in progress expensive; persisting it would mean a wrong
 * decision outlives the process that made it, and the failure mode of a
 * persisted block is a customer who cannot reach the app and no obvious
 * reason why. A restart clears the list, and the next offending request
 * re-earns the block within seconds -- which is the right way round.
 *
 * The trade this makes explicitly: with more than one instance behind a
 * load balancer, each holds its own list, so an attacker is blocked per
 * instance rather than fleet-wide. That is still most of the value, and
 * the alternative -- a shared store consulted on every request -- puts a
 * network round trip in front of every call in the product to catch a
 * case that is already being caught a moment later. If this ever needs to
 * be fleet-wide, Redis is the place for it, not the database.
 *
 * Nothing here decides *whether* to block. That is ip-block.policy.ts.
 */
@Injectable()
export class IpBlockService {
  private readonly logger = new Logger(IpBlockService.name);

  /** ip -> epoch ms at which the block lifts. */
  private readonly blocked = new Map<string, number>();

  /**
   * A ceiling, because the keys come from whoever is calling us. An
   * attacker rotating source addresses would otherwise grow this map
   * without bound and turn a defence into the memory leak that takes the
   * server down.
   */
  private static readonly MAX_ENTRIES = 10_000;

  /**
   * Block an address, or extend an existing block. Never shortens one.
   *
   * Returns true only when this call started a block that was not already
   * running. Callers use that to write exactly one log entry per block.
   *
   * That return value exists because of a real race. Recording a security
   * event is fire-and-forget, so when five probes arrive in a second, the
   * five evaluations can all finish counting after all five rows have
   * landed — and each one then decides, correctly, that the threshold is
   * crossed. The block was right; the three duplicate log entries it wrote
   * were not, and an operator reading them would think the address had
   * been blocked three separate times.
   */
  block(ip: string, minutes: number, reason: string): boolean {
    if (isExempt(ip)) return false;

    const now = Date.now();
    const until = now + minutes * 60_000;
    const existing = this.blocked.get(ip);
    const alreadyBlocked = existing !== undefined && existing > now;

    if (alreadyBlocked && existing >= until) return false;

    if (!alreadyBlocked && this.blocked.size >= IpBlockService.MAX_ENTRIES) {
      this.sweep();
      if (this.blocked.size >= IpBlockService.MAX_ENTRIES) {
        // Still full of live blocks. Refusing to add is the safe end of
        // this: the request is merely allowed through to the ordinary
        // rate limits, rather than the process running out of memory.
        this.logger.warn(
          `block list full (${IpBlockService.MAX_ENTRIES}); not adding ${ip}`,
        );
        return false;
      }
    }

    this.blocked.set(ip, until);
    if (!alreadyBlocked) {
      this.logger.warn(`blocked ${ip} for ${minutes}m — ${reason}`);
      return true;
    }
    this.logger.warn(`extended block on ${ip} to ${minutes}m — ${reason}`);
    return false;
  }

  /**
   * Milliseconds remaining on a block, or 0 when the caller may proceed.
   * Returning the remainder rather than a boolean lets the guard send an
   * honest Retry-After instead of a number it made up.
   */
  retryAfterMs(ip: string | null | undefined): number {
    if (!ip || isExempt(ip)) return 0;

    const until = this.blocked.get(ip);
    if (until === undefined) return 0;

    const left = until - Date.now();
    if (left <= 0) {
      this.blocked.delete(ip);
      return 0;
    }
    return left;
  }

  /** For the admin console and the tests: what is blocked right now. */
  active(): Array<{ ip: string; secondsLeft: number }> {
    this.sweep();
    const now = Date.now();
    return [...this.blocked.entries()]
      .map(([ip, until]) => ({
        ip,
        secondsLeft: Math.max(0, Math.round((until - now) / 1000)),
      }))
      .sort((a, b) => b.secondsLeft - a.secondsLeft);
  }

  /** Lift a block by hand — an operator overruling the automation. */
  unblock(ip: string): boolean {
    return this.blocked.delete(ip);
  }

  /** Drop everything expired. Cheap, and only called when it might matter. */
  private sweep(): void {
    const now = Date.now();
    for (const [ip, until] of this.blocked) {
      if (until <= now) this.blocked.delete(ip);
    }
  }
}

/** Re-exported so callers do not reach past this file for the enum. */
export type BlockableType = keyof typeof SecurityEventType;
