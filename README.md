# Wall Relationship Diagram Tool

A browser-based diagramming tool for creating and visualizing relationships between rectangular shapes on a dynamic grid. The application features sophisticated border color-coding that indicates spatial relationships at a cell level.

## Features

- **Interactive Grid System**: Create and manipulate shapes on a dynamic grid
- **Relationship Visualization**: Borders are color-coded to indicate relationships between shapes
- **Direction-Agnostic Drawing**: Draw shapes in any direction on the grid
- **Full-Cell-Width Borders**: Standardized 20px borders that fill the entire cell width
- **Keyboard Controls**: Use keyboard shortcuts for efficient shape management

## Border Color Coding System

- **Red (Exterior)**: Default state for borders, also used for intersection corners
- **Yellow (Interior)**: Indicates cells that are fully enclosed by another shape
- **Blue (Unit to Unit)**: Shows exact overlap points between different shapes

## Usage Instructions

1. **Creating a Shape**:
   - Click and drag on the grid to create a shape
   - Release the mouse button to complete the shape

2. **Selecting a Shape**:
   - Click on a shape to select it
   - The selected shape will be highlighted

3. **Deleting a Shape**:
   - Select a shape and press the `Delete` key
   - The shape will be removed from the grid

4. **Moving a Shape**:
   - Select a shape
   - Use arrow keys to move the shape around the grid

## Technical Implementation

This application is built with:

- React and TypeScript for the front-end
- Vite for fast development and optimized builds
- Custom grid algorithms for shape management
- Advanced shape intersection detection logic

## Deployment

The application is configured for static deployment. The build process generates all necessary files for Replit deployment.

### Replit Static Deployment

1. Run the build script: `./deploy.sh`
2. This creates a `static` directory with all required files for deployment
3. In the Replit Deployment panel:
   - Select the `static` directory as your deployment folder
   - Click "Deploy"
   - Your application will be deployed to a `.replit.app` domain

### Manual Static Deployment

If you need to manually create a static build:

1. Run the build script: `./build_static_site.sh`
2. The script will:
   - Build the frontend with Vite
   - Create the static deployment structure
   - Generate Replit configuration files
   - Copy all necessary assets

### Troubleshooting Deployment

If you encounter issues with deployment:

1. Make sure the `static` directory contains:
   - A `public` folder with `index.html` and `assets` directory
   - `.replit` configuration file
   - `replit.nix` configuration file

2. Check that all JavaScript and CSS assets are correctly referenced in the HTML

## Development

To run the application in development mode:

1. Start the development server: `npm run dev`
2. Open a browser and navigate to the URL shown in the console

## License

This project is proprietary and confidential. Unauthorized copying, modification, distribution, or use is strictly prohibited.