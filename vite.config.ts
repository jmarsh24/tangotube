import { resolve } from 'path';
import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';
import sassGlobImports from 'vite-plugin-sass-glob-import';
import StimulusHMR from 'vite-plugin-stimulus-hmr';
import FullReload from 'vite-plugin-full-reload';

export default defineConfig({
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
});
