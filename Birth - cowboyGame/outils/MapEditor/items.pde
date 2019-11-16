
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
  
  PVector m_pos = new PVector(0, 0);
  
  PGraphics m_v;
  GViewListener m_view;
  
  //constructeurs et surcharges de constructeur
  
  item(){}
  item( PGraphics v, GViewListener view, String pathToObject, float posX, float posY )
  {
    loadObject(pathToObject);
    sprite = loadImage(m_SpritePath);
    m_pos.x = posX;
    m_pos.y = posY;
    m_v = v;
    m_view = view;
  }
  item(  GViewListener view, String pathToObject, float posX, float posY  )
  {
    loadObject(pathToObject);
    sprite = loadImage(m_SpritePath);
    m_pos.x = posX;
    m_pos.y = posY;
    m_view = view;
  }
  item( PGraphics v, GViewListener view,  String pathToObject, PVector pos)
  {
    loadObject(pathToObject);
    sprite = loadImage(m_SpritePath);
    m_pos.x = pos.x;
    m_pos.y = pos.y;
    m_v = v;
    m_view = view;
  }
  item( GViewListener view, String pathToObject, PVector pos )
  {
    loadObject(pathToObject);
    sprite = loadImage(m_SpritePath);
    m_pos.x = pos.x;
    m_pos.y = pos.y;
    m_view = view;
  }
  item( PGraphics v, GViewListener view,  String pathToObject, float posX, float posY, int size )
  {
    loadObject(pathToObject);
    sprite = loadImage(m_SpritePath);
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
    m_pos.x = posX;
    m_pos.y = posY;
    m_size = size;
    m_view = view;
  }
  item( PGraphics v, GViewListener view,  String pathToObject, PVector pos, int size)
  {
    loadObject(pathToObject);
    sprite = loadImage(m_SpritePath);
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
    m_pos.x = pos.x;
    m_pos.y = pos.y;
    m_size = size;
    m_view = view;
  }
  
  //methodes privées
  
  private void loadObject( String pathToObject ) //charger les données de l'objet
  {
    //creation d'un tableau de string qui prendra chaque ligne du fichier de texte
    String[] lines = loadStrings(pathToObject+"/object.id");
  
    println("Fichier de sauvegarde trouvé : " + lines.length + " lignes");
  
    for (int i = 0 ; i < lines.length; i++) { //lire chaque ligne du fichier objet
      
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
  }
  
  //methodes publiques
  
  public void draw() //dessiner l'item
  {
    PVector resizedSize = new PVector( m_size, (float(sprite.height)/float(sprite.width))*m_size); //recalculation de la taille
    PVector resizedPos = new PVector( m_pos.x-resizedSize.x/2, m_pos.y-resizedSize.y/2); //recalculation du centrage par rapport à la taille
    
    if( m_size <= 0 ) //si la taille de l'item n'a pas été changée
    {
      m_v.image(sprite,m_pos.x-sprite.width/2,m_pos.y-sprite.height/2);
    }
    else //sinon l'adapter à sa nouvelle taille
    {
      m_v.image(sprite, resizedPos.x, resizedPos.y, resizedSize.x, resizedSize.y);
    }
    
    if( m_view.mouseX() > m_pos.x-sprite.width/2 && m_view.mouseX() < m_pos.x+sprite.width/2 && m_view.mouseY() > m_pos.y-sprite.height/2 && m_view.mouseY() < m_pos.y+sprite.height/2 && m_size <= 0 ) //foncer l'image quand la souris est dessus 
    {
      //println("over");
      m_v.fill(0, 0, 0, 100);
      m_v.rect(m_pos.x-sprite.width/2,m_pos.y-sprite.height/2, sprite.width, sprite.height);
    }
    else if( m_view.mouseX() > resizedPos.x && m_view.mouseX() < resizedPos.x+resizedSize.x && m_view.mouseY() > resizedPos.y && m_view.mouseY() < resizedPos.y+resizedSize.y && m_size > 0 )
    {
      m_v.fill(0, 0, 0, 100);
      m_v.rect(resizedPos.x, resizedPos.y, resizedSize.x, resizedSize.y);
    }
  }
  
  public void draw(PGraphics v) //surcharge de la fonction précédente
  {
 
    PVector resizedSize = new PVector( m_size, (float(sprite.height)/float(sprite.width))*m_size); //recalculation de la taille
    PVector resizedPos = new PVector( m_pos.x-resizedSize.x/2, m_pos.y-resizedSize.y/2); //recalculation du centrage par rapport à la taille
    
    if( m_size <= 0 )//si la taille de l'item n'a pas été changée
    {
      v.image(sprite,m_pos.x-sprite.width/2,m_pos.y-sprite.height/2);
    }
    else//sinon l'adapter à sa nouvelle taille
    {

      v.image(sprite, resizedPos.x, resizedPos.y, resizedSize.x, resizedSize.y);
      //println(str(m_pos.x-sprite.width/2)+" : "+str(m_size)+" : "+str(m_pos.y-sprite.height/2)+" : "+(float(sprite.height)/float(sprite.width))*m_size);
    }
    
    if( m_view.mouseX() > m_pos.x-sprite.width/2 && m_view.mouseX() < m_pos.x+sprite.width/2 && m_view.mouseY() > m_pos.y-sprite.height/2 && m_view.mouseY() < m_pos.y+sprite.height/2 && m_size <= 0 )//foncer l'image quand la souris est dessus 
    {
      //println("over");
      v.fill(0, 0, 0, 100);
      v.rect(m_pos.x-sprite.width/2,m_pos.y-sprite.height/2, sprite.width, sprite.height);
    }
    else if( m_view.mouseX() > resizedPos.x && m_view.mouseX() < resizedPos.x+resizedSize.x && m_view.mouseY() > resizedPos.y && m_view.mouseY() < resizedPos.y+resizedSize.y && m_size > 0 )
    {
      v.fill(0, 0, 0, 100);
      v.rect(resizedPos.x, resizedPos.y, resizedSize.x, resizedSize.y);
    }
  }
  
  public boolean isMouseOver() //si la souris est au dessus ( souris de l'écran )
  {
    return mouseX > m_pos.x-sprite.width/2 && mouseX < m_pos.x+sprite.width/2 && mouseY > m_pos.y-sprite.height/2 && mouseY < m_pos.y+sprite.height/2;
  }
  
  public boolean isMouseOverView(GViewListener v) //si la souris est au dessus ( souris de la vue )
  {
    return v.mouseX() > m_pos.x-sprite.width/2 && v.mouseX() < m_pos.x+sprite.width/2 && v.mouseY() > m_pos.y-sprite.height/2 && v.mouseY() < m_pos.y+sprite.height/2;
  }
  
  public boolean isMouseOverView() //si la souris est au dessus ( souris de l'écran )
  {
    return m_view.mouseX() > m_pos.x-sprite.width/2 && m_view.mouseX() < m_pos.x+sprite.width/2 && m_view.mouseY() > m_pos.y-sprite.height/2 && m_view.mouseY() < m_pos.y+sprite.height/2; 
  }
  
  public boolean isClicked() //si la souris est au dessus ( souris de l'écran )
  {
    if(m_view.mouseX() > m_pos.x-sprite.width/2 && m_view.mouseX() < m_pos.x+sprite.width/2 && m_view.mouseY() > m_pos.y-sprite.height/2 && m_view.mouseY() < m_pos.y+sprite.height/2 && mousePressed && (mouseButton == LEFT))
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
    NewCopy.sprite = loadImage(m_SpritePath);
    NewCopy.m_pos = new PVector(0, 0);
    NewCopy.m_v = m_v;
    NewCopy.m_view = m_view;
    
    println("item copied");
    return NewCopy; 
  }
  
  //methodes set
  
  public void setPos( float posX, float posY )
  {
    m_pos.x = posX;
    m_pos.y = posY;
  }
  
  public void setPos( PVector pos )
  {
    m_pos = pos;
  }
  
  
  //methodes getters 
  
  public String getName()
  {
    return m_name;
  }
  public String getId()
  {
    return m_name;
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
  
  
}

//class des items pouvant être déplacés

public class draggableItem extends item
{
  draggableItem()
  {
  }
  
  //methodes
  
  public void draw()
  {
    if( m_size <= 0 ) //si la taille de l'item n'a pas été changée
    {
      m_v.image(sprite,m_pos.x-sprite.width/2,m_pos.y-sprite.height/2);
    }
    else //sinon l'adapter à sa nouvelle taille
    {
      m_v.image(sprite,m_pos.x-sprite.width/2,m_pos.y-sprite.height/2, m_size,  (sprite.height/sprite.width)*m_size);
    }
    this.setPos(mouseX,mouseY);
    
  }
  
  public void draw(PGraphics v) //surcharge de la fonction précédente
  {
    if( m_size <= 0 )//si la taille de l'item n'a pas été changée
    {
      v.image(sprite,m_pos.x-sprite.width/2,m_pos.y-sprite.height/2);
    }
    else//sinon l'adapter à sa nouvelle taille
    {
      v.image(sprite,m_pos.x-sprite.width/2,m_pos.y-sprite.height/2, m_size, (sprite.height/sprite.width)*m_size);
    }
    
    this.setPos(mouseX,mouseY);
    
  }
  
  public void copy( item v )
  {
    m_id = v.getId();
    m_name = v.getName();
    m_type = v.getType();
    m_animated = v.getAnimated();
    m_SpritePath = v.getSpritePath();
    m_CollisionsPath = v.getCollisionsPath();
  }
  
}
