#!/bin/bash

echo "================ Building for Autoscale Deployment ================"

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf dist/

# Build the frontend
echo "Building the frontend with Vite..."
npm run build

# Copy our index.js production server to the dist folder
echo "Copying production server file..."
cp index.js dist/

# Create a production package.json for the deployment
echo "Creating production package.json..."
cat > dist/package.json << EOF
{
  "name": "wall-relationship-diagram-tool",
  "version": "1.0.0",
  "type": "module",
  "main": "index.js",
  "scripts": {
    "start": "NODE_ENV=production node index.js"
  },
  "dependencies": {
    "express": "^4.21.2"
  }
}
EOF

echo "✅ Build completed successfully!"
echo ""
echo "🚀 DEPLOYMENT INSTRUCTIONS:"
echo "1. Go to the Replit deployment settings"
echo "2. Change deploymentTarget to 'autoscale'"
echo "3. Add a run command: ['npm', 'run', 'start']"
echo "4. Set entrypoint to 'index.js'"
echo "5. Click 'Deploy'"
echo ""
echo "The application will be deployed and run using the production server."