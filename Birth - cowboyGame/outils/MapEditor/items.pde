
//classe des items à afficher

public class item
{
  
  //attributs
  
  String m_id = "";
  String m_name = "";
  String m_type = "";
  boolean m_animated = false;
  String m_SpritePath = "";
  String m_CollisionsPath = "";
  
  int m_nbSprite = 1;
  float m_size = 0;
  PImage sprite;
  
  PVector m_pos = new PVector(0, 0); //position réelle
  PVector m_mapPos = new PVector(0, 0); //position sur la vue
  
  PGraphics m_v;
  GViewListener m_view;
  
  boolean m_canBeDiplaced; //l'objet peut-il etre déplacé
  boolean m_dragging = false; //pour que l'on puisse deplacer l'objet jusqu'à ce qu'on relache la souris
  boolean m_isSelected = false; //si l'on clique sur l'item, il est selectionné
  
  ArrayList<Float> m_collisions = new ArrayList<Float>(); //posx, posY, sizeX, sizeY, posX2, posY2, etc....
  
  //constructeurs et surcharges de constructeur////////////////////////////////////////////////////////////////////////////////CONSTRUCTEURS CONSTRUCTEURS CONSTRUCTEURS////////////////////////////////////////////////
  
  item(){
  
    if(sprite == null)
    {
      sprite = loadImage("assets/img/notFound/img.png");
    }
    
    m_pos.x = 0;
    m_pos.y = 0;
    
  }
  
  item( PGraphics v, GViewListener view ){
  
    if(sprite == null)
    {
      sprite = loadImage("assets/img/notFound/img.png");
    }
    
    m_pos.x = 0;
    m_pos.y = 0;
    m_v = v;
    m_view = view;
  }
  
  item( PGraphics v, GViewListener view, String pathToObject, float posX, float posY )
  {
    loadObject(pathToObject);
    
    sprite = loadImage(m_SpritePath);
    if(sprite == null)
    {
      sprite = loadImage("assets/img/notFound/img.png");
    }
    
    m_pos.x = posX;
    m_pos.y = posY;
    m_v = v;
    m_view = view;
  }
  
  item(  GViewListener view, String pathToObject, float posX, float posY  )
  {
    loadObject(pathToObject);
    sprite = loadImage(m_SpritePath);
    if(sprite == null)
    {
      sprite = loadImage("assets/img/notFound/img.png");
    }
    m_pos.x = posX;
    m_pos.y = posY;
    m_view = view;
  }
  
  item( PGraphics v, GViewListener view,  String pathToObject, PVector pos)
  {
    loadObject(pathToObject);
    sprite = loadImage(m_SpritePath);
    if(sprite == null)
    {
      sprite = loadImage("assets/img/notFound/img.png");
    }
    m_pos.x = pos.x;
    m_pos.y = pos.y;
    m_v = v;
    m_view = view;
  }
  item( GViewListener view, String pathToObject, PVector pos )
  {
    loadObject(pathToObject);
    sprite = loadImage(m_SpritePath);
    if(sprite == null)
    {
      sprite = loadImage("assets/img/notFound/img.png");
    }
    m_pos.x = pos.x;
    m_pos.y = pos.y;
    m_view = view;
  }
  item( PGraphics v, GViewListener view,  String pathToObject, float posX, float posY, int size )
  {
    loadObject(pathToObject);
    sprite = loadImage(m_SpritePath);
    if(sprite == null)
    {
      sprite = loadImage("assets/img/notFound/img.png");
    }
    m_pos.x = posX;
    m_pos.y = posY;
    m_size = size;
    m_v = v;
    m_view = view;
  }
  item( GViewListener view, String pathToObject, float posX, float posY, int size  )
  {
    loadObject(pathToObject);
        
    sprite = loadImage(m_SpritePath);
    if(sprite == null)
    {
      sprite = loadImage("assets/img/notFound/img.png");
    }
    
    m_pos.x = posX;
    m_pos.y = posY;
    m_size = size;
    m_view = view;
  }
  item( PGraphics v, GViewListener view,  String pathToObject, PVector pos, int size)
  {
    loadObject(pathToObject);
    sprite = loadImage(m_SpritePath);
    if(sprite == null)
    {
      sprite = loadImage("assets/img/notFound/img.png");
    }
    m_pos.x = pos.x;
    m_pos.y = pos.y;
    m_size = size;
    m_v = v;
    m_view = view;
  }
  item( GViewListener view, String pathToObject, PVector pos, int size )
  {
    loadObject(pathToObject);
    sprite = loadImage(m_SpritePath);
    if(sprite == null)
    {
      sprite = loadImage("assets/img/notFound/img.png");
    }
    m_pos.x = pos.x;
    m_pos.y = pos.y;
    m_size = size;
    m_view = view;
  }
  
  //methodes privées//////////////////////////////////////////////////////////////////////////////////////METHODES METHODES METHODES/////////////////////////////////////////////////////////////////////////////////////
  
  private void loadObject( String pathToObject ) //charger les données de l'objet
  {
    //creation d'un tableau de string qui prendra chaque ligne du fichier de texte
    String[] lines = loadStrings(pathToObject+"/object.id");
    
    println("Fichier de sauvegarde trouvé : " + lines.length + " lignes");
  
    for (int i = 0 ; i < lines.length; i++) { //lire chaque ligne du fichier objet id
     
      try{ //on essaye de lire l'objet si possible
      
        String simpleRead = (lines[i].substring(lines[i].indexOf("[")+1, lines[i].indexOf("]"))); //valeure sauvegardée pour une variable enregistrée sous une forme .nom[valeure]
      
        if( lines[i].contains(".id[") ) //charger la taille de chunk enregistrée
        {
          m_id = simpleRead; //remettre la variable à a valeure sauvegardée
        }
        if( lines[i].contains(".name[") )
        {
          m_name = simpleRead; //remettre la variable à a valeure sauvegardée
        }
        if( lines[i].contains(".type[") )
        {
          m_type = simpleRead; //remettre la variable à a valeure sauvegardée
        }
        if( lines[i].contains(".animated[") )
        {
          m_animated = boolean(simpleRead); //remettre la variable à a valeure sauvegardée
        }
        if( lines[i].contains(".spritePath[") )
        {
          m_SpritePath = simpleRead; //remettre la variable à a valeure sauvegardée
        }
        if( lines[i].contains(".collisionsPath[") )
        {
          m_CollisionsPath = simpleRead; //remettre la variable à a valeure sauvegardée
        }
        if( lines[i].contains("nbSprite.[") )
        {
          m_nbSprite = int(simpleRead); //remettre la variable à a valeure sauvegardée
        }
        
      }
      catch(java.lang.RuntimeException e) //sinon faire comprendre qu'il y a un probleme avec le fichier
      {
        println("!!!! LE FICHIER OBJET EN LECTURE EST CORROMPU !!!!");
        e.printStackTrace();
      }
    }
      
        String[] coll = loadStrings(pathToObject+"/collisions/object.coll"); //charger le chemin vers le fichier de collision
        
        for (int i = 0 ; i < coll.length; i++) { //lire chaque ligne du fichier de collision
          try{ //on essaye de lire l'objet si possible
          
           /*println("creating new collision");*/
           
    
           int buff1 = coll[i].indexOf('[');
           int buff2 = coll[i].indexOf('-');
           int buff3 = coll[i].indexOf('|');
           int buff4 = coll[i].indexOf('-', coll[i].indexOf('-')+1);
           int buff5 = coll[i].indexOf(']');
    
           //println("Setting position : x = " + coll[i].substring(buff1+1, buff2-buff1-1 + buff1+1) + "  | y = " + coll[i].substring(buff2+1, buff3-buff2-1 + buff2+1));
           m_collisions.add(float(coll[i].substring(buff1+1, buff2-buff1-1 + buff1+1)));
           m_collisions.add(float(coll[i].substring(buff2+1, buff3-buff2-1 + buff2+1)));
           //println("Setting size : x = " + coll[i].substring(buff3+1, buff4-buff3-1 + buff3+1 ) + "  | y = " + coll[i].substring(buff4+1, buff5-buff4-1 + buff4+1));
           m_collisions.add(float(coll[i].substring(buff3+1, buff4-buff3-1 + buff3+1 )));
           m_collisions.add(float(coll[i].substring(buff4+1, buff5-buff4-1 + buff4+1)));
    
          }
          catch(java.lang.RuntimeException e) //sinon faire comprendre qu'il y a un probleme avec le fichier
          {
            println("!!!! LE FICHIER DE COLLISION DE "+m_name+" EST INTROUVABLE OU CORROMPU !!!!");
            e.printStackTrace();
          } 
      }
 }
  
  //methodes publiques
  
  public void mouseDraggedInView( PGraphics v ) {
    if( m_canBeDiplaced )
    {
      dragItem(v);
    }
  }
  
  public void draw(PGraphics v) //surcharge de la fonction précédente
  {
 
    PVector resizedSize = new PVector( m_size, (float(sprite.height)/float(sprite.width))*m_size); //recalculation de la taille
    PVector resizedPos = new PVector( m_pos.x-resizedSize.x/2, m_pos.y-resizedSize.y/2); //recalculation du centrage par rapport à la taille
    
    if( m_size <= 0 )//si la taille de l'item n'a pas été changée
    {
      v.image(sprite,m_pos.x-sprite.width/2,m_pos.y-sprite.height/2);
      
      if( showCollisions)
      {
        v.push();
        v.fill(255, 0, 0, 200);
        for( int i = 0; i < m_collisions.size(); i++ )
        {
          v.rect(m_pos.x-sprite.width/2+m_collisions.get(i), m_pos.y-sprite.height/2+m_collisions.get(i+1), m_collisions.get(i+2), m_collisions.get(i+3));
          i = i+3;
        }
        v.pop();
      }
    }
    else//sinon l'adapter à sa nouvelle taille
    {

      v.image(sprite, resizedPos.x, resizedPos.y, resizedSize.x, resizedSize.y);
      //println(str(m_pos.x-sprite.width/2)+" : "+str(m_size)+" : "+str(m_pos.y-sprite.height/2)+" : "+(float(sprite.height)/float(sprite.width))*m_size);
      if( showCollisions)
      {
        v.push();
        v.noStroke();
        v.fill(255, 0, 0, 200);
        for( int i = 0; i < m_collisions.size(); i++ )
        {
          v.rect(resizedPos.x+(m_collisions.get(i)/sprite.width)*m_size, resizedPos.y+(m_collisions.get(i+1)/(sprite.height))*(float(sprite.height)/float(sprite.width))*m_size, m_collisions.get(i+2)/sprite.width*m_size, m_collisions.get(i+3)/sprite.height*(float(sprite.height)/float(sprite.width))*m_size);
          i = i+3;
        }
        v.pop();
      }
    }
    
    if( isMouseOverView() && m_size <= 0 && isInEditionMode || m_isSelected && m_size <= 0 && isInEditionMode)//foncer l'image quand la souris est dessus ( si l'objet est modifiable )
    {
      //println("over");
      v.fill(0, 0, 0, 100);
      v.rect(m_pos.x-sprite.width/2,m_pos.y-sprite.height/2, sprite.width, sprite.height);
    }
    else if(isMouseOverView() && m_size > 0 && isInEditionMode || m_isSelected && m_size > 0 && isInEditionMode  )
    {
      v.fill(0, 0, 0, 100);
      v.rect(resizedPos.x, resizedPos.y, resizedSize.x, resizedSize.y);
    }
    
    if( m_canBeDiplaced )
      stopDragingItem(v);
  }
  
  
  public boolean isMouseOver() //si la souris est au dessus ( souris de l'écran )
  {
    return mouseX > m_pos.x-sprite.width/2 && mouseX < m_pos.x+sprite.width/2 && mouseY > m_pos.y-sprite.height/2 && mouseY < m_pos.y+sprite.height/2;
  }
  
  /*public boolean isMouseOverView(GViewListener v) //si la souris est au dessus ( souris de la vue ) OBSOLETE
  {
    return v.mouseX() > m_pos.x-sprite.width/2 && v.mouseX() < m_pos.x+sprite.width/2 && v.mouseY() > m_pos.y-sprite.height/2 && v.mouseY() < m_pos.y+sprite.height/2;
  }*/
  
  public boolean isMouseOverView() //si la souris est au dessus ( souris de l'écran )
  {
    PVector resizedSize = new PVector( m_size, (float(sprite.height)/float(sprite.width))*m_size); //recalculation de la taille
    PVector resizedPos = new PVector( m_pos.x-resizedSize.x/2, m_pos.y-resizedSize.y/2); //recalculation du centrage par rapport à la taille
    if( m_size > 0 )
    {
      return m_view.mouseX() > resizedPos.x && m_view.mouseX() < resizedPos.x+resizedSize.x && m_view.mouseY() > resizedPos.y && m_view.mouseY() < resizedPos.y+resizedSize.y;
    }
    return m_view.mouseX() > m_pos.x-sprite.width/2 && m_view.mouseX() < m_pos.x+sprite.width/2 && m_view.mouseY() > m_pos.y-sprite.height/2 && m_view.mouseY() < m_pos.y+sprite.height/2; 
  }
  
  public boolean isClicked() //si la souris est au dessus ( souris de l'écran )
  {
      if( isMouseOverView() && mousePressed && (mouseButton == LEFT))
      {
        return true;
      }
    
      return false;
    
  }
  
  public item copy() //copier les attributs d'un autre item
  {
    
    item NewCopy = new item();
    
    NewCopy.m_id = m_id;
    NewCopy.m_name = m_name;
    NewCopy.m_type = m_type;
    NewCopy.m_animated = m_animated;
    NewCopy.m_SpritePath = m_SpritePath;
    NewCopy.m_CollisionsPath = m_CollisionsPath;

    NewCopy.m_size = m_size;
    if(sprite != null)
    {
      NewCopy.sprite = loadImage(m_SpritePath);
    }
    else
    {
      NewCopy.sprite = loadImage("assets/img/notFound/img.png");
    }
    
    NewCopy.m_pos = new PVector(0, 0);
    NewCopy.m_pos.x = m_pos.x;
    NewCopy.m_pos.y = m_pos.y;
    NewCopy.m_v = m_v;
    NewCopy.m_view = m_view;
    NewCopy.m_collisions = new ArrayList<Float>(m_collisions);
    
    println("item copied");
    return NewCopy; 
  }
  
  private void dragItem( PGraphics v ) //à n'utiliser que dans la vue principale
  {
    if( this.isClicked() && !isReallyCarringItem && !isCarringItem && isInEditionMode ) //si l'utilisateur n'a pas d'item en main et si il est autorisé à en avoir un
    {
      m_dragging = true;
      isReallyCarringItem = true;
    }
     
    if( m_dragging )
    {
      this.setMapPos( viewMouseX/viewZoom+viewPos.x/viewZoom, viewMouseY/viewZoom+viewPos.y/viewZoom );
      for( int i = 0; i < items.size(); i++ )
      {
         if( items.get(i).isSelected() )
         {
            posXObj.setText(str(items.get(i).getMapPos().x));
            posYObj.setText(str(items.get(i).getMapPos().y));
         }
      }
    }
      
    if( m_dragging && !mousePressed )
    {
      m_dragging = false;
      isReallyCarringItem =false;
    }
  }
  
  private void stopDragingItem( PGraphics V )
  {
    if( m_dragging && !mousePressed )
    {
      m_dragging = false;
      isReallyCarringItem =false;
    }
  }
  
  public void removeCollisions()
  {
    m_collisions.clear();
  }
  
  //methodes set////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////SET SET SET//////////////////////////////////////////////////////////////////
  
  public void setPos( float posX, float posY )
  {
    m_pos.x = posX;
    m_pos.y = posY;
  }
  
  public void setPos( PVector pos )
  {
    m_pos = pos;
  }
  
  public void setMapPos( float posX, float posY )
  {
    m_mapPos.x = posX;
    m_mapPos.y = posY;
    
  }
  
  public void setMapPos( PVector pos )
  {
    m_mapPos = pos;
  }
  
  
  public void setGViewListener( GViewListener view )
  {
    m_view = view;
  }
  
  public void setPGraphics( PGraphics v )
  {
    m_v = v ;
  }
  
  public void setSize( float s )
  {
    m_size = s;
  }
  
  public void setScale( float s )
  {
    m_size = s*m_size;
  }
  
  public void canBeDiplaced( boolean b )
  {
    m_canBeDiplaced = b;
  }
  
  public void isSelected( boolean b )
  {
    m_isSelected = b;
  }
  
  public void setName( String s )
  {
    m_name = s;
  }
  
  public void setSpritePath( String s )
  {
    m_SpritePath = s;
    
    sprite = loadImage(m_SpritePath);
    if(sprite == null)
    {
      sprite = loadImage("assets/img/notFound/img.png");
    }
  }
  
  public void setId( String s )
  {
    m_id = s;
  }
  
  public void setType( String s )
  {
    m_type = s;
  }
  
  public void setCollisions( String s )
  {
    int buff1 = s.indexOf('_');
    int buff2 = s.indexOf('-');
    int buff3 = s.indexOf('|');
    int buff4 = s.indexOf('-', s.indexOf('-')+1);
    int buff5 = s.indexOf('_', s.indexOf('_')+1);
    
    /*println("Setting position : x = " + s.substring(buff1+1, buff2-buff1-1 + buff1+1) + "  | y = " + s.substring(buff2+1, buff3-buff2-1 + buff2+1));*/
    m_collisions.add(float(s.substring(buff1+1, buff2-buff1-1 + buff1+1)));
    m_collisions.add(float(s.substring(buff2+1, buff3-buff2-1 + buff2+1)));
    /*println("Setting size : x = " + s.substring(buff3+1, buff4-buff3-1 + buff3+1 ) + "  | y = " + s.substring(buff4+1, buff5-buff4-1 + buff4+1));*/
    m_collisions.add(float(s.substring(buff3+1, buff4-buff3-1 + buff3+1 )));
    m_collisions.add(float(s.substring(buff4+1, buff5-buff4-1 + buff4+1)));
  }
  
  //methodes getters ///////////////////////////////////////////////////////////////////////////////////////GET GET GET  ///////////////////////////////////////////////////////////////////////////////////////////////
  
  public String getName()
  {
    return m_name;
  }
  public String getId()
  {
    return m_id;
  }
  public String getType()
  {
    return m_type;
  }
  public boolean getAnimated()
  {
    return m_animated;
  }
  public String getSpritePath()
  {
    return m_SpritePath;
  }
  public String getCollisionsPath()
  {
    return m_CollisionsPath;
  }
  public PVector getPos()
  {
    return m_pos;
  }
  public float getMapPosX()
  {
    return m_mapPos.x;
    
  }
  public float getMapPosY()
  {
    return m_mapPos.y;
  }
  
  public PVector getMapPos()
  {
    return m_mapPos;
  }
  
  public boolean isSelected()
  {
    return m_isSelected;
  }

  public boolean canBeDiplaced()
  {
    return m_canBeDiplaced;
  }
  
  public int getDefaultSize()
  {
    return sprite.width;
  }
  
  public float getSize()
  {
    return m_size;
  }
  
  public ArrayList<Float> getCollisions()
  {
    return m_collisions;
  }
  
  public String getStringCollisions()
  {
    String s = "";
    
    for( int i = 0; i < m_collisions.size(); i++ )
    {
        s += ".coll[_" + str(m_collisions.get(i))+ "-" + str(m_collisions.get(i+1)) + "|" + str(m_collisions.get(i+2)) + "-" + str(m_collisions.get(i+3)) + "_]\n";
        i += 3;
    }
    
    return s;
  }
  
}
