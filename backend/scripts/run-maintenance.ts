/**
 * Run the scheduled jobs by hand.
 *
 *   npx ts-node scripts/run-maintenance.ts
 *
 * Boots the application context without listening on a port, so the same
 * code the cron runs is what executes here. Used by the test suite, and
 * useful on a box where the process has been restarted often enough that
 * an hourly job has not fired in a while.
 */
import { NestFactory } from '@nestjs/core';
import { Logger } from '@nestjs/common';
import { AppModule } from '../src/app.module';
import { MaintenanceService } from '../src/maintenance/maintenance.service';

async function main(): Promise<void> {
  const app = await NestFactory.createApplicationContext(AppModule, {
    logger: ['error', 'warn'],
  });

  try {
    const result = await app.get(MaintenanceService).runAll();
    // Printed as JSON so a test can parse it.
    process.stdout.write(JSON.stringify(result) + '\n');
  } catch (error) {
    new Logger('Maintenance').error((error as Error).message);
    process.exitCode = 1;
  } finally {
    await app.close();
  }
}

void main();
