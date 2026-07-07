// Production entry point for Autoscale deployment
import express from 'express';
import { dirname, join } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const app = express();
const PORT = process.env.PORT || 8080;

// Static files should be in dist/public after the build
const STATIC_DIR = process.env.NODE_ENV === 'production' 
  ? join(__dirname, 'public')
  : join(__dirname, 'dist', 'public');

console.log(`Serving static files from: ${STATIC_DIR}`);

// Serve static assets
app.use(express.static(STATIC_DIR));

// All routes not matched by static files should serve the index.html
app.get('*', (req, res) => {
  res.sendFile(join(STATIC_DIR, 'index.html'));
});

// Start the server
app.listen(PORT, () => {
  console.log(`Production server running on port ${PORT}`);
  console.log(`Server environment: ${process.env.NODE_ENV || 'development'}`);
});