import React, { useState, useRef, useEffect } from 'react';
import './App.css';

// Define the shape interface
interface Shape {
  id: number;
  x: number;
  y: number;
  width: number;
  height: number;
  color: string;
}

// Grid cell size
const CELL_SIZE = 20;

function App() {
  const [shapes, setShapes] = useState<Shape[]>([]);
  const [nextId, setNextId] = useState(1);
  const [isDragging, setIsDragging] = useState(false);
  const [draggedShape, setDraggedShape] = useState<Shape | null>(null);
  const [dragOffset, setDragOffset] = useState({ x: 0, y: 0 });
  const [gridSize, setGridSize] = useState({ width: 40, height: 30 }); // Grid size in cells
  
  const canvasRef = useRef<HTMLDivElement>(null);

  // Colors for the shapes
  const colors = ['#FF6B6B', '#4ECDC4', '#FFD166'];

  // Function to add a new shape
  const addShape = () => {
    const newShape: Shape = {
      id: nextId,
      x: Math.floor(Math.random() * (gridSize.width - 5)) * CELL_SIZE,
      y: Math.floor(Math.random() * (gridSize.height - 5)) * CELL_SIZE,
      width: Math.floor(2 + Math.random() * 4) * CELL_SIZE,
      height: Math.floor(2 + Math.random() * 4) * CELL_SIZE,
      color: colors[Math.floor(Math.random() * colors.length)]
    };
    
    setShapes([...shapes, newShape]);
    setNextId(nextId + 1);
  };

  // Check if two shapes overlap more than one grid cell
  const checkExcessiveOverlap = (shape1: Shape, shape2: Shape): boolean => {
    // Calculate the overlap area
    const xOverlap = Math.max(0, Math.min(shape1.x + shape1.width, shape2.x + shape2.width) - Math.max(shape1.x, shape2.x));
    const yOverlap = Math.max(0, Math.min(shape1.y + shape1.height, shape2.y + shape2.height) - Math.max(shape1.y, shape2.y));
    
    // Calculate the overlap in terms of grid cells (rounded up)
    const overlappingCellsX = Math.ceil(xOverlap / CELL_SIZE);
    const overlappingCellsY = Math.ceil(yOverlap / CELL_SIZE);
    
    // The shapes overlap excessively if they share more than 1 cell
    const totalOverlappingCells = overlappingCellsX * overlappingCellsY;
    return totalOverlappingCells > 1;
  };

  // Start dragging a shape
  const handleMouseDown = (e: React.MouseEvent, shape: Shape) => {
    e.preventDefault();
    setIsDragging(true);
    setDraggedShape(shape);
    
    const canvasRect = canvasRef.current?.getBoundingClientRect();
    if (canvasRect) {
      setDragOffset({
        x: e.clientX - (shape.x + canvasRect.left),
        y: e.clientY - (shape.y + canvasRect.top)
      });
    }
  };

  // Handle mouse move for dragging
  const handleMouseMove = (e: React.MouseEvent) => {
    if (!isDragging || !draggedShape || !canvasRef.current) return;
    
    const canvasRect = canvasRef.current.getBoundingClientRect();
    
    // Calculate the new position, snapped to the grid
    let newX = Math.round((e.clientX - canvasRect.left - dragOffset.x) / CELL_SIZE) * CELL_SIZE;
    let newY = Math.round((e.clientY - canvasRect.top - dragOffset.y) / CELL_SIZE) * CELL_SIZE;
    
    // Ensure the shape stays within the grid
    newX = Math.max(0, Math.min(newX, (gridSize.width * CELL_SIZE) - draggedShape.width));
    newY = Math.max(0, Math.min(newY, (gridSize.height * CELL_SIZE) - draggedShape.height));
    
    // Create a temporary shape with the new position
    const tempShape = { ...draggedShape, x: newX, y: newY };
    
    // Check if this new position would cause excessive overlap with any other shape
    let hasExcessiveOverlap = false;
    for (const shape of shapes) {
      if (shape.id !== draggedShape.id && checkExcessiveOverlap(tempShape, shape)) {
        hasExcessiveOverlap = true;
        break;
      }
    }
    
    // If there's no excessive overlap, update the shape's position
    if (!hasExcessiveOverlap) {
      setShapes(shapes.map(shape => 
        shape.id === draggedShape.id 
          ? { ...shape, x: newX, y: newY } 
          : shape
      ));
    }
  };

  // End dragging
  const handleMouseUp = () => {
    setIsDragging(false);
    setDraggedShape(null);
  };

  // Add event listeners for mouse up outside the canvas
  useEffect(() => {
    const handleGlobalMouseUp = () => {
      if (isDragging) {
        setIsDragging(false);
        setDraggedShape(null);
      }
    };
    
    window.addEventListener('mouseup', handleGlobalMouseUp);
    return () => {
      window.removeEventListener('mouseup', handleGlobalMouseUp);
    };
  }, [isDragging]);

  return (
    <div className="App">
      <h1>Wall Relationship Diagram Tool</h1>
      <div className="controls">
        <button onClick={addShape}>Add Rectangle</button>
      </div>
      <div 
        ref={canvasRef}
        className="canvas" 
        onMouseMove={handleMouseMove}
        onMouseUp={handleMouseUp}
        style={{ 
          width: `${gridSize.width * CELL_SIZE}px`, 
          height: `${gridSize.height * CELL_SIZE}px` 
        }}
      >
        {/* Draw grid lines */}
        <div className="grid-lines">
          {Array.from({ length: gridSize.width }, (_, i) => (
            <div 
              key={`vertical-${i}`} 
              className="grid-line vertical" 
              style={{ left: `${i * CELL_SIZE}px` }}
            />
          ))}
          {Array.from({ length: gridSize.height }, (_, i) => (
            <div 
              key={`horizontal-${i}`} 
              className="grid-line horizontal" 
              style={{ top: `${i * CELL_SIZE}px` }}
            />
          ))}
        </div>
        
        {/* Render shapes */}
        {shapes.map(shape => (
          <div
            key={shape.id}
            className={`shape ${isDragging && draggedShape?.id === shape.id ? 'dragging' : ''}`}
            style={{
              left: `${shape.x}px`,
              top: `${shape.y}px`,
              width: `${shape.width}px`,
              height: `${shape.height}px`,
              backgroundColor: shape.color
            }}
            onMouseDown={(e) => handleMouseDown(e, shape)}
          >
            <div className="shape-id">{shape.id}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default App;