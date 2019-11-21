

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

//tableau d'item
  
ArrayList<item> items = new ArrayList<item>();
//les items pris en main et ammenés sur l'ecran
item itemInHand;
boolean isCarringItem = false;

//const position y pour objects
final int initialYObjects = 0;
//const taille intiale objets
final int initialSizeObject = 100;
