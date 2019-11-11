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

//Variables globales

PVector winSizeInit = new PVector( displayWidth, displayHeight ); //taille intitiale de la fenetre ( ne pas oublier de changer la taille de la fenetre quand changé ) -> size( x, y, osef );


public void setup(){
  
  
  
  createGUI();
  customGUI();
  
  surface.setResizable(true); //pour changer la taille
  //surface.resize(displayWidth,displayHeight); //ça marche pas :/
  
  
  // Place your setup code here
  PImage icon = loadImage("assets/img/icon/logo.png");
  surface.setIcon(icon);
  
  //charger les curseurs
  cursorMoveImg = loadImage("assets/img/cursor/move.png");
  cursorGrabImg = loadImage("assets/img/cursor/grab.png");
  
  //launch("tools"+File.separator+"Objects_creator"+File.separator+"objects_creator.exe");
  //exec(new String[]{"start","tools"+File.separator+"Objects_creator"+File.separator+"objects_creator.exe"});
  
  /*PrintWriter output=null;
  output = createWriter("Objects_creator.bat");
  output.println("cd "+sketchPath(""));
  output.println("start  C:/Users/fredj/Documents/Processing/Projects/MapEditor/tools/Objects_creator/objects_creator.exe");
  output.flush();
  output.close();  
  output=null;
  launch(sketchPath("")+"Objects_creator.bat");*/
  
  // Setup 2D view and viewer
  readMap = new MapReader();
  
  view1.addListener(readMap); //pour gérer les évenements de la fenetre
  view1.setVisible(true); //la rendre visible, évidement
  
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

public void getInteractionEvent()
{
  if( mousePressed ){
  if ( keyPressed && key  == ' ') {
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


//const paths

String mapPath = "map/";

//map

PVector mapSize = new PVector(0, 0);

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
  
  panel5.moveTo( 0, 11 );
  panel6.moveTo( 0, 189 ); 
  
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


public void centerCamX_click1(GButton source, GEvent event) { //_CODE_:button1:394020:
  println("button1 - GButton >> GEvent." + event + " @ " + millis());
  
  viewPos.x = (view1.getWidth()-mapSize.x/2);
  
} //_CODE_:button1:394020:


public void centerCamY_click1(GButton source, GEvent event) { //_CODE_:button1:394020:
  println("button1 - GButton >> GEvent." + event + " @ " + millis());
  
  viewPos.y = (view1.getHeight()-mapSize.y/2);
  
} //_CODE_:button1:394020:

public void GuiCollidingHandler()
{
  if( panel5.isOver( mouseX, mouseY ) || panel5.isDragging() )
  {
    testCollision(panel5,panel6);
  }
  else if( panel6.isOver( mouseX, mouseY ) || panel6.isDragging() )
  {
    testCollision(panel6,panel5);
  }
}

public void testCollision( GPanel panelInHand, GPanel panelToPush )
{
  if( panelToPush.isCollapsed() && !panelInHand.isCollapsed() )
  {
    if( panelToPush.getY() < panelInHand.getY() && panelToPush.getY() > panel2.getY()-panel2.getTabHeight() )
    {
      if( panelInHand.getY() > panelToPush.getY() && panelInHand.getY() < panelToPush.getY()+panelToPush.getTabHeight() )
      {
        panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()-panelToPush.getTabHeight());
      }
     }
    else if( panelToPush.getY() > panelInHand.getY() && panelToPush.getY()+panelToPush.getHeight() < panel2.getY()+panel2.getHeight()-panel2.getTabHeight()  )
    {
       if( panelInHand.getY()+panelInHand.getHeight() > panelToPush.getY() && panelInHand.getY()+panelInHand.getTabHeight() < panelToPush.getY()+panelToPush.getTabHeight() )
       {
         panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()+panelInHand.getHeight());
       }
    }
  }
  else if( !panelToPush.isCollapsed() && !panelInHand.isCollapsed() )
  {
    if( panelToPush.getY() < panelInHand.getY() && panelToPush.getY() > panel2.getY()-panel2.getTabHeight() ) //si le panneau à pousser est au dessus et si il ne dépasse pas de son parent
    {
      if( panelInHand.getY() > panelToPush.getY() && panelInHand.getY() < panelToPush.getY()+panelToPush.getHeight() ) //si le panneau qui pousse entre en constact avec le panneau à pousser
      {
        panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()-panelToPush.getHeight()); //deplacer le panneau à pousser
      }
     }
    else if( panelToPush.getY() > panelInHand.getY() && panelToPush.getY()+panelToPush.getHeight() < panel2.getY()+panel2.getHeight()-panel2.getTabHeight()  )
    {
       if( panelInHand.getY()+panelInHand.getHeight() > panelToPush.getY() && panelInHand.getY()+panelInHand.getHeight() < panelToPush.getY()+panelToPush.getHeight() )
       {
         panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()+panelInHand.getHeight());
       }
    }
  }
  
  else if( panelToPush.isCollapsed() && panelInHand.isCollapsed() )
  {
    /*println(panel5.getWidth());
    if( panel6.getY() < panel5.getY() )
    {
      if( panel5.getY() > panel6.getY() && panel5.getY() < panel6.getY()+panel6.getTabHeight() &&
          panel5.getX()+panel5.getWidth() > panel6.getX() && panel5.getX() < panel6.getX()+panel6.getWidth() )
      {
        panel6.moveTo( panel6.getX(), panel5.getY()-panel6.getTabHeight());
      }
     }
    else if( panel6.getY() > panel5.getY())
    {
       if( panel5.getY()+panel5.getTabHeight() > panel6.getY() && panel5.getY()+panel5.getTabHeight() < panel6.getY()+panel6.getTabHeight() &&
           panel5.getX()+panel5.getWidth() > panel6.getX() && panel5.getX() < panel6.getX()+panel6.getWidth()  )
       {
         panel6.moveTo( panel6.getX(), panel5.getY()+panel5.getTabHeight());
       }
    }*/
  }
  else if( !panelToPush.isCollapsed() && panelInHand.isCollapsed() )
  {
    if( panelToPush.getY() < panelInHand.getY() && panelToPush.getY() > panel2.getY()-panel2.getTabHeight() )
    {
      if( panelInHand.getY() > panelToPush.getY() && panelInHand.getY() < panelToPush.getY()+panelToPush.getHeight() )
      {
        panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()-panelToPush.getHeight());
      }
     }
    else if( panelToPush.getY() > panelInHand.getY() && panelToPush.getY()+panelToPush.getHeight() < panel2.getY()+panel2.getHeight()-panel2.getTabHeight()  )
    {
       if( panelInHand.getY()+panelInHand.getTabHeight() > panelToPush.getY() && panelInHand.getY()+panelInHand.getTabHeight() < panelToPush.getY()+panelToPush.getHeight() )
       {
         panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()+panelInHand.getTabHeight());
       }
    }
  }
  
  /*if( panelToPush.getY()-panelToPush.getTabHeight() < panel2.getY()-panel2.getTabHeight() || panelToPush.getY()+panelToPush.getHeight()+panelToPush.getTabHeight() > panel2.getY()+panel2.getHeight()-panel2.getTabHeight() ) //si la fenetre sort du parent et qu'elle est donc bloquée, la fenetre avec laquelle on pousse est aussi bloquée
  {
    panelInHand.setDraggable(false);
  }
  else
  {
    panelInHand.setDraggable(true);
  }*/
}
/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Game engine");
  view1 = new GView(this, 266, 0, 1333, 673, JAVA2D);
  panel1 = new GPanel(this, 0, 0, 266, 673, "Main______________________________________");
  panel1.setCollapsed(true);
  panel1.setDraggable(false);
  panel1.setText("Main______________________________________");
  panel1.setOpaque(true);
  panel1.addEventHandler(this, "panel1_Click1");
  panel2 = new GPanel(this, 0, 19, 266, 654, "");
  panel2.setCollapsible(false);
  panel2.setDraggable(false);
  panel2.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  panel2.setOpaque(false);
  panel2.addEventHandler(this, "panel2_Click1");
  panel5 = new GPanel(this, 0, 11, 266, 169, "Collisions");
  panel5.setText("Collisions");
  panel5.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  panel5.setOpaque(true);
  panel5.addEventHandler(this, "panel5_Click1");
  panel6 = new GPanel(this, 0, 189, 266, 200, "Camera");
  panel6.setText("Camera");
  panel6.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  panel6.setOpaque(true);
  panel6.addEventHandler(this, "panel6_Click1");
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
  panel6.addControl(button3);
  panel6.addControl(CamX);
  panel6.addControl(CamY);
  panel6.addControl(camZoom);
  panel6.addControl(button1);
  panel6.addControl(centerCamY);
  panel6.addControl(label5);
  panel2.addControl(panel5);
  panel2.addControl(panel6);
  panel1.addControl(panel2);
  panel4 = new GPanel(this, 0, 673, 1598, 229, "Tab bar text");
  panel4.setCollapsible(false);
  panel4.setDraggable(false);
  panel4.setText("Tab bar text");
  panel4.setOpaque(true);
  panel4.addEventHandler(this, "panel4_Click1");
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
  panel8 = new GPanel(this, 0, 19, 266, 653, "Parametres________________________________");
  panel8.setCollapsed(true);
  panel8.setDraggable(false);
  panel8.setText("Parametres________________________________");
  panel8.setLocalColorScheme(GCScheme.RED_SCHEME);
  panel8.setOpaque(true);
  panel8.addEventHandler(this, "panel8_Click1");
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
  label4.setText("Vue");
  label4.setLocalColorScheme(GCScheme.RED_SCHEME);
  label4.setOpaque(true);
  panel8.addControl(internVar);
  panel8.addControl(internvarop);
  panel8.addControl(label2);
  panel8.addControl(label3);
  panel8.addControl(Resetint);
  panel8.addControl(label4);
}

// Variable declarations 
// autogenerated do not edit
GView view1; 
GPanel panel1; 
GPanel panel2; 
GPanel panel5; 
GPanel panel6; 
GButton button3; 
GTextField CamX; 
GTextField CamY; 
GTextField camZoom; 
GButton button1; 
GButton centerCamY; 
GLabel label5; 
GPanel panel4; 
GPanel panel7; 
GLabel label1; 
GLabel wordpos; 
GLabel zoomView; 
GPanel panel8; 
GCheckbox internVar; 
GCheckbox internvarop; 
GLabel label2; 
GLabel label3; 
GButton Resetint; 
GLabel label4; 

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

 
  // Put any methods here in the class body
  
  public void update() {
    
    PGraphics v = getGraphics();
    
    viewMouseX = mouseX();
    viewMouseY = mouseY();
 
    v.beginDraw();
    
    v.background(255,255,255,255); 
    
    generateBackground(v);
    
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
    PImage background = loadImage( mapPath + "backgrounds/1.png");
    mapSize.x = background.width;
    mapSize.y = background.height;
    v.image( background, -viewPos.x+(v.width-background.width)/2, -viewPos.y+(v.height-background.height)/2, background.width*viewZoom, background.height*viewZoom );
    
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
