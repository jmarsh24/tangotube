import { defineConfig, loadEnv } from 'vite';
import { resolve } from 'path';
import RubyPlugin from 'vite-plugin-ruby';
import sassGlobImports from 'vite-plugin-sass-glob-import';
import StimulusHMR from 'vite-plugin-stimulus-hmr';
import FullReload from 'vite-plugin-full-reload';
import autoprefixer from 'autoprefixer';

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '');
  return {
    build: { sourcemap: true },
    resolve: {
      alias: {
        '@assets': resolve(__dirname, 'app/assets'),
      },
    },
    plugins: [
      RubyPlugin(),
      StimulusHMR(),
      FullReload(['config/routes.rb', 'app/views/**/*'], { delay: 200 }),
      sassGlobImports(),
    ],
    css: {
      postcss: {
        plugins: [
          autoprefixer({}), // add options if needed
        ],
      },
    },
    define: {
      __RAILS_ENV__: env.RAILS_ENV,
      __SENTRY_ENVIRONMENT__: env.SENTRY_ENVIRONMENT,
    },
  };
});
