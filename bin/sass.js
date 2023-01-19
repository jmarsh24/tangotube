#!/usr/bin/env node

import esbuild from 'esbuild';
import { sassPlugin } from 'esbuild-sass-plugin';
import sassGlob from 'esbuild-sass-glob';

await esbuild.build({
  entryPoints: ['app/assets/stylesheets/application.scss'],
  outdir: 'app/assets/builds',
  sourcemap: true,
  bundle: true,
  watch: process.argv.includes('--watch'),
  external: [
    '*.svg',
    '*.png',
    '*.jpg',
    '*.jpeg',
    '*.gif',
    '*.webp',
    '*.woff',
    '*.woff2',
    '*.ttf',
    '*.otf',
    '*.eot',
  ],
  plugins: [
    sassPlugin({
      precompile: (source, pathname) => {
        return sassGlob(source, pathname);
      },
    }),
  ],
});
