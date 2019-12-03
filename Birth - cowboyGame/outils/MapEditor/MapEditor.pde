// Need G4P library
import g4p_controls.*;
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
  browserWindow = new BrowserHandler();
  
  view1.addListener(readMap); //pour gérer les évenements de la fenetre
  view1.setVisible(true); //la rendre visible, évidement
  browser.addListener(browserWindow);
  browser.setVisible(true);
  
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
