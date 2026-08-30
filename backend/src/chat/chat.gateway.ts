import { Logger } from '@nestjs/common';
import {
  OnGatewayConnection,
  OnGatewayDisconnect,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import type { Server, Socket } from 'socket.io';
import { TokenService } from '../auth/token.service';

/**
 * Realtime delivery for chat.
 *
 * Deliberately thin. Every socket joins one room named after its own user
 * id, and messages are pushed to those rooms; the socket never becomes a
 * second way to send or read anything. That keeps a single authorisation
 * path — the REST controller — rather than two that can drift apart, and
 * it means a dropped connection costs immediacy and nothing else, because
 * history comes from the API.
 *
 * Scaling past one instance needs the Redis adapter, since rooms live in
 * this process's memory.
 */
@WebSocketGateway({
  namespace: '/chat',
  cors: { origin: true },
})
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
  private readonly logger = new Logger(ChatGateway.name);

  @WebSocketServer()
  server!: Server;

  constructor(private readonly tokens: TokenService) {}

  async handleConnection(client: Socket): Promise<void> {
    // The token arrives in the handshake rather than a header, because a
    // browser WebSocket cannot set headers.
    const token =
      (client.handshake.auth?.token as string | undefined) ??
      (client.handshake.query?.token as string | undefined);

    if (!token) {
      client.disconnect(true);
      return;
    }

    try {
      const payload = await this.tokens.verifyAccess(token);
      await this.tokens.assertSessionActive(payload.sid);

      client.data.userId = payload.sub;
      await client.join(`user:${payload.sub}`);
    } catch {
      // A revoked or expired session must not hold an open socket, or
      // logging out would leave a live channel behind.
      client.disconnect(true);
    }
  }

  handleDisconnect(client: Socket): void {
    const userId = client.data?.userId as string | undefined;
    if (userId) this.logger.debug(`Chat socket closed for ${userId}`);
  }

  /** Push one message to a set of users. Best-effort by design. */
  broadcast(userIds: string[], payload: unknown): void {
    if (!this.server) return;
    for (const userId of userIds) {
      this.server.to(`user:${userId}`).emit('message', payload);
    }
  }
}
