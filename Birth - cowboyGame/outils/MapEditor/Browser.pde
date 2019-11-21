

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
 
  PGraphics v;
  
  Scroller scroller;
  //constructor
  
  BrowserHandler()
  {
    createItems();

  }
  
 
  // Put any methods here in the class body
  
  public void update() {
    
    v = getGraphics();
    
    v.beginDraw();
    
    v.background(255,255,255,255); 
    
    doIPutAScroll(v);
    putScrollerRectangle(v);

    for (int i = 0 ; i<itemsInMenu.size() ; i ++ ) {
      
      itemsInMenu.get(i).draw(v);  //dessiner l'item
      itemsInMenu.get(i).setPos(i*initialSizeObject+initialXObject , v.height/2-30);
      textSize(30);
      fill(100);
      v.text(itemsInMenu.get(i).getName(), i*initialSizeObject+initialXObject-30, v.height/2+60);
      
      if( itemsInMenu.get(i).isClicked() ) //si l'item dans le menu est cliqué
        {
          println("true");
          itemInHand = itemsInMenu.get(i).copy();
          isCarringItem = true;
          //isReallyCarringItem = true; //voir dans globals
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
  
  //remplit le tableau d'item ( charge les items dans le tableau de ce qui doit etre affiché dans browser )
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
  
  //créer la barre de défilement
  public void putScrollerRectangle(PGraphics view){
    if(scrollInMenu == true) {
      noStroke();
      fill(100, 100, 100, 255);
      view.rect( 0, view.height-rectangleHeight, totalWidth, rectangleHeight);
      
      scroller.drawScroller(view);
    }
  }
  
  private void doIPutAScroll(PGraphics view) {
    widthOfItems = itemsInMenu.size()*initialSizeObject;
    totalWidth = view.width;
    //décide si il doit afficher ou non scroll
    if(widthOfItems >= totalWidth) {
      scrollInMenu = true;
      rectangleWidth = (totalWidth / widthOfItems)*totalWidth;
      scroller = new Scroller (0, view.height-rectangleHeight,  rectangleWidth, rectangleHeight);
    }
    isInitialisation = true;
  }


} // end of class body
