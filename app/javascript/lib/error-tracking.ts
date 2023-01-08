import * as Sentry from '@sentry/browser';

declare const process: { env: Record<string, string> };

export function startErrorTracking(): void {
  Sentry.init({
    dsn: 'https://592faee491bc43e2a188bc260fe817e2@o385233.ingest.sentry.io/4504315490074624',
    environment: process.env.SENTRY_ENVIRONMENT || process.env.RAILS_ENV,
  });
}

export function trackError(
  error: Error,
  extra: Record<string, string> = {}
): void {
  Sentry.captureException(error, { extra });
}
