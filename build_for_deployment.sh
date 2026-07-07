#!/bin/bash

echo "================ Wall Relationship Diagram Tool Deployment ================"
echo "Creating static site deployment structure for Replit..."

# Clean up any previous builds
echo "Cleaning previous builds..."
rm -rf public/
rm -rf dist/

# Create the required directories
mkdir -p public
mkdir -p dist/public

# Build the application using the existing configuration
echo "Building the application..."
npx vite build

if [ $? -ne 0 ]; then
  echo "❌ Build failed! Check the error messages above."
  exit 1
fi

echo "✅ Build completed successfully!"

# Copy files from dist/public to public
echo "Copying files to proper deployment directory..."
cp -r dist/public/* public/

# Verify the files were copied
if [ -f "public/index.html" ] && [ -d "public/assets" ]; then
  echo "✅ Deployment structure created correctly!"
  
  # List the files to verify
  echo "Deployment structure:"
  ls -la public/
  echo ""
  echo "Assets files:"
  ls -la public/assets/
  
  # Final message for deployment
  echo ""
  echo "🚀 READY FOR DEPLOYMENT"
  echo "Your application is now ready to be deployed using Replit's static hosting."
  echo "Click the 'Deploy' button in the Replit interface to proceed."
else
  echo "❌ Required files not found in public directory!"
  
  # Debug info
  echo "Current directory structure:"
  ls -la
  echo ""
  echo "Files found in dist/public (if it exists):"
  ls -la dist/public/ 2>/dev/null || echo "dist/public/ directory not found"
  
  exit 1
fi