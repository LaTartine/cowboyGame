synchronized public void openingWindow_draw(PApplet appc, GWinData data) { //_CODE_:openingWindows:473159:
  appc.background(230);
  fillOldProjectList("/map/",  oldProjectList);
  
} //_CODE_:openingWindows:473159:

public void openProjetButton_click(GButton source, GEvent event) { //_CODE_:openProjetButton:810701:
  println("openProjetButton - GButton >> GEvent." + event + " @ " + millis());
  openProject("openingWindowsOpenFileCallback");
  
  
} //_CODE_:openProjetButton:810701:

public void oldProjectList_click(GDropList source, GEvent event) { //_CODE_:oldProjectList:468108:
  println("oldProjectList - GDropList >> GEvent." + event + " @ " + millis());
  int choix = source.getSelectedIndex();
  if(choix!=0) {
    
    openingWindows.close();
    loadProject(newestProject.get(choix-1));//-1 car projets récents est en 0
    
  }
} //_CODE_:oldProjectList:468108:


//bouton nouveau projet
public void button2_click1(GButton source, GEvent event) { //_CODE_:buttonnewProject:290195:
  println("button2 - GButton >> GEvent." + event + " @ " + millis());
  
  openingWindows.close();
} //_CODE_:buttonnewProject:290195:


//methode qui remplit la liste anciens projets 
  public void fillOldProjectList (String chemin, GDropList oldProjectList ){
    ArrayList<String> tableauOldProject = new ArrayList <String>();
    File file = new File(sketchPath()+chemin);
        if(file.listFiles()!=null){
          File[] files = file.listFiles();
          for(int i = 0; i< files.length ; i++ ) {
              String extension = getFileExtension(files[i]);
              if((files[i].isDirectory() == false) && extension.equals(".save")) {
                String fileName = files[i].getName();
              
                fileName = fileName.replace(".save", "");
                tableauOldProject.add(fileName);
                newestProject.add(files[i]);
          
              }
            }
          }
      //ajoute valeur par défault
      tableauOldProject.add(0, "Projets récents");
     
      //convertit l'arraylist en tableau
      int taille = tableauOldProject.size();
      String [] tableauOldProject2 = new String[taille];
      for(int i = 0; i < taille ; i++ ) {
          tableauOldProject2[i] = tableauOldProject.get(i);
      }
      
      //le met dans la liste
      oldProjectList.setItems(tableauOldProject2, 0);
     
            
  }
  
  //récupérer extension fichier
  public String getFileExtension(File file) {
    String name = file.getName();
    int lastIndexOf = name.lastIndexOf(".");
    if (lastIndexOf == -1) {
        return ""; // empty extension
    }
    return name.substring(lastIndexOf);
}

public void openingWindowsOpenFileCallback(File file) {
  openingWindows.close();
  loadProject(file);
}

public void openProject(String callbackMethod) {
    File defaultPath = new File(sketchPath()+"/map/");
    selectInput("Sélectionnez le projet que vous souhaitez ouvrir", callbackMethod ,defaultPath);
}
