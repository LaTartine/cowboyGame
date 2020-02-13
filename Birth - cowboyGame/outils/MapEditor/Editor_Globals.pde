

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
ArrayList<backgroundItem> backgroundItems = new ArrayList<backgroundItem>();


//les items pris en main et ammenés sur l'ecran
item itemInHand;
backgroundItem backgroundItemInHand;
boolean isCarringItem = false; //test si un item ( réel ) est présent dans itemInHand pour ne pas faire crasher le programme
boolean isCarringBackgroundItem = false; //test si un BackgroundItem ( réel ) est présent dans itemInHand pour ne pas faire crasher le programme
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

//tableau des maps qui sont dans le menu
ArrayList<backgroundItem> mapsInMenu = new ArrayList<backgroundItem>();

//savoir quel type de fichier afficher dans le browser
int typeOfFile = 0;

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


//Collisions
/*
ArrayList<ArrayList<Float>> itemsCollision = new ArrayList<ArrayList<Float>>(); //charge les collisions de tous les items possibles ( range par ID ) tableau 2D pour chaque objet : [ ID, posX, posY, SizeX, sizeY, Pos2X, pos2Y, etc...]
ArrayList<Float> collisionsToSave = new ArrayList<Float>(); //tableau de sauvegarde des collisions pour l'exportation de la map*/
ArrayList<Float> additonalCollisions = new ArrayList<Float>(); //tableau des collisions ajoutées à la main depuis l'éditeur
boolean showCollisions = false;
boolean g_addColl = false;
boolean g_deletColl = false;
boolean onCreate = false;
float onCreateStartPosX = 0;
float onCreateStartPosY = 0;


//savegarde et chargement des items
GViewListener view;
PGraphics global_PGraphics;
boolean itemsLoaded = false;

//tableau de file pour stocker chemin vers projets récents
ArrayList <File> newestProject = new ArrayList<File>();

//file qui stocke chemin projet en cours
File openedProject = new File(sketchPath()+"/map/editor.save");
