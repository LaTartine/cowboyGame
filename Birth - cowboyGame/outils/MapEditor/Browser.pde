

//code principal, fenetre de rendu de la map hors interface. draw() = update().

public class BrowserHandler extends GViewListener {
  
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
  item block = new item( this, "tools/Objects_creator/output/barrels", 0, 0, 100); //creer l'item
  boolean exist = false;
  
  //tableau d'item
  
  item[] items;
  
  //constructor
  
  BrowserHandler()
  {
    items = new item[200];
  }
  
 
  // Put any methods here in the class body
  
  public void update() {
    
    PGraphics v = getGraphics();
    
    v.beginDraw();
    
    v.background(255,255,255,255); 

    block.draw(v);  //dessiner l'item
    block.setPos(100,v.height/2);
    
    if( block.isClicked() )
    {
      //items[0] = new item();
      items[0] = block.copy();
      exist = true;
    }
    
    if( exist && mousePressed && (mouseButton == LEFT) )
    {
      items[0].setPos( mouseX(), mouseY() );
      items[0].draw(v);
    }
    else
    {
      items[0] = new item();
      exist = false;
    }
    
    //IsWindowSelectedFilte(v);
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
  


} // end of class body
