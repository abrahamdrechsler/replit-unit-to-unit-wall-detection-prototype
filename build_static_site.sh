#!/bin/bash

# Static deployment build script for Replit
echo "================ Static Deployment Builder ================"
echo "Creating a static version of your application for deployment..."

# Clean up previous builds
echo "Cleaning previous builds..."
rm -rf dist/ static/

# Build the frontend application
echo "Building the frontend with Vite..."
npx vite build

# Check if build was successful
if [ $? -ne 0 ]; then
  echo "❌ Build failed! Check the error messages above."
  exit 1
fi

# Create static deployment structure
echo "Creating static deployment structure..."
mkdir -p static/public

# Copy the built files to the static deployment directory
echo "Copying built files to static deployment directory..."
cp -r dist/public/* static/public/

# Create the Replit configuration files
echo "Creating Replit configuration files..."

# Create replit.nix
cat > static/replit.nix << EOF
{ pkgs }: {
  deps = [
    pkgs.nodePackages.vite
  ];
}
EOF

# Create .replit
cat > static/.replit << EOF
run = "vite --host 0.0.0.0 --port 443 serve ./public"
hidden = [".config"]

[env]
PATH = "/home/runner/\$REPL_SLUG/.config/npm/node_global/bin:/home/runner/\$REPL_SLUG/node_modules/.bin"
npm_config_prefix = "/home/runner/\$REPL_SLUG/.config/npm/node_global"

[nix]
channel = "stable-22_11"

[deployment]
deploymentTarget = "static"
publicDir = "public"
EOF

# Verify the static deployment structure
if [ -f "static/public/index.html" ] && [ -d "static/public/assets" ]; then
  echo "✅ Static deployment structure created successfully!"
  
  # Display file structure
  echo "Static deployment structure:"
  ls -la static/public/
  echo ""
  echo "Assets:"
  ls -la static/public/assets/
  
  echo ""
  echo "🚀 READY FOR DEPLOYMENT"
  echo "The static site is ready to be deployed."
  echo "To deploy this site:"
  echo "1. Go to the Replit deployment settings"
  echo "2. Select the 'static' directory as your deployment folder"
  echo "3. Click 'Deploy'"
else
  echo "❌ Static deployment structure creation failed!"
  echo "Could not find expected files in the static/public directory."
  exit 1
fi