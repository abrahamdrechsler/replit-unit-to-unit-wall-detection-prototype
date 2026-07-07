#!/bin/bash

# Clean up previous builds
rm -rf dist/
mkdir -p dist/public/assets

# Build the application
echo "Building application..."
VITE_BUILD_OUTPUT=$(npx vite build --outDir dist/public 2>&1)
echo "$VITE_BUILD_OUTPUT"

# Extract CSS and JS filenames using regex
echo "Extracting filenames from build output..."
CSS_FILENAME=$(echo "$VITE_BUILD_OUTPUT" | grep -o 'index-[a-zA-Z0-9]*.css' | head -1)
JS_FILENAME=$(echo "$VITE_BUILD_OUTPUT" | grep -o 'index-[a-zA-Z0-9]*.js' | head -1)

echo "Found CSS: $CSS_FILENAME"
echo "Found JS: $JS_FILENAME"

# Find where the asset files actually got created
echo "Locating asset files..."
ASSET_DIRS=$(find . -name "assets" -type d)
for dir in $ASSET_DIRS; do
  if [ -f "$dir/$JS_FILENAME" ] && [ -f "$dir/$CSS_FILENAME" ]; then
    echo "Found assets in $dir"
    FOUND_ASSETS_DIR="$dir"
    break
  fi
done

if [ -z "$FOUND_ASSETS_DIR" ]; then
  echo "Could not find the generated assets!"
  exit 1
fi

# Copy assets to the right place if they're not already there
if [ "$FOUND_ASSETS_DIR" != "./dist/public/assets" ]; then
  echo "Copying assets to dist/public/assets/"
  cp -r $FOUND_ASSETS_DIR/* dist/public/assets/
fi

# Create a correct index.html file with the extracted filenames
echo "Creating index.html with correct filenames..."
cat > dist/public/index.html << EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1" />
    <title>Wall Relationship Diagram Tool</title>
    <link rel="stylesheet" href="./assets/${CSS_FILENAME}">
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="./assets/${JS_FILENAME}"></script>
  </body>
</html>
EOF

# Check the result
echo "Build completed. Files are in dist/public/"
ls -la dist/public/
ls -la dist/public/assets/

echo "✅ Build successful! You can now deploy this static site."
echo "To deploy, use the 'Deploy' button in Replit and select 'Static Site'."