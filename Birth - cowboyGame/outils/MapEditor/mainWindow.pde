
//code principal, fenetre de rendu de la map hors interface. draw() = update().

public class MapReader extends GViewListener {
  
  // Background colours
  int[][] back_col = { {255, 255, 255, 0 },  {0, 0, 0, 100} };
  // The colour to use
  int back_col_idx = 0;

  // The start and end positions of the line to be drawn
  int sx, sy, ex, ey;
  // Text description of mouse position i.e. [x, y]
  String mousePos;
  
  //background image
  
  PImage background = loadImage( mapPath + "backgrounds/1.png");

 
  // Put any methods here in the class body
  
  public void update() {
    
    PGraphics v = getGraphics();
    
    viewMouseX = mouseX();
    viewMouseY = mouseY();
 
    v.beginDraw();
    
    v.background(255,255,255,255); 
    
    generateBackground(v);
    CreateBackgroundGrid( v );
    
    IsWindowSelectedFilte(v);
    v.endDraw();
    invalidate(); // view is currently needing to update
  }
  
  public void mouseEntered() {
    back_col_idx = 0;
    invalidate();
  }

  public void mouseExited() {
    back_col_idx = 1;
    validate();
    validateView();
  }
  
  public void validateView()
  {
    invalidate();
  }
  
  
  public void mouseMoved() {
    invalidate();
  }
  
  public void mousePressed() {
    sx = ex = mouseX();
    sy = ey = mouseY();
    invalidate();
  }

  public void mouseDragged() {
    ex = mouseX();
    ey = mouseY();
    invalidate();
  }
  
  public void IsWindowSelectedFilte( PGraphics v )
  {
    v.push();
    
    noStroke();
    v.fill(back_col[back_col_idx][0], back_col[back_col_idx][1], back_col[back_col_idx][2], back_col[back_col_idx][3]);
    v.rect(0,0,v.width,v.height);
    
    v.pop();
  }
  
  public void generateBackground( PGraphics v )
  {
    mapSize.x = background.width;
    mapSize.y = background.height;
    v.image( background, /*-viewPos.x+(v.width-background.width)/2*/-viewPos.x, /*-viewPos.y+(v.height-background.height)/2*/-viewPos.y, background.width*viewZoom, background.height*viewZoom );
    
  }
  
  public void CreateBackgroundGrid( PGraphics v )
  {
    v.push();
    
    stroke( 0, 0, 0, 255);
    
    float gridX = 0;
    float gridY = 0;
    
    while( background.width*viewZoom*gridX-viewPos.x < v.width )
    {
      gridX++;
    }
    while( background.height*viewZoom*gridY-viewPos.y < v.height )
    {
      gridY++;
    }
    for( int i = 0; i < gridX; i++ )
    {
      v.line( i*background.width*viewZoom-viewPos.x-1, 0, background.width*viewZoom*i-viewPos.x-1, v.height);
    }
    for( int k = 0; k < gridY; k++ )
    {
      v.line( 0, background.height*viewZoom*k-viewPos.y-1, v.width, background.height*viewZoom*k-viewPos.y-1);
    }
    
    v.pop();
  }


} // end of class body
