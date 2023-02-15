import * as Sentry from '@sentry/browser';

declare const process: { env: Record<string, string> };

export function startErrorTracking(): void {
  Sentry.init({
    dsn: 'https://a50690fbdd8546f49dd1153095fce6cd@o4504470653173760.ingest.sentry.io/4504470654681088',
    environment:
      import.meta.env.SENTRY_ENVIRONMENT || import.meta.env.RAILS_ENV,
  });
}

export function trackError(
  error: Error,
  extra: Record<string, string> = {}
): void {
  Sentry.captureException(error, { extra });
}
