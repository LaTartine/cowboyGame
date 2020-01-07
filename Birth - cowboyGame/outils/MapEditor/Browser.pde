

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
  
  
  

  //constructor
  
  BrowserHandler()
  {
    createArrayItemsForMenu("/tools/Objects_creator/output/", itemsInMenu);//charge les objets
    createArrayBackgroundForMenu("/map/backgrounds/", mapsInMenu);//charge les background
    typeOfFile = dropListChoixBrowser.getSelectedIndex();//met le type de fichier à afficher
  }
  
 
  // Put any methods here in the class body
  
  public void update() {
    
    v = getGraphics();
    
    v.beginDraw();
    
    v.background(255,255,255,255); 
    
    if(isInitialisation == false) {
      intializeScroll(v);
    }
    
    
      
         
      if(typeOfFile == 0) {//si c'est un objet
      doINeedAScroll(v);
      putScrollerRectangle(v);
          for (int i = 0 ; i<itemsInMenu.size() ; i ++ ) {
              itemsInMenu.get(i).draw(v);  //dessiner l'item
              itemsInMenu.get(i).setPos(i*initialSizeObject+scroller.getPosView() , v.height/2-30);
              textSize(30);
              fill(100);
              v.text(itemsInMenu.get(i).getName(), i*initialSizeObject+scroller.getPosView()-30, v.height/2+60); //textWidth(itemsInMenu.get(i).getName())
          
              if( itemsInMenu.get(i).isClicked() ) //si l'item dans le menu est cliqué
                {
                  println("true");
                  itemInHand = itemsInMenu.get(i).copy();
                  isCarringItem = true;
                  //isReallyCarringItem = true; //voir dans globals
                }
         }
      }
      
      if(typeOfFile == 1) {//si c'est une map
      doINeedAScroll(v);
      putScrollerRectangle(v);
           for (int i = 0 ; i<mapsInMenu.size() ; i ++ ) {
          mapsInMenu.get(i).draw(v);  //dessiner l'item
          mapsInMenu.get(i).setPos(i*initialSizeObject+scroller.getPosView() , v.height/2-30);
          textSize(30);
          fill(100);
          v.text(mapsInMenu.get(i).getName(), i*initialSizeObject+scroller.getPosView()-30, v.height/2+60); //textWidth(mapsInMenu.get(i).getName())
          
          if( mapsInMenu.get(i).isClicked() ) //si l'item dans le menu est cliqué
            {
              println("true");
              itemInHand = mapsInMenu.get(i).copy();
              isCarringItem = true;
              //isReallyCarringItem = true; //voir dans globals
            }
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
    mouseWindow = "Browser";
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
  
  //remplit le tableau avec des items crée à partir de ce qu'il y a dans le dossier spécifié
  //attention à bien mettre des "/" dans les chemins spécifiés
  //type : 0 = map, 1 = item
  public void createArrayItemsForMenu (String chemin, ArrayList<item> tableauObjets){
    File file = new File(sketchPath()+chemin);
        if(file.listFiles()!=null){
          File[] files = file.listFiles();
            
          for(int i = 0; i< files.length ; i++ ) {
            String itemPath = files[i].getPath();
              if(files[i].isDirectory() == true) {
                tableauObjets.add(new item (this, itemPath, 0, 0, initialSizeObject));
              
              }
            }
          }
        }
        
  public void createArrayBackgroundForMenu (String chemin, ArrayList<backgroundItem> tableauBackground){
    File file = new File(sketchPath()+chemin);
        if(file.listFiles()!=null){

          File[] files = file.listFiles();
          for(int i = 0; i< files.length ; i++ ) {
                String itemPath = files[i].getPath();
                //println("mapppp lue : " + files[i].getName().substring(files[i].getName().lastIndexOf(".")));
                if(files[i].getName().substring(files[i].getName().lastIndexOf(".")).equals( ".jpeg")) {
                  tableauBackground.add(new backgroundItem (this, itemPath, 0, 0, initialSizeObject));

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
      //println(scroller.getSelected());
      //if(mouseY> 900-rectangleHeight && mousePressed == true && mouseX>scroller.getPosX() && mouseX<scroller.getPosX()+scroller.getWidth()) {
      //  println("scroller is selected");
      //    scroller.setSelected(true);
      //    float difPos = lastMousePos.x-scroller.getPosX();
      //    println("difPos:"+difPos);
      //    if(difPos<0) {
      //      println("gauche toute !");
      //      scroller.setPosX(scroller.getPosX()+difPos);
      //    } else {
      //      println("droite toute !");
      //      scroller.setPosX(scroller.getPosX()-difPos);
      //    }
      //} else {
      //    scroller.setSelected(false); 
      //}
      scroller.drawScroller(view);

    }
  }
  
  private void intializeScroll(PGraphics view) {
    widthOfItems = itemsInMenu.size()*initialSizeObject;
    totalWidth = view.width;
    //décide si il doit afficher ou non scroll
    if(widthOfItems >= totalWidth) {
      scrollInMenu = true;
      rectangleWidth = (totalWidth / widthOfItems)*totalWidth;
      scroller = new Scroller (0, view.height-rectangleHeight,  rectangleWidth, rectangleHeight, initialXObject);
    }
    isInitialisation = true;
  }
  
  /*private void doINeedAScroll(PGraphics view){//revérifie si scroll nécessaire et recalcule sa taille
    widthOfItems = getItemsArrayFromType().size()*initialSizeObject;
    //décide si il doit afficher ou non scroll
    if(widthOfItems >= totalWidth) {
      scrollInMenu = true;
      scroller.setWidth( (totalWidth / widthOfItems)*totalWidth );
    } else {
      scrollInMenu = false;
    }
  }*/
  
   private void doINeedAScroll(PGraphics view){//revérifie si scroll nécessaire et recalcule sa taille
  
    if( getItemsArrayFromType() == 0 )
      widthOfItems = itemsInMenu.size()*initialSizeObject;
    if( getItemsArrayFromType() == 1 )
      widthOfItems = mapsInMenu.size()*initialSizeObject;
      
    //décide si il doit afficher ou non scroll
    if(widthOfItems >= totalWidth) {
      scrollInMenu = true;
      scroller.setWidth( (totalWidth / widthOfItems)*totalWidth );
    } else {
      scrollInMenu = false;
    }
  }
  
  
  /*private ArrayList<item> getItemsArrayFromType () {
    if(typeOfFile==0){
      return itemsInMenu;
    } else if (typeOfFile==1) {
      return mapsInMenu;
    } else {
      return new ArrayList<item>();
    }
  }*/
  private int getItemsArrayFromType () {
    if(typeOfFile==0){
      return 0;
    } else if (typeOfFile==1) {
      return 1;
    } else {
      return -1;
    }
  }
  
  //afficher les items (objets ou maps) en fonction du type de truc sélectionné


} // end of class body
