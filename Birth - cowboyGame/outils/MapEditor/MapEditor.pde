// Need G4P library
import g4p_controls.*;
// You can remove the PeasyCam import if you are not using
// the GViewPeasyCam control or the PeasyCam library.


//pour avoir les trucs java
import java.util.*;
import javax.swing.JOptionPane;

//objects

MapReader readMap;
BrowserHandler browserWindow;

//Variables globales

PVector winSizeInit = new PVector( displayWidth, displayHeight ); //taille intitiale de la fenetre ( ne pas oublier de changer la taille de la fenetre quand changé ) -> size( x, y, osef );

float[] panels_in_main_old = new float [3];
GPanel[] panels_in_main_new = new GPanel [3];


public void setup(){
  
  size( 1600, 900, JAVA2D );
  smooth(0);
  createGUI();
  customGUI();
  loadParam();
  
  surface.setResizable(true); //pour changer la taille
  //surface.resize(displayWidth,displayHeight); //ça marche pas :/
  
  
  // Place your setup code here
  PImage icon = loadImage("assets/img/icon/logo.png");
  surface.setIcon(icon);
  
  //charger les curseurs
  cursorMoveImg = loadImage("assets/img/cursor/move.png");
  cursorGrabImg = loadImage("assets/img/cursor/grab.png");
  initializeArrayOfPanels();
  
  // Setup 2D view and viewer
  readMap = new MapReader();
  browserWindow = new BrowserHandler();
  
  view1.addListener(readMap); //pour gérer les évenements de la fenetre
  view1.setVisible(true); //la rendre visible, évidement
  browser.addListener(browserWindow);
  browser.setVisible(true);
  
  main_panel.setCollapsed(true);
  settings_panel.setCollapsed(true);
  exportPannel.setCollapsed(true);
}


public void draw(){
  background(230);
  int sizex = int(width/1.5);
  int sizey = int(height/1.5);
  
  
  getInteractionEvent(); //Pour les intéractions avec l'interface
  GuiCollidingHandler(); ///pour vérifier que les fenetres ne se montent pas l'une sur l'autre
  updateCursor(); //mettre à jour le curseur ( la main déguelasse )
  updateInternalVar(); //mettre à jour l'affichage des variables internes
  
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}

public void moveView( float X, float Y )
{
  viewPos.x += X;
  viewPos.y += Y;
}

public void viewSetPos( float X, float Y )
{
  viewPos.x = X;
  viewPos.y = Y;
}

public void getInteractionEvent() //inputs
{
  if( mousePressed ){
  if ( keyPressed && key  == ' ' || mousePressed && (mouseButton == CENTER)) { //deplacer la vue
    if( !deplacement )
     {
       //println("deplacement");
       deplacement = true;
       lastMousePos.x = viewMouseX;
       lastMousePos.y = viewMouseY;
       lastViewPos.x = viewPos.x;
       lastViewPos.y = viewPos.y;
    }
    viewSetPos( lastViewPos.x-viewMouseX+lastMousePos.x, lastViewPos.y-viewMouseY+lastMousePos.y );
  }
 }
 else
 {
   deplacement = false;
   //println("!deplacement");
 }
 
 if( keyPressed && key == DELETE )
 {
   for( int i = 0; i < items.size(); i++ )
  {
     if( items.get(i).isSelected() )
     {
        items.remove(i);
     }
  }
 }
 
}

public void updateCursor()
{
  
  if ( keyPressed && key  == ' ')
  {
    if( mouseX > view1.getX() && mouseY < view1.getY()+view1.getHeight() )
    {
      if( mousePressed )
      {
        cursor(cursorGrabImg);
      }
      else
      {
        cursor(cursorMoveImg);
      }
    }
    
  }
  else if(  mousePressed && (mouseButton == CENTER) )
  {
    cursor(cursorGrabImg);
  }
  else if( mouseX > view1.getX() && mouseY < view1.getY()+view1.getHeight() )
  {
    cursor(CROSS);
  }
  else
  {
    cursor(ARROW);
  }
}

void updateInternalVar()
{
  label1.setText("Mouse position : "+viewMouseX+".x    ||     " + viewMouseY + ".y");
  wordpos.setText("Coordonées de la caméra : "+viewPos.x+".x    ||     " + viewPos.y + ".y");
  zoomView.setText("Zoom de la caméra : "+viewZoom);
}

void mouseWheel(MouseEvent event) {
  
  float e = event.getCount();
  
  if (mouseWindow == "mainWindow") {
  PVector mouseinWorld = new PVector(
    (viewMouseX * viewZoom) - viewPos.x, 
    (viewMouseY * viewZoom) - viewPos.y);
    
  PVector oldMapSize = new PVector( mapSize.x, mapSize.y );
  
  if( e > 0 )
  {
    camZoom.setText(str(viewZoom*100));
    viewZoom *= 1.04;
    viewSetPos( (viewMouseX * viewZoom) - mouseinWorld.x,  (viewMouseY * viewZoom) - mouseinWorld.y );
  }

  if( e < 0 )
  {
    camZoom.setText(str(viewZoom*100));
    viewZoom *= 1/1.04;
    viewSetPos( -((oldMapSize.x-mapSize.x*viewZoom)/2)  , -((oldMapSize.y-mapSize.y*viewZoom)/2)  );
  }
  }

  if (mouseWindow == "Browser") { //Pour le browser en bas, gere le scroll
    int coefScroll = 25;
     
    // println(scroller.getPosX());
     //scroll gauche 
    if (e<0 && scroller.getPosX()>0) {
      
          scroller.setPosX(scroller.getPosX()-coefScroll);
          //println("scroll gauche = "+(scroller.getPosX()+e*coefScroll));
          scroller.setPosView(scroller.getPosView()+(coefScroll*(widthOfItems / totalWidth)));
    }
    //scroll droit
    if (e>0 &&  scroller.getPosX()<1600-scroller.getWidth()) {
     // println("scroll droit :"+(scroller.getPosX()+coefScroll));
          scroller.setPosX(scroller.getPosX()+coefScroll);
          scroller.setPosView(scroller.getPosView()-(coefScroll*(widthOfItems / totalWidth)));
    }
  }
}

void loadParam()
{
  //creation d'un tableau de string qui prendra chaque ligne du fichier de texte
  String[] lines = loadStrings("saveOptions/mapMaker.param");
  
  println("Fichier de sauvegarde trouvé : " + lines.length + " lignes");
  
  for (int i = 0 ; i < lines.length; i++) {
    
    if( lines[i].contains("chunkSize") ) //charger la taille de chunk enregistrée
    {
      chunkSize.x = float(lines[i].substring(lines[i].indexOf("[")+1, lines[i].indexOf("|"))); //remettre la variable à a valeure sauvegardée
      chunkX.setText(str(chunkSize.x)); //afficher le nombre dans l'interface
      chunkSize.y = float(lines[i].substring(lines[i].indexOf("|")+1, lines[i].indexOf("]"))); //remettre la variable à a valeure sauvegardée
      chunkY.setText(str(chunkSize.y)); //afficher le nombre dans l'interface
    }
    
  }
}
void saveParam() //sauvegarde des différentes variables
{
  output = createWriter("saveOptions/mapMaker.param"); //ouvrir le flux
  
  output.println( "chunkSize [" + chunkSize.x +"|"+chunkSize.y + "]"); // Write the coordinate to the file
  
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  
  println("saved");
}

public void dispose() { //fonction appellée à la fermeture de la fenetre
  saveParam();
  println("shutting down...");
  super.stop();
} 
  
public void saveProject(File path) //sauvegarde du projet
{
  
  println("saving project");
  //output = createWriter("map/editor.save"); //ouvrir le flux
  output = createWriter(path.getPath()+".save"); //ouvrir le flux
  
  for( int i = 0; i < items.size(); i++ ) //sauvegarder chaque item placé sur la map
  {
    output.println("obj{");
    output.println(".name["+items.get(i).getName()+"]");
    output.println(".posX["+items.get(i).getMapPos().x+"]");
    output.println(".posY["+items.get(i).getMapPos().y+"]");
    output.println(".size["+items.get(i).getSize()+"]");
    output.print(items.get(i).getStringCollisions());
    output.println(".spritepath["+items.get(i).getSpritePath()+"]");
    output.println(".id["+items.get(i).getId()+"]");
    output.println(".type["+items.get(i).getType()+"]");
    output.println(".movable["+items.get(i).canBeDiplaced()+"]");
    output.println("}");
  }
  
  output.println("GColl{");
  for( int i = 0; i < additonalCollisions.size(); i+=4 ) //sauvegarder chaque item placé sur la map
  {
    if( additonalCollisions.get(i+2) != 0 && additonalCollisions.get(i+3) != 0)
    {
      output.println(".Gcoll[_" + str(additonalCollisions.get(i))+ "$" + str(additonalCollisions.get(i+1)) + "|" + str(additonalCollisions.get(i+2)) + "$" + str(additonalCollisions.get(i+3)) + "_]");
    }
  }
  output.println("}");
  
  
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  println("project saved");
  JOptionPane.showMessageDialog(null, "Le fichier a bien été enregistré !");
}

public void loadProject(File project) //chargement de projet
{
  try{
   // String[] lines = loadStrings("map/editor.save");
    String[] lines = loadStrings(project.getPath());
    
    int nbObjet = 0;
    println("Fichier de projet trouvé : " + lines.length + " lignes");
    
    for (int i = 0 ; i < lines.length; i++) {
      
    /*println("ligne \""+lines[i]+"\"");*/
    String simpleRead = "";
    if(lines[i].contains("[") )
    {
      simpleRead = (lines[i].substring(lines[i].indexOf("[")+1, lines[i].indexOf("]"))); //valeure sauvegardée pour une variable enregistrée sous une forme .nom[valeure]
    }
    
    if( lines[i].contains("obj{") )
    {
      /*println("addItem");*/
      nbObjet++;
      items.add(new item(global_PGraphics,view));
    }
    if( lines[i].contains(".name[") )
    {
      items.get(items.size()-1).setName(simpleRead);
    }
    if( lines[i].contains(".posX[") )
    {
      items.get(items.size()-1).setPos(float(simpleRead), 0);
    }
    if( lines[i].contains(".posY[") )
    {
      items.get(items.size()-1).setPos(items.get(items.size()-1).getPos().x, float(simpleRead));
      items.get(items.size()-1).setMapPos(items.get(items.size()-1).getPos().x, items.get(items.size()-1).getPos().y);
    }
    if( lines[i].contains(".size[") )
    {
      items.get(items.size()-1).setSize(int(simpleRead));
    }
    if( lines[i].contains(".coll[") )
    {
      items.get(items.size()-1).setCollisions(simpleRead);
    }
    if( lines[i].contains(".spritepath[") )
    {
      items.get(items.size()-1).setSpritePath(simpleRead);
    }
    if( lines[i].contains(".id[") )
    {
      items.get(items.size()-1).setId(simpleRead);
    }
    if( lines[i].contains(".type[") )
    {
      items.get(items.size()-1).setType(simpleRead);
    }
    if( lines[i].contains(".movable[") )
    {
      items.get(items.size()-1).canBeDiplaced(boolean(simpleRead));
    }
    
    if( lines[i].contains(".Gcoll[") )
    {
      int buff1 = simpleRead.indexOf('_');
      int buff2 = simpleRead.indexOf('$');
      int buff3 = simpleRead.indexOf('|');
      int buff4 = simpleRead.indexOf('$', simpleRead.indexOf('$')+1);
      int buff5 = simpleRead.indexOf('_', simpleRead.indexOf('_')+1);
      
      /*println("Setting position : x = " + s.substring(buff1+1, buff2-buff1-1 + buff1+1) + "  | y = " + s.substring(buff2+1, buff3-buff2-1 + buff2+1));*/
      additonalCollisions.add(float(simpleRead.substring(buff1+1, buff2-buff1-1 + buff1+1)));
      additonalCollisions.add(float(simpleRead.substring(buff2+1, buff3-buff2-1 + buff2+1)));
      /*println("Setting size : x = " + s.substring(buff3+1, buff4-buff3-1 + buff3+1 ) + "  | y = " + s.substring(buff4+1, buff5-buff4-1 + buff4+1));*/
      additonalCollisions.add(float(simpleRead.substring(buff3+1, buff4-buff3-1 + buff3+1 )));
      additonalCollisions.add(float(simpleRead.substring(buff4+1, buff5-buff4-1 + buff4+1)));
      
      if( additonalCollisions.get(additonalCollisions.size()-2) <= 0 && additonalCollisions.get(additonalCollisions.size()-1) <= 0 ) //si la taille de la collision est nulle, l'effacer
      {
        for( int k = 0; k < 4; k++ )
          additonalCollisions.remove(additonalCollisions.size()-1);
      }
    }
    
  }
  println(nbObjet+ " objets chargés.");
  openedProject = project; //garde le chemin du fichier chargé
  }
  catch( java.lang.RuntimeException e )
  {
    println("Le fichier de projet a rencontré un problème ou est introuvable.");
  }
  
}

public boolean exportMap( File selection )
{
  
  if (selection == null) {
    println("L'utilisateur a annulé son choix");
    return false;
  } else {
    
    String path = selection.getAbsolutePath();
    String projectName = selection.getName();
    
    PrintWriter outputColl;
    PrintWriter outputEnt;
    PrintWriter outputObj;
    
    //Enlever les extensions si l'utilisateur en a mit//
    if( path.indexOf(".") != -1 )
    {
      path = path.substring(0,path.indexOf("."));
    }
    if( projectName.indexOf(".") != -1 )
    {
      projectName = projectName.substring(0,projectName.indexOf("."));
    }
    path = path + "/"; //mettre à jour le chemin pour qu'il soit le bon
    
    println("User selected " + projectName);
    
    outputColl = createWriter(path+"collisions.coll"); //ouvrir le flux
    outputEnt = createWriter(path+"entities.ent"); //ouvrir le flux
    outputObj = createWriter(path+"objects.objt"); //ouvrir le flux
  
    //SAUVEGARDER LES COLLISIONS
    for( int i = 0; i < additonalCollisions.size(); i+=4 ) //sauvegarder chaque item placé sur la map
    {
      if( additonalCollisions.get(i+2) != 0 && additonalCollisions.get(i+3) != 0)
      {
        outputColl.println("_" + str(additonalCollisions.get(i))+ "$" + str(additonalCollisions.get(i+1)) + "|" + str(additonalCollisions.get(i+2)) + "$" + str(additonalCollisions.get(i+3)) + "_");
      }
    }
    for( int i = 0; i < items.size(); i++ ) //sauvegarder chaque item placé sur la map
    {  
      ArrayList<Float> collToSave = items.get(i).getCollisions();
      String s = "";
    
      for( int k = 0; k < collToSave.size(); k++ )
      {
          s += "_" + str(collToSave.get(k)+items.get(i).getPos().x)+ "$" + str(collToSave.get(k+1)) + "|" + str(collToSave.get(k+2)+items.get(i).getPos().y) + "$" + str(collToSave.get(k+3)) + "_\n";
          k += 3;
      }
      outputColl.print(s);
    }
  
    outputEnt.println("{ENTITIES}");
    
    //SAUVEGARDER LES OBJETS
    
    for( int i = 0; i < items.size(); i++ ) //sauvegarder chaque item placé sur la map
    {  
      String name = items.get(i).getName();
      while( name.indexOf(" ") != -1 )
      {
        name = name.substring( 0, name.indexOf(" ") ) + "_" + name.substring( name.indexOf(" ")+1, name.length() );
      }
      outputObj.println("["+name+"|"+items.get(i).getId()+"%"+items.get(i).getPos().x+"$"+items.get(i).getPos().y);
    }
    
    //SAUVEGARDER LES SPRITES DES OBJETS AU BON NOM
    
    for( int i = 0; i < items.size(); i++ ) //sauvegarder chaque item placé sur la map
    {  
      String name = items.get(i).getName();
      while( name.indexOf(" ") != -1 )
      {
        name = name.substring( 0, name.indexOf(" ") ) + "_" + name.substring( name.indexOf(" ")+1, name.length() );
      }
      
      items.get(i).getSprite().save(path+"/assets/objects/"+name+".png");
      
    }
  
  
    outputColl.flush(); // Writes the remaining data to the file
    outputEnt.flush(); // Writes the remaining data to the file
    outputObj.flush(); // Writes the remaining data to the file
    
    outputColl.close(); // Finishes the file
    outputEnt.close(); // Finishes the file
    outputObj.close(); // Finishes the file
    
    
    return true;
  }
}
