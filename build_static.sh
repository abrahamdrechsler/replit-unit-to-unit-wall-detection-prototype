#!/bin/bash

# Build script for Replit static deployment of a client-side app
# Updated for compatibility with Replit's static deployment requirements

# Clean up previous build files
echo "Cleaning previous build files..."
rm -rf dist/public dist/assets client/dist client/build

# Create required directories
echo "Creating dist/public directory..."
mkdir -p dist/public/assets

# Build the Vite application 
echo "Building the application..."
npx vite build

# Check where the build output was placed
echo "Locating build outputs..."
if [ -d "dist/public/assets" ]; then
  echo "Found build output already in dist/public/assets/ (Vite direct output)"
  # Files are already in the right place, no need to copy
  BUILD_ASSETS_FOUND=true
elif [ -d "dist/client" ]; then
  echo "Found build output in dist/client/"
  cp -r dist/client/assets/* dist/public/assets/
  BUILD_ASSETS_FOUND=true
elif [ -d "dist/assets" ]; then
  echo "Found build output in dist/"
  cp -r dist/assets/* dist/public/assets/
  BUILD_ASSETS_FOUND=true
elif [ -d "client/dist" ]; then
  echo "Found build output in client/dist/"
  cp -r client/dist/assets/* dist/public/assets/
  BUILD_ASSETS_FOUND=true
else
  echo "Warning: Could not locate build output assets directory!"
  BUILD_ASSETS_FOUND=false
fi

# Check if we found the assets
if [ "$BUILD_ASSETS_FOUND" = false ]; then
  echo "Trying to find assets in any location..."
  ASSETS_PATH=$(find . -path "*/assets/*" -name "index-*.js" | head -n 1)
  if [ -n "$ASSETS_PATH" ]; then
    ASSETS_DIR=$(dirname "$ASSETS_PATH")
    echo "Found assets at $ASSETS_DIR, copying to dist/public/assets/"
    cp -r $ASSETS_DIR/* dist/public/assets/
    BUILD_ASSETS_FOUND=true
  fi
fi

# Create a proper index.html file in dist/public
echo "Creating index.html with correct asset paths..."
cat > dist/public/index.html << EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1" />
    <title>Wall Relationship Diagram Tool</title>
    <link rel="stylesheet" href="./assets/index-DG7urmsD.css">
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="./assets/index-Cvx36sWN.js"></script>
  </body>
</html>
EOF

# Verify the deployment structure
echo "Verifying deployment structure..."
if [ -f "dist/public/index.html" ] && [ -d "dist/public/assets" ]; then
  echo "✅ Build completed successfully!"
  echo "Files are ready for static deployment in 'dist/public'."
  echo "To deploy, use the 'Deploy' button in Replit and select 'Static Site'."
else
  echo "❌ Build failed - final structure is incomplete!"
  echo "dist/public contents:"
  ls -la dist/public
fi