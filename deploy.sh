#!/bin/bash

echo "================ Wall Relationship Diagram Tool Deployment ================"
echo "Creating static site deployment structure for Replit..."

# Run the static build script
./build_static_site.sh

if [ $? -ne 0 ]; then
  echo "❌ Static build failed! Check the error messages above."
  exit 1
fi

echo "✅ Static build completed successfully!"
echo ""
echo "🚀 DEPLOYMENT INSTRUCTIONS:"
echo "1. Go to the Replit deployment settings"
echo "2. Select the 'static' directory as your deployment folder"
echo "3. Click 'Deploy'"
echo ""
echo "Your application will be hosted on a .replit.app domain after deployment."