
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
  
  //mouse in 
  boolean mouseIn = false;
  
 
  // Put any methods here in the class body
  
  public void update() {
    
    PGraphics v = getGraphics();
    
    if( !itemsLoaded ) //charge les items à l'ouverture du logiciel. A besoin que cette fenetre soit créée
    {
      view = this;
      global_PGraphics = v;
      loadProject();
      itemsLoaded = true;
    }
   
    viewMouseX = mouseX();
    viewMouseY = mouseY();
 
    v.beginDraw();
    
    v.background(255,255,255,255); 
    
    generateBackground(v);
    createChunkGrid( v );
    CreateBackgroundGrid( v );
    isCarringAnItem( v );
    drawObjects(v);
    createCollision(); //gere l'ajout de collisions
    drawCollisions(v); //affichage des collisions
    
    /*v.save("screen.jpg");*/
    
    IsWindowSelectedFilte(v);
    v.endDraw();
    invalidate(); // view is currently needing to update
  }
  
  public void mouseEntered() { //si la souris entre dans la fenetre
    back_col_idx = 0;
    mouseIn = true;
    invalidate();
    mouseWindow = "mainWindow";
  }

  public void mouseExited() { //si la souris sort de la fenetre
    back_col_idx = 1;
    mouseIn = false;
    validate();
    validateView();
    mouseWindow = "";
  }
  
  public void validateView() //juste un p'tit fix de bug
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
    
    //si la souris est sur un objet, selectionner l'objet
    
    boolean itemTouched = false; //Juste pour verifier si dans la liste un item a bien été touché par la souris
    
    for( int i = 0; i < items.size(); i++ ) //verifier tous les items pour savoir si ils ont été touchés
    {
      if( items.get(i).isClicked() )
      {
        if( keyPressed && keyCode  == CONTROL )
        {
          items.get(i).isSelected( true );
          itemTouched = true;
        }
        else
        {
          for( int k = 0; k < items.size(); k++ )
          {
            items.get(k).isSelected( false );
          }
          items.get(i).isSelected( true );
          lockObj.setSelected( items.get(i).canBeDiplaced() == false );
          posXObj.setText(str(items.get(i).getMapPos().x));
          posYObj.setText(str(items.get(i).getMapPos().y));
          itemTouched = true;
        }
      }
    }
    
    if( !itemTouched ) //si on a cliqué à coté de tout item, alors annuler toutes les selections
    {
      for( int i = 0; i < items.size(); i++ )
      {
        items.get(i).isSelected( false );
      }
    }
  }

  public void mouseDragged() {
    ex = mouseX();
    ey = mouseY();
    if( mousePressed )
    {
      for( int i = 0; i < items.size(); i++ )
      {
        items.get(i).mouseDraggedInView(getGraphics());
      }
    }
    invalidate();    
  }
  
  public void IsWindowSelectedFilte( PGraphics v ) //applique le filtre sur la fenetre
  {
    v.push();
    
    noStroke();
    v.fill(back_col[back_col_idx][0], back_col[back_col_idx][1], back_col[back_col_idx][2], back_col[back_col_idx][3]);
    v.rect(0,0,v.width,v.height);
    
    v.pop();
  }
  
  public void generateBackground( PGraphics v ) //affiche la carte de la map
  {
    mapSize.x = background.width;
    mapSize.y = background.height;
    v.image( background, /*-viewPos.x+(v.width-background.width)/2*/-viewPos.x, /*-viewPos.y+(v.height-background.height)/2*/-viewPos.y, background.width*viewZoom, background.height*viewZoom );
    
  }
  
  public void CreateBackgroundGrid( PGraphics v )//affiche la grille pour le fond de la map
  {
    v.push();
    
    v.stroke( 0, 0, 0, 255);
    
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
  
  public void createChunkGrid( PGraphics v )//affiche la grille des chunks 
  {
    v.push();
    
    v.stroke( 255, 0, 0, 255);
    
    float gridX = 0;
    float gridY = 0;
    
    while( chunkSize.x*viewZoom*gridX-viewPos.x < v.width )
    {
      gridX++;
    }
    while( chunkSize.y*viewZoom*gridY-viewPos.y < v.height )
    {
      gridY++;
    }
    for( int i = 0; i < gridX; i++ )
    {
      v.line( i*chunkSize.x*viewZoom-viewPos.x-1, 0, chunkSize.x*viewZoom*i-viewPos.x-1, v.height);
    }
    for( int k = 0; k < gridY; k++ )
    {
      v.line( 0, chunkSize.y*viewZoom*k-viewPos.y-1, v.width, chunkSize.y*viewZoom*k-viewPos.y-1);
    }
    
    v.pop();
  }
  
  public void isCarringAnItem( PGraphics v )//permet de gerer si l'utilsateur pose un item dans la map
  {
    if( isCarringItem && mousePressed && (mouseButton == LEFT) )//si il tient l'item
    {
      itemInHand.setPos( mouseX(), mouseY() ); //deplacer l'item en main 
      itemInHand.draw(v); //le dessiner
    }
    else
    {
      if(isCarringItem && mouseIn )   //si l'utilisateur a un item mais qu'il ne clique plus ET que la souris est dans la fenetre
      {
        items.add(itemInHand.copy());
        items.get(items.size()-1).setGViewListener(this);
        items.get(items.size()-1).setPGraphics(v);
        items.get(items.size()-1).setPos( mouseX(), mouseY() );
        items.get(items.size()-1).setMapPos( mouseX()/viewZoom+viewPos.x/viewZoom, mouseY()/viewZoom+viewPos.y/viewZoom );
        items.get(items.size()-1).canBeDiplaced(true);
      }
      itemInHand = new item();
      isCarringItem = false;
    }
  }
  
  public void drawObjects( PGraphics v ) //dessiner les objets dans la vue
  {
    for( int i = 0; i < items.size(); i++ )
    {
      items.get(i).draw(v);
      items.get(i).setSize(50); //à enlever dans le futur
      /*items.get(i).setSize(items.get(i).getDefaultSize()); //à mettre dans le futur*/
      items.get(i).setScale(viewZoom); //tres important
      items.get(i).setPos(items.get(i).getMapPos().x*viewZoom-viewPos.x, items.get(i).getMapPos().y*viewZoom-viewPos.y);
    }
    
  }
  
  public void createCollision()
  {
    if( g_addColl )
    {
      
      if(mousePressed && (mouseButton == LEFT) && !g_deletColl &&  !(keyPressed && key == ' ') ){ //creer 

       if( !onCreate )
       {
           println("creating new collision");
           /*additonalCollisions.push_back(sf::RectangleShape());
           rectangles[rectangles.size()-1].setPosition(sf::Vector2f(sf::Mouse::getPosition(window).x*windowZoom+(window.getView().getCenter().x-window.getView().getSize().x/2), sf::Mouse::getPosition(window).y*windowZoom+(window.getView().getCenter().y-window.getView().getSize().y/2)));
           rectangles[rectangles.size()-1].setFillColor(sf::Color(255, 0, 0, 200 ));*/
           onCreateStartPosX = mouseX()/viewZoom+viewPos.x/viewZoom;
           onCreateStartPosY = mouseY()/viewZoom+viewPos.y/viewZoom;
           additonalCollisions.add(mouseX()/viewZoom+viewPos.x/viewZoom);
           additonalCollisions.add(mouseY()/viewZoom+viewPos.y/viewZoom);
           additonalCollisions.add(mouseX()/viewZoom+viewPos.x/viewZoom);
           additonalCollisions.add(mouseY()/viewZoom+viewPos.y/viewZoom);
           
       }
       additonalCollisions.set( additonalCollisions.size()-2, mouseX()/viewZoom+viewPos.x/viewZoom-onCreateStartPosX);
       additonalCollisions.set( additonalCollisions.size()-1, mouseY()/viewZoom+viewPos.y/viewZoom-onCreateStartPosY);
       
       /*rectangles[rectangles.size()-1].setSize(sf::Vector2f(sf::Mouse::getPosition(window).x*windowZoom+(window.getView().getCenter().x-window.getView().getSize().x/2)-onCreateStartPosX, sf::Mouse::getPosition(window).y*windowZoom+(window.getView().getCenter().y-window.getView().getSize().y/2)-onCreateStartPosY));*/
       onCreate = true;
      }
      if(!mousePressed  && onCreate || (mouseButton != LEFT) && onCreate){
        onCreate = false;
        
        if( additonalCollisions.size() > 0 )
        {
          
            if( additonalCollisions.get(additonalCollisions.size()-2) < 0 )
            {
                /*rectangles[rectangles.size()-1].setPosition(  rectangles[rectangles.size()-1].getPosition().x+rectangles[rectangles.size()-1].getSize().x , rectangles[rectangles.size()-1].getPosition().y );
                rectangles[rectangles.size()-1].setSize( sf::Vector2f ( -rectangles[rectangles.size()-1].getSize().x , rectangles[rectangles.size()-1].getSize().y ));*/
                
                additonalCollisions.set(additonalCollisions.size()-4, additonalCollisions.get(additonalCollisions.size()-4)+additonalCollisions.get(additonalCollisions.size()-2));
                additonalCollisions.set(additonalCollisions.size()-2, -additonalCollisions.get(additonalCollisions.size()-2));
                
            }
            if( additonalCollisions.get(additonalCollisions.size()-1) < 0)
            {
                /*rectangles[rectangles.size()-1].setPosition(  rectangles[rectangles.size()-1].getPosition().x , rectangles[rectangles.size()-1].getPosition().y+rectangles[rectangles.size()-1].getSize().y );
                rectangles[rectangles.size()-1].setSize( sf::Vector2f ( rectangles[rectangles.size()-1].getSize().x , -rectangles[rectangles.size()-1].getSize().y ));*/
                
                additonalCollisions.set(additonalCollisions.size()-3, additonalCollisions.get(additonalCollisions.size()-3)+additonalCollisions.get(additonalCollisions.size()-1));
                additonalCollisions.set(additonalCollisions.size()-1, -additonalCollisions.get(additonalCollisions.size()-1));
            }
        }
    }
    }
  }
  
  public void drawCollisions( PGraphics v )
  {
    if( showCollisions)
      {
        v.push();
        v.fill(255, 0, 0, 200);
        v.noStroke();
        for( int i = 0; i < additonalCollisions.size(); i++ )
        {
          v.rect(-viewPos.x+additonalCollisions.get(i)*viewZoom,-viewPos.y+additonalCollisions.get(i+1)*viewZoom, additonalCollisions.get(i+2)*viewZoom, additonalCollisions.get(i+3)*viewZoom);
          i = i+3;
        }
        v.pop();
      }
  }
 
} // end of class body
