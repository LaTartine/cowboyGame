import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import g4p_controls.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MapEditor extends PApplet {

// Need G4P library

// You can remove the PeasyCam import if you are not using
// the GViewPeasyCam control or the PeasyCam library.

//objects

MapReader readMap;
BrowserHandler browserWindow;

//Variables globales

PVector winSizeInit = new PVector( displayWidth, displayHeight ); //taille intitiale de la fenetre ( ne pas oublier de changer la taille de la fenetre quand changé ) -> size( x, y, osef );

float[] panels_in_main_old = new float [3];
GPanel[] panels_in_main_new = new GPanel [3];


public void setup(){
  
  
  
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
  
}


public void draw(){
  background(230);
  int sizex = PApplet.parseInt(width/1.5f);
  int sizey = PApplet.parseInt(height/1.5f);
  
  
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

public void updateInternalVar()
{
  label1.setText("Mouse position : "+viewMouseX+".x    ||     " + viewMouseY + ".y");
  wordpos.setText("Coordonées de la caméra : "+viewPos.x+".x    ||     " + viewPos.y + ".y");
  zoomView.setText("Zoom de la caméra : "+viewZoom);
}

public void mouseWheel(MouseEvent event) {
  
  float e = event.getCount();
  
  if (mouseWindow == "mainWindow") {
  PVector mouseinWorld = new PVector(
    (viewMouseX * viewZoom) - viewPos.x, 
    (viewMouseY * viewZoom) - viewPos.y);
    
  PVector oldMapSize = new PVector( mapSize.x, mapSize.y );
  
  if( e > 0 )
  {
    camZoom.setText(str(viewZoom*100));
    viewZoom *= 1.04f;
    viewSetPos( (viewMouseX * viewZoom) - mouseinWorld.x,  (viewMouseY * viewZoom) - mouseinWorld.y );
  }

  if( e < 0 )
  {
    camZoom.setText(str(viewZoom*100));
    viewZoom *= 1/1.04f;
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

public void loadParam()
{
  //creation d'un tableau de string qui prendra chaque ligne du fichier de texte
  String[] lines = loadStrings("saveOptions/mapMaker.param");
  
  println("Fichier de sauvegarde trouvé : " + lines.length + " lignes");
  
  for (int i = 0 ; i < lines.length; i++) {
    
    if( lines[i].contains("chunkSize") ) //charger la taille de chunk enregistrée
    {
      chunkSize.x = PApplet.parseFloat(lines[i].substring(lines[i].indexOf("[")+1, lines[i].indexOf("|"))); //remettre la variable à a valeure sauvegardée
      chunkX.setText(str(chunkSize.x)); //afficher le nombre dans l'interface
      chunkSize.y = PApplet.parseFloat(lines[i].substring(lines[i].indexOf("|")+1, lines[i].indexOf("]"))); //remettre la variable à a valeure sauvegardée
      chunkY.setText(str(chunkSize.y)); //afficher le nombre dans l'interface
    }
    
  }
}
public void saveParam() //sauvegarde des différentes variables
{
  output = createWriter("saveOptions/mapMaker.param"); //ouvrir le flux
  
  output.println( "chunkSize [" + chunkSize.x +"|"+chunkSize.y + "]"); // Write the coordinate to the file*
  
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  
  println("saved");
}

public void dispose() { //fonction appellée à la fermeture de la fenetre
  saveParam();
  println("shutting down...");
  super.stop();
} 


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
    createItems();

  }
  
 
  // Put any methods here in the class body
  
  public void update() {
    
    v = getGraphics();
    
    v.beginDraw();
    
    v.background(255,255,255,255); 
    if(isInitialisation == false) {
      doIPutAScroll(v);
    }
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
  
  private void doIPutAScroll(PGraphics view) {
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
  


} // end of class body


//const paths

String mapPath = "map/";

//map

PVector mapSize = new PVector(0, 0);
PVector chunkSize = new PVector(10, 10);

//Camera on map

PVector viewPos = new PVector(0, 0);
PVector lastViewPos = new PVector(0, 0);
PVector lastMousePos = new PVector(0, 0);
boolean deplacement = false;
float viewZoom = 1;

//view mouse

float viewMouseX = 0;
float viewMouseY = 0;

//cursor

PImage cursorMoveImg;
PImage cursorGrabImg;

//Lecture / écriture de fichier
  
PrintWriter output;

//tableau d'item qui sont dans la vue
  
ArrayList<item> items = new ArrayList<item>();
//les items pris en main et ammenés sur l'ecran
item itemInHand;
boolean isCarringItem = false; //test si un item ( réel ) est présent dans itemInHand pour ne pas faire crasher le programme
boolean isReallyCarringItem = false; //défini si l'utilisateur a un item en main, methode sans risque modifiable
boolean isInEditionMode = true;  //défini si l'utilisateur peut intérargir avec les items à l'écran

//const position y pour objects
final int initialYObjects = 0;
//const taille intiale objets
final int initialSizeObject = 100;
//const pos initial x objets
final int initialXObject = 70;

//tableau d'items qui sont dans la fenetre objets
ArrayList<item> itemsInMenu = new ArrayList<item>();

//booléen pour savoir si il doit afficher barre de scroll ou pas
boolean scrollInMenu = false;

//pour scroll dans browser
 float rectangleWidth;//taille rectangle scroll browser
 float widthOfItems;//taille totale items dans browser
 float totalWidth;//taille vue browser
 int rectangleHeight = 40;//taille rectangle
 boolean isInitialisation = false;
 
 //String qui dit dans quelle fenetre est la souris
 String mouseWindow="";
 
//scroller de la fenetre d'objets
Scroller scroller;

public void internVar_clicked1(GCheckbox source, GEvent event) { //_CODE_:internVar:581377:  -> Afficher ou non les variables internes sur l'écran
  println("checkbox2 - GCheckbox >> GEvent." + event + " @ " + millis());
  panel7.setCollapsible(true);
  if( event == GEvent.SELECTED )
  {
    panel7.setCollapsed(false);
  }
  else
  {
    panel7.setCollapsed(true);
  }
} //_CODE_:internVar:581377:

public void internvarop_clicked1(GCheckbox source, GEvent event) { //_CODE_:internvarop:634031:  -> Afficher le fond pour les variables internes sur l'écran
  println("internvarop - GCheckbox >> GEvent." + event + " @ " + millis());
  if( event == GEvent.SELECTED )
  {
    panel7.setOpaque(true);
  }
  else
  {
    panel7.setOpaque(false);
  }
} //_CODE_:internvarop:634031:

public void Resetint_click1(GButton source, GEvent event) { //_CODE_:Resetint:725524:
  println("Resetint - GButton >> GEvent." + event + " @ " + millis());
  
  collision_panel.moveTo( 0, 11 );
  camera_panel.moveTo( 0, 189 );
  objects_panel.moveTo(0, 454);
  
} //_CODE_:Resetint:725524:

public void button3_click1(GButton source, GEvent event) { //_CODE_:button3:618062: //reset la caméra position / zoom 
  println("button3 - GButton >> GEvent." + event + " @ " + millis());
  
  viewPos.x = 0; //deplacer la camera à l'emplacement initial
  viewPos.y = 0;
  CamX.setText(""); //effacer les chiffres dans les cases de l'interface ( position de la camera )
  CamY.setText("");
  
  viewZoom = 1; //reset le zoom
  
} //_CODE_:button3:618062:

public void CamX_change1(GTextField source, GEvent event) { //si l'utilisateur change la position de la camera via l'interface
  println("CamX - GTextField >> GEvent." + event + " @ " + millis());
  
  if( event == GEvent.ENTERED || event == GEvent.LOST_FOCUS ) //si la case de texte perd le focus ou si l'utilisateur appuie sur entrée
  {
    
    if( PApplet.parseFloat(CamX.getText()) > -999999999 && PApplet.parseFloat(CamX.getText()) < 999999999 ) //si l'utilisateur entre bien un chiffre
    {
      viewPos.x = PApplet.parseFloat(CamX.getText()); //deplacer la cam
      CamX.setPromptText("Position_Camera_X"); //remettre le bon message
    }
    else
    {
      CamX.setText("");
      CamX.setPromptText("Merci d'entrer un chiffre correcte ( ex : 1.255 )");
    }
  }
  
} //_CODE_:CamX:871508:

public void CamY_change1(GTextField source, GEvent event) { //_CODE_:CamY:546810:
  println("CamY - GTextField >> GEvent." + event + " @ " + millis());
  
  if( event == GEvent.LOST_FOCUS || event == GEvent.ENTERED )
  {

    if( PApplet.parseFloat(CamY.getText()) > -999999999 && PApplet.parseFloat(CamY.getText()) < 999999999 )
    {
      viewPos.y = PApplet.parseFloat(CamY.getText());
      CamY.setPromptText("Position_Camera_Y");
    }
    else
    {
      CamY.setText("");
      CamY.setPromptText("Merci d'entrer un chiffre correcte ( ex : 1.255 )");
    }
  }
  
} //_CODE_:CamY:546810:

public void camZoom_change1(GTextField source, GEvent event) { // Pareil pour le zoom de la caméra
  println("camZoom - GTextField >> GEvent." + event + " @ " + millis());
  
  if( event == GEvent.LOST_FOCUS || event == GEvent.ENTERED )
  {

    if( PApplet.parseFloat(camZoom.getText()) > -999999999 && PApplet.parseFloat(camZoom.getText()) < 999999999 )
    {
      viewZoom = PApplet.parseFloat(camZoom.getText())/100;
      camZoom.setPromptText("Zoom_Camera_(std:100%)");
    }
    else
    {
      camZoom.setText("");
      camZoom.setPromptText("Merci d'entrer un chiffre correcte ( ex : 50 )");
    }
  }
  
} //_CODE_:camZoom:798407:


public void centerCamX_click1(GButton source, GEvent event) { //_CODE_:button1:394020: //centrer la camera sur X
  println("button1 - GButton >> GEvent." + event + " @ " + millis());
  
  viewPos.x = -((view1.getWidth()-mapSize.x*viewZoom)/2);
  println(view1.getWidth());
  println(mapSize.x);
  
} //_CODE_:button1:394020:


public void centerCamY_click1(GButton source, GEvent event) { //_CODE_:button1:394020: //centrer la camera sur Y
  println("button1 - GButton >> GEvent." + event + " @ " + millis());
  
  viewPos.y = -((view1.getHeight()-mapSize.y*viewZoom)/2);
  
} //_CODE_:button1:394020:

public void resetInt_click1(GButton source, GEvent event) { //_CODE_:resetInt:223360:
  println("resetInt - GButton >> GEvent." + event + " @ " + millis());
  collision_panel.moveTo( 0, 11 );
  camera_panel.moveTo( 0, 189 ); 
  objects_panel.moveTo(0, 454);
} //_CODE_:resetInt:223360:



public void chunkX_change1(GTextField source, GEvent event) { //_CODE_:chunkX:775188: //chunk size X
  println("chunkX - GTextField >> GEvent." + event + " @ " + millis());
  
  if( event == GEvent.LOST_FOCUS || event == GEvent.ENTERED )
  {

    if( PApplet.parseFloat(chunkX.getText()) > -999999999 && PApplet.parseFloat(chunkX.getText()) < 999999999 )
    {
      chunkSize.x=(PApplet.parseFloat(chunkX.getText()));
      chunkX.setPromptText("Taille de chunk X");
    }
    else
    {
      chunkX.setText("");
      chunkX.setPromptText("Taille de chunk X");
    }
  }
} //_CODE_:chunkX:775188:

public void chunkY_change1(GTextField source, GEvent event) { //_CODE_:chunkY:854211: //chunk size Y
  println("chunkY - GTextField >> GEvent." + event + " @ " + millis());
  
  if( event == GEvent.LOST_FOCUS || event == GEvent.ENTERED )
  {

    if( PApplet.parseFloat(chunkY.getText()) > -999999999 && PApplet.parseFloat(chunkY.getText()) < 999999999 )
    {
      chunkSize.y=(PApplet.parseFloat(chunkY.getText()));
      chunkY.setPromptText("Taille de chunk Y");
    }
    else
    {
      chunkY.setText("");
      chunkY.setPromptText("Taille de chunk Y");
    }
  }
} //_CODE_:chunkY:854211:

public void lockObj_clicked1(GCheckbox source, GEvent event) { //_CODE_:lockObj:705550: //si L'option de lock est utilisée, alors bloquer le bon objet
  println("lockObj - GCheckbox >> GEvent." + event + " @ " + millis());
  
  for( int i = 0; i < items.size(); i++ )
  {
     if( items.get(i).isSelected() )
     {
       items.get(i).canBeDiplaced(event == GEvent.DESELECTED);
       println(event == GEvent.DESELECTED);
       println(items.get(i).canBeDiplaced()==true);
     }
  }
  
} //_CODE_:lockObj:705550:

public void posXObj_change1(GTextField source, GEvent event) { //_CODE_:posXObj:550631:
  println("posXObj - GTextField >> GEvent." + event + " @ " + millis());
  
  for( int i = 0; i < items.size(); i++ )
  {
     if( items.get(i).isSelected() )
     {
       if( PApplet.parseFloat(posXObj.getText()) > -999999999 && PApplet.parseFloat(posXObj.getText()) < 999999999 )
       {
        items.get(i).setMapPos( PApplet.parseFloat(posXObj.getText()) , items.get(i).getMapPos().y );
       }
     }
  }
  
} //_CODE_:posXObj:550631:

public void posYObj_change1(GTextField source, GEvent event) { //_CODE_:posYObj:336338:
  println("posYObj - GTextField >> GEvent." + event + " @ " + millis());
  
  for( int i = 0; i < items.size(); i++ )
  {
     if( items.get(i).isSelected() )
     {
       if( PApplet.parseFloat(posYObj.getText()) > -999999999 && PApplet.parseFloat(posYObj.getText()) < 999999999 )
       {
        items.get(i).setMapPos( items.get(i).getMapPos().x , PApplet.parseFloat(posYObj.getText()) );
       }
     }
  }
  
} //_CODE_:posYObj:336338:

public void deleteButton_click1(GButton source, GEvent event) { //_CODE_:delete:643449:               Supprimer un objet
  println("delete - GButton >> GEvent." + event + " @ " + millis());
  for( int i = 0; i < items.size(); i++ )
  {
     if( items.get(i).isSelected() )
     {
       if( PApplet.parseFloat(posYObj.getText()) > -999999999 && PApplet.parseFloat(posYObj.getText()) < 999999999 )
       {
        items.remove(i);
       }
     }
  }
} //_CODE_:delete:643449:

public void editionMode_clicked1(GCheckbox source, GEvent event) { //_CODE_:editionMode:448400:       Passer les objets en mode édition
  println("editionMode - GCheckbox >> GEvent." + event + " @ " + millis());
  
  isInEditionMode = (event == GEvent.SELECTED);
  
} //_CODE_:editionMode:448400:

public void creatObjectButton_clicked1(GButton source, GEvent event) { //_CODE_:creatObjectButton:780220:   Creer des objets
  println("creatObjectButton - GButton >> GEvent." + event + " @ " + millis());
  
  PrintWriter output=null;
  output = createWriter("Objects_creator.bat");
  output.println("cd "+sketchPath("tools/Objects_creator/"));
  output.println("start  C:/Users/fredj/Documents/Processing/Projects/MapEditor/tools/Objects_creator/objects_creator.exe");
  output.flush();
  output.close();  
  output=null;
  launch(sketchPath("")+"Objects_creator.bat");
} //_CODE_:creatObjectButton:780220:
//remplit le tableau de panels
public void GuiCollidingHandler()
{
  //if( collision_panel.isOver( mouseX, mouseY ) || collision_panel.isDragging() )
  //{
  //  testCollision(collision_panel,camera_panel);
  //}
  //else if( camera_panel.isOver( mouseX, mouseY ) || camera_panel.isDragging() )
  //{
  //  testCollision(camera_panel,collision_panel);
  //}
  
  panels_in_main_new [0] = camera_panel; 
  panels_in_main_new [1] = collision_panel;
  panels_in_main_new [2] = objects_panel; 
  //println("tableau new remplit");
  



    for(int i = 0; i<panels_in_main_new.length; i++){
        //println("comparaison");
        //println("old="+panels_in_main_new[i].getY()+" ; new="+panels_in_main_old[i]);
     if(panels_in_main_new[i].getY() != panels_in_main_old[i] || panels_in_main_new[i].isOver( mouseX, mouseY )){
         //println("changments détectés");
        panels_in_main_old[i]=panels_in_main_new[i].getY();
        for(int k = 0 ; k<panels_in_main_new.length ; k++){
          testCollision(panels_in_main_new[i], panels_in_main_new[k]);
        }
        
     }
  }

}

public void initializeArrayOfPanels(){
      panels_in_main_old [0] = camera_panel.getY(); 
      panels_in_main_old [1] = collision_panel.getY();
      panels_in_main_old [2] = objects_panel.getY();
      //println("old est plein");
}

//s'ocuppe des collisions entre 2 pannels
public void testCollision( GPanel panelInHand, GPanel panelToPush )
{
  if( panelToPush.isCollapsed() && !panelInHand.isCollapsed() )
  {
    if( panelToPush.getY() < panelInHand.getY() && panelToPush.getY() > main_layout_panel.getY()-main_layout_panel.getTabHeight() )
    {
      if( panelInHand.getY() > panelToPush.getY() && panelInHand.getY() < panelToPush.getY()+panelToPush.getTabHeight() )
      {
        panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()-panelToPush.getTabHeight());
      }
     }
    else if( panelToPush.getY() > panelInHand.getY() && panelToPush.getY()+panelToPush.getHeight() < main_layout_panel.getY()+main_layout_panel.getHeight()-main_layout_panel.getTabHeight()  )
    {
       if( panelInHand.getY()+panelInHand.getHeight() > panelToPush.getY() && panelInHand.getY()+panelInHand.getTabHeight() < panelToPush.getY()+panelToPush.getTabHeight() )
       {
         panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()+panelInHand.getHeight());
       }
    }
  }
  else if( !panelToPush.isCollapsed() && !panelInHand.isCollapsed() )
  {
    if( panelToPush.getY() < panelInHand.getY() && panelToPush.getY() > main_layout_panel.getY()-main_layout_panel.getTabHeight() ) //si le panneau à pousser est au dessus et si il ne dépasse pas de son parent
    {
      if( panelInHand.getY() > panelToPush.getY() && panelInHand.getY() < panelToPush.getY()+panelToPush.getHeight() ) //si le panneau qui pousse entre en constact avec le panneau à pousser
      {
        panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()-panelToPush.getHeight()); //deplacer le panneau à pousser
      }
     }
    else if( panelToPush.getY() > panelInHand.getY() && panelToPush.getY()+panelToPush.getHeight() < main_layout_panel.getY()+main_layout_panel.getHeight()-main_layout_panel.getTabHeight()  )
    {
       if( panelInHand.getY()+panelInHand.getHeight() > panelToPush.getY() && panelInHand.getY()+panelInHand.getHeight() < panelToPush.getY()+panelToPush.getHeight() )
       {
         panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()+panelInHand.getHeight());
       }
    }
  }
  
  else if( panelToPush.isCollapsed() && panelInHand.isCollapsed() )
  {
    
  }
  else if( !panelToPush.isCollapsed() && panelInHand.isCollapsed() )
  {
    if( panelToPush.getY() < panelInHand.getY() && panelToPush.getY() > main_layout_panel.getY()-main_layout_panel.getTabHeight() )
    {
      if( panelInHand.getY() > panelToPush.getY() && panelInHand.getY() < panelToPush.getY()+panelToPush.getHeight() )
      {
        panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()-panelToPush.getHeight());
      }
     }
    else if( panelToPush.getY() > panelInHand.getY() && panelToPush.getY()+panelToPush.getHeight() < main_layout_panel.getY()+main_layout_panel.getHeight()-main_layout_panel.getTabHeight()  )
    {
       if( panelInHand.getY()+panelInHand.getTabHeight() > panelToPush.getY() && panelInHand.getY()+panelInHand.getTabHeight() < panelToPush.getY()+panelToPush.getHeight() )
       {
         panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()+panelInHand.getTabHeight());
       }
    }
  }
}


public class Scroller {
  PVector pos = new PVector(0,0);
  float sWidth = 0;
  float sHeight = 0;
  boolean isSelected=false;
  float pos_View; //position des élements
  
  
  Scroller (float posX, float posY, float sWidth, float sHeight, float posView) {
    this.pos.x = posX;
    this.pos.y = posY;
    this.sWidth = sWidth;
    this.sHeight = sHeight;
    this.isSelected=false;
    this.pos_View = posView;
  }
  
  //GETTERS
  public PVector getPos(){
    return this.pos;
  }
  
  public float getPosView(){
    return this.pos_View;
  }
  
  public float getPosX(){
    return this.pos.x;
  }
  
  public float getPosY(){
    return this.pos.y;
  }
  
  public float getWidth(){
    return this.sWidth;
  }
  
  public float getHeight(){
    return this.sHeight;
  }
  
   public boolean getSelected(){
    return this.isSelected;
  }
  
  //SETTERS
  
  public void setPosX( float x )
  {
    this.pos.x = x;
  }
  
    public void setPosView( float x )
  {
    this.pos_View = x;
  }
  
  public void setWidth( float width )
  {
    this.sWidth = width;
  }
  
  public void setHeight( float height )
  {
    this.sHeight = height ;
  }
  
  public void setSelected (boolean is )
  {
    this.isSelected = is ;
  }
  
  
  //methode pour afficher scroller
  public void drawScroller(PGraphics view){
    noStroke();
    if (this.isSelected == true) {
      fill(200, 200, 200, 255);
    } else {
      fill(0, 0, 0, 255);
    }
    
    view.rect(this.pos.x, this.pos.y, this.sWidth, this.sHeight);
  }
  
  
  
 
}



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Game engine");
  view1 = new GView(this, 266, 0, 1333, 673, JAVA2D);
  main_panel = new GPanel(this, 0, 0, 266, 673, "Main______________________________________");
  main_panel.setDraggable(false);
  main_panel.setText("Main______________________________________");
  main_panel.setOpaque(true);
  main_panel.addEventHandler(this, "panel1_Click1");
  main_layout_panel = new GPanel(this, 0, 19, 266, 654, "");
  main_layout_panel.setDraggable(false);
  main_layout_panel.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  main_layout_panel.setOpaque(false);
  main_layout_panel.addEventHandler(this, "panel2_Click1");
  collision_panel = new GPanel(this, 0, 11, 266, 169, "Collisions");
  collision_panel.setText("Collisions");
  collision_panel.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  collision_panel.setOpaque(true);
  collision_panel.addEventHandler(this, "panel5_Click1");
  showCollisionCheckbox = new GCheckbox(this, 3, 25, 260, 15);
  showCollisionCheckbox.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  showCollisionCheckbox.setText("Montrer les collisions");
  showCollisionCheckbox.setOpaque(false);
  showCollisionCheckbox.addEventHandler(this, "showCollisionCheckbox_clicked1");
  collision_panel.addControl(showCollisionCheckbox);
  camera_panel = new GPanel(this, 0, 189, 266, 200, "Camera");
  camera_panel.setText("Camera");
  camera_panel.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  camera_panel.setOpaque(true);
  camera_panel.addEventHandler(this, "panel6_Click1");
  button3 = new GButton(this, 3, 25, 260, 15);
  button3.setText("Reset la camera");
  button3.addEventHandler(this, "button3_click1");
  CamX = new GTextField(this, 3, 85, 260, 20, G4P.SCROLLBARS_NONE);
  CamX.setPromptText("Position_camera_X");
  CamX.setOpaque(true);
  CamX.addEventHandler(this, "CamX_change1");
  CamY = new GTextField(this, 3, 110, 260, 20, G4P.SCROLLBARS_NONE);
  CamY.setPromptText("Position_camera_Y");
  CamY.setOpaque(true);
  CamY.addEventHandler(this, "CamY_change1");
  camZoom = new GTextField(this, 3, 170, 260, 20, G4P.SCROLLBARS_NONE);
  camZoom.setPromptText("Zoom_Camera_(std:1)");
  camZoom.setOpaque(true);
  camZoom.addEventHandler(this, "camZoom_change1");
  button1 = new GButton(this, 3, 45, 260, 15);
  button1.setText("Centrer sur X");
  button1.addEventHandler(this, "centerCamX_click1");
  centerCamY = new GButton(this, 3, 65, 260, 15);
  centerCamY.setText("Centrer sur Y");
  centerCamY.addEventHandler(this, "centerCamY_click1");
  label5 = new GLabel(this, 0, 145, 266, 20);
  label5.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label5.setText("Zoom de la caméra");
  label5.setOpaque(true);
  camera_panel.addControl(button3);
  camera_panel.addControl(CamX);
  camera_panel.addControl(CamY);
  camera_panel.addControl(camZoom);
  camera_panel.addControl(button1);
  camera_panel.addControl(centerCamY);
  camera_panel.addControl(label5);
  objects_panel = new GPanel(this, 0, 395, 266, 180, "Objets");
  objects_panel.setText("Objets");
  objects_panel.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  objects_panel.setOpaque(true);
  objects_panel.addEventHandler(this, "panel1_Click2");
  posXObj = new GTextField(this, 3, 25, 260, 20, G4P.SCROLLBARS_NONE);
  posXObj.setPromptText("Position X");
  posXObj.setOpaque(true);
  posXObj.addEventHandler(this, "posXObj_change1");
  posYObj = new GTextField(this, 3, 50, 260, 20, G4P.SCROLLBARS_NONE);
  posYObj.setPromptText("Position Y");
  posYObj.setOpaque(true);
  posYObj.addEventHandler(this, "posYObj_change1");
  lockObj = new GCheckbox(this, 3, 75, 260, 20);
  lockObj.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  lockObj.setText("Bloquer l'objet");
  lockObj.setOpaque(false);
  lockObj.addEventHandler(this, "lockObj_clicked1");
  delete = new GButton(this, 3, 100, 260, 20);
  delete.setText("Supprimer l'objet");
  delete.addEventHandler(this, "deleteButton_click1");
  editionMode = new GCheckbox(this, 3, 125, 260, 20);
  editionMode.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  editionMode.setText("Mode édition depuis l'écran");
  editionMode.setOpaque(false);
  editionMode.addEventHandler(this, "editionMode_clicked1");
  editionMode.setSelected(true);
  creatObjectButton = new GButton(this, 3, 150, 260, 20);
  creatObjectButton.setText("Créer un objet");
  creatObjectButton.addEventHandler(this, "creatObjectButton_clicked1");
  objects_panel.addControl(posXObj);
  objects_panel.addControl(posYObj);
  objects_panel.addControl(lockObj);
  objects_panel.addControl(delete);
  objects_panel.addControl(editionMode);
  objects_panel.addControl(creatObjectButton);
  resetInt = new GButton(this, 206, 635, 60, 15);
  resetInt.setText("Reset");
  resetInt.addEventHandler(this, "resetInt_click1");
  main_layout_panel.addControl(collision_panel);
  main_layout_panel.addControl(camera_panel);
  main_layout_panel.addControl(objects_panel);
  main_layout_panel.addControl(resetInt);
  main_panel.addControl(main_layout_panel);
  down_panel = new GPanel(this, 0, 673, 1598, 227, "Selecteur de fichier");
  down_panel.setCollapsible(false);
  down_panel.setDraggable(false);
  down_panel.setText("Selecteur de fichier");
  down_panel.setOpaque(true);
  down_panel.addEventHandler(this, "panel4_Click1");
  browser = new GView(this, 0, 19, 1598, 208, JAVA2D);
  down_panel.addControl(browser);
  panel7 = new GPanel(this, 267, -23, 313, 242, "Variables internes");
  panel7.setDraggable(false);
  panel7.setText("Variables internes");
  panel7.setOpaque(false);
  panel7.addEventHandler(this, "panel7_Click1");
  label1 = new GLabel(this, 5, 25, 300, 20);
  label1.setText("Mouse position :");
  label1.setOpaque(false);
  wordpos = new GLabel(this, 5, 45, 300, 40);
  wordpos.setTextAlign(GAlign.TOP, GAlign.TOP);
  wordpos.setText("Position du monde :");
  wordpos.setOpaque(false);
  zoomView = new GLabel(this, 5, 85, 300, 20);
  zoomView.setText("Zoom vue :");
  zoomView.setOpaque(false);
  panel7.addControl(label1);
  panel7.addControl(wordpos);
  panel7.addControl(zoomView);
  settings_panel = new GPanel(this, 0, 19, 266, 653, "Parametres________________________________");
  settings_panel.setCollapsed(true);
  settings_panel.setDraggable(false);
  settings_panel.setText("Parametres________________________________");
  settings_panel.setLocalColorScheme(GCScheme.RED_SCHEME);
  settings_panel.setOpaque(true);
  settings_panel.addEventHandler(this, "panel8_Click1");
  internVar = new GCheckbox(this, 0, 50, 266, 20);
  internVar.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  internVar.setText("Afficher les variables internes");
  internVar.setOpaque(false);
  internVar.addEventHandler(this, "internVar_clicked1");
  internVar.setSelected(true);
  internvarop = new GCheckbox(this, 0, 70, 266, 20);
  internvarop.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  internvarop.setText("Fond des variables internes");
  internvarop.setOpaque(false);
  internvarop.addEventHandler(this, "internvarop_clicked1");
  label2 = new GLabel(this, 0, 30, 266, 20);
  label2.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label2.setText("Afficheur de variable");
  label2.setLocalColorScheme(GCScheme.RED_SCHEME);
  label2.setOpaque(true);
  label3 = new GLabel(this, 0, 110, 266, 20);
  label3.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label3.setText("Fenetres");
  label3.setLocalColorScheme(GCScheme.RED_SCHEME);
  label3.setOpaque(true);
  Resetint = new GButton(this, 8, 140, 250, 20);
  Resetint.setText("Reset l'interface");
  Resetint.setLocalColorScheme(GCScheme.RED_SCHEME);
  Resetint.addEventHandler(this, "Resetint_click1");
  label4 = new GLabel(this, 0, 180, 266, 20);
  label4.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label4.setText("Taille de chunk");
  label4.setLocalColorScheme(GCScheme.RED_SCHEME);
  label4.setOpaque(true);
  chunkX = new GTextField(this, 3, 210, 260, 20, G4P.SCROLLBARS_NONE);
  chunkX.setPromptText("Taille de chunk X");
  chunkX.setLocalColorScheme(GCScheme.RED_SCHEME);
  chunkX.setOpaque(true);
  chunkX.addEventHandler(this, "chunkX_change1");
  chunkY = new GTextField(this, 3, 240, 260, 20, G4P.SCROLLBARS_NONE);
  chunkY.setPromptText("Taille de chunk Y");
  chunkY.setLocalColorScheme(GCScheme.RED_SCHEME);
  chunkY.setOpaque(true);
  chunkY.addEventHandler(this, "chunkY_change1");
  settings_panel.addControl(internVar);
  settings_panel.addControl(internvarop);
  settings_panel.addControl(label2);
  settings_panel.addControl(label3);
  settings_panel.addControl(Resetint);
  settings_panel.addControl(label4);
  settings_panel.addControl(chunkX);
  settings_panel.addControl(chunkY);
}

// Variable declarations 
// autogenerated do not edit
GView view1; 
GPanel main_panel; 
GPanel main_layout_panel; 
GPanel collision_panel; 
GCheckbox showCollisionCheckbox; 
GPanel camera_panel; 
GButton button3; 
GTextField CamX; 
GTextField CamY; 
GTextField camZoom; 
GButton button1; 
GButton centerCamY; 
GLabel label5; 
GPanel objects_panel; 
GTextField posXObj; 
GTextField posYObj; 
GCheckbox lockObj; 
GButton delete; 
GCheckbox editionMode; 
GButton creatObjectButton; 
GButton resetInt; 
GPanel down_panel; 
GView browser; 
GPanel panel7; 
GLabel label1; 
GLabel wordpos; 
GLabel zoomView; 
GPanel settings_panel; 
GCheckbox internVar; 
GCheckbox internvarop; 
GLabel label2; 
GLabel label3; 
GButton Resetint; 
GLabel label4; 
GTextField chunkX; 
GTextField chunkY; 

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
  
  boolean m_canBeDiplaced; //l'objet pe ut-il etre déplacé
  boolean m_dragging = false; //pour que l'on puisse deplacer l'objet jusqu'à ce qu'on relache la souris
  boolean m_isSelected = false; //si l'on clique sur l'item, il est selectionné
  
  //constructeurs et surcharges de constructeur////////////////////////////////////////////////////////////////////////////////CONSTRUCTEURS CONSTRUCTEURS CONSTRUCTEURS////////////////////////////////////////////////
  
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
  
  //methodes privées//////////////////////////////////////////////////////////////////////////////////////METHODES METHODES METHODES/////////////////////////////////////////////////////////////////////////////////////
  
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
          m_animated = PApplet.parseBoolean(simpleRead); //remettre la variable à a valeure sauvegardée
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
          m_nbSprite = PApplet.parseInt(simpleRead); //remettre la variable à a valeure sauvegardée
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
  
  public void mouseDraggedInView( PGraphics v ) {
    if( m_canBeDiplaced )
    {
      dragItem(v);
    }
  }
  
  public void draw(PGraphics v) //surcharge de la fonction précédente
  {
 
    PVector resizedSize = new PVector( m_size, (PApplet.parseFloat(sprite.height)/PApplet.parseFloat(sprite.width))*m_size); //recalculation de la taille
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
    PVector resizedSize = new PVector( m_size, (PApplet.parseFloat(sprite.height)/PApplet.parseFloat(sprite.width))*m_size); //recalculation de la taille
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
    NewCopy.sprite = loadImage(m_SpritePath);
    NewCopy.m_pos = new PVector(0, 0);
    NewCopy.m_pos.x = m_pos.x;
    NewCopy.m_pos.y = m_pos.y;
    NewCopy.m_v = m_v;
    NewCopy.m_view = m_view;
    
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
  
  
  //methodes getters ///////////////////////////////////////////////////////////////////////////////////////GET GET GET  ///////////////////////////////////////////////////////////////////////////////////////////////
  
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
  
  
}

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
    
    viewMouseX = mouseX();
    viewMouseY = mouseY();
 
    v.beginDraw();
    
    v.background(255,255,255,255); 
    
    generateBackground(v);
    createChunkGrid( v );
    CreateBackgroundGrid( v );
    isCarringAnItem( v );
    drawObjects(v);
    
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
    for( int i = 0; i < items.size(); i++ )
    {
      items.get(i).mouseDraggedInView(getGraphics());
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
      items.get(i).setScale(viewZoom); //tres important
      items.get(i).setPos(items.get(i).getMapPos().x*viewZoom-viewPos.x, items.get(i).getMapPos().y*viewZoom-viewPos.y);
    }
    
  }
 
} // end of class body
  public void settings() {  size( 1600, 900, JAVA2D );  smooth(0); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "MapEditor" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
