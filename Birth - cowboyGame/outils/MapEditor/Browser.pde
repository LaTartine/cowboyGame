

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
 // item block = new item( this, "tools/Objects_creator/output/barrels", 0, 0, 100); //creer l'item
  
  boolean mouseIn = false;
 
  
  //constructor
  
  BrowserHandler()
  {

    createItems();
  }
  
 
  // Put any methods here in the class body
  
  public void update() {
    
    PGraphics v = getGraphics();
    
    v.beginDraw();
    
    v.background(255,255,255,255); 

    for (int i = 0 ; i<itemsInMenu.size() ; i ++ ) {
      
      itemsInMenu.get(i).draw(v);  //dessiner l'item
      itemsInMenu.get(i).setPos(i*initialSizeObject+100,v.height/2);
      
      if( itemsInMenu.get(i).isClicked() ) //si l'item dans le menu est cliqué
        {
          println("true");
          itemInHand = itemsInMenu.get(i).copy();
          isCarringItem = true;
        }
    }
    
    isCarringAnItem( v );
    
    //IsWindowSelectedFilte(v);
    v.endDraw();
    invalidate(); // view is currently needing to update
  }
  
  public void mouseEntered() {
    back_col_idx = 0;
    mouseIn = true;
    invalidate();
  }

  public void mouseExited() {
    back_col_idx = 1;
    mouseIn = false;
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
  
  public void isCarringAnItem( PGraphics v )
  {
    if( isCarringItem && mousePressed && (mouseButton == LEFT) )
    {
      itemInHand.setPos( mouseX(), mouseY() );
      itemInHand.draw(v);
    }
    else
    {
      itemInHand = new item();
      isCarringItem = false;
    }
  }
  
  //remplit le tableau d'item
  public void createItems (){
    File file = new File(sketchPath()+"/tools/Objects_creator/output/");
    
    if(file.listFiles()!=null){
      
        File[] files = file.listFiles();
          
        for(int i = 0; i< files.length ; i++ ) {
    
          if(files[i].isDirectory() == true) {
            println(files[i].getName());
            String itemPath = files[i].getPath();
            println(itemPath);
            itemsInMenu.add(new item (this, itemPath, 0, 0, initialSizeObject));
          }
        }
    }
  }


} // end of class body
