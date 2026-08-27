import 'reflect-metadata';
import { Logger, ValidationPipe, VersioningType } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import type { NestExpressApplication } from '@nestjs/platform-express';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import compression from 'compression';
import helmet from 'helmet';
import { AppModule } from './app.module';
import { PrismaService } from './prisma/prisma.service';

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    // Body size is capped so a single request cannot be used to exhaust
    // memory; image uploads go to Supabase Storage, not through this API.
    bodyParser: true,
  });

  const config = app.get(ConfigService);
  const port = config.get<number>('app.port', 3000);
  const prefix = config.get<string>('app.apiPrefix', 'api/v1');
  const isProduction = config.get<boolean>('app.isProduction', false);

  app.setGlobalPrefix(prefix);

  // ── Transport hardening ──────────────────────────────────────────
  app.use(
    helmet({
      contentSecurityPolicy: isProduction ? undefined : false,
      crossOriginEmbedderPolicy: false,
      hsts: isProduction
        ? { maxAge: 31_536_000, includeSubDomains: true, preload: true }
        : false,
    }),
  );
  app.use(compression());

  // Behind a load balancer this is what makes req.ip the real client
  // address rather than the proxy's — every rate limit depends on it.
  app.set('trust proxy', 1);

  // The mobile apps are not browsers, so there is no cookie to protect and
  // no origin to allow-list beyond the admin web console.
  app.enableCors({
    origin: isProduction
      ? [/\.gymologia\.com$/]
      : true,
    credentials: false,
    methods: ['GET', 'POST', 'PATCH', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Gym-Id', 'Accept-Language'],
    maxAge: 86_400,
  });

  // ── Input contract ───────────────────────────────────────────────
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      // An unexpected property is an error, not a silent drop: it is how a
      // client trying to set `role` or `isVerified` gets caught.
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: { enableImplicitConversion: false },
      // Validation messages describe the field, never echo the value.
      disableErrorMessages: false,
      validationError: { target: false, value: false },
    }),
  );

  app.enableShutdownHooks();
  await app.get(PrismaService).enableShutdownHooks(app);

  // ── API docs (never in production) ───────────────────────────────
  if (!isProduction) {
    const doc = new DocumentBuilder()
      .setTitle('Gymologia API')
      .setDescription(
        'Backend for the Gymologia member/staff app, the referral app and the admin console.',
      )
      .setVersion('0.1.0')
      .addBearerAuth()
      .addGlobalParameters({
        name: 'X-Gym-Id',
        in: 'header',
        required: false,
        description: 'Scopes a CRM request to one gym.',
      })
      .build();
    SwaggerModule.setup(`${prefix}/docs`, app, SwaggerModule.createDocument(app, doc));
  }

  await app.listen(port, '0.0.0.0');

  const logger = new Logger('Bootstrap');
  logger.log(`Gymologia API listening on :${port}/${prefix}`);
  if (!isProduction) {
    logger.log(`Swagger UI at http://localhost:${port}/${prefix}/docs`);
  }
}

void bootstrap();
