

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


//Collisions
/*
ArrayList<ArrayList<Float>> itemsCollision = new ArrayList<ArrayList<Float>>(); //charge les collisions de tous les items possibles ( range par ID ) tableau 2D pour chaque objet : [ ID, posX, posY, SizeX, sizeY, Pos2X, pos2Y, etc...]
ArrayList<item> collisionsToSave = new ArrayList<item>(); //tableau de sauvegarde des collisions pour l'exportation de la map
ArrayList<item> additonalCollisions = new ArrayList<item>(); //tableau des collisions ajoutées à la main depuis l'éditeur*/
boolean showCollisions = false;


//savegarde et chargeement des items
GViewListener view;
PGraphics global_PGraphics;
boolean itemsLoaded = false;
