const esbuild = require('esbuild');

esbuild.build({
  entryPoints: ['./app/javascript/application.js'], // Main JS file
  bundle: true,
  outdir: './app/assets/builds', // Output directory
  sourcemap: true,
  minify: process.env.NODE_ENV === 'production', // Minify in production
  watch: process.env.NODE_ENV === 'development', // Watch mode in development
}).catch(() => process.exit(1));
