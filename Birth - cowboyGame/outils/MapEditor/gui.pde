
// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Game engine");
  view1 = new GView(this, 266, 0, 1333, 673, JAVA2D);
  main_panel = new GPanel(this, 0, 0, 266, 673, "Main______________________________________");
  main_panel.setCollapsed(true);
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
  collision_panel.setCollapsed(true);
  collision_panel.setText("Collisions");
  collision_panel.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  collision_panel.setOpaque(true);
  collision_panel.addEventHandler(this, "panel5_Click1");
  showCollisionCheckbox = new GCheckbox(this, 3, 25, 260, 15);
  showCollisionCheckbox.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  showCollisionCheckbox.setText("Montrer les collisions");
  showCollisionCheckbox.setOpaque(false);
  showCollisionCheckbox.addEventHandler(this, "showCollisionCheckbox_clicked1");
  objectCollision = new GButton(this, 3, 45, 260, 20);
  objectCollision.setText("Désactiver les collisions d'un objet");
  objectCollision.addEventHandler(this, "objectCollision_click1");
  collision_panel.addControl(showCollisionCheckbox);
  collision_panel.addControl(objectCollision);
  camera_panel = new GPanel(this, 0, 189, 266, 200, "Camera");
  camera_panel.setCollapsed(true);
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
  objects_panel.setCollapsed(true);
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
  exportPannel = new GPanel(this, 0, 38, 266, 634, "Exporter");
  exportPannel.setCollapsed(true);
  exportPannel.setDraggable(false);
  exportPannel.setText("Exporter");
  exportPannel.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  exportPannel.setOpaque(true);
  exportPannel.addEventHandler(this, "exportPannel_Click3");
  saveMapButton = new GButton(this, 3, 25, 260, 20);
  saveMapButton.setText("Sauvegarder le projet");
  saveMapButton.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  saveMapButton.addEventHandler(this, "saveMapButton_click1");
  exportPannel.addControl(saveMapButton);
}

// Variable declarations 
// autogenerated do not edit
GView view1; 
GPanel main_panel; 
GPanel main_layout_panel; 
GPanel collision_panel; 
GCheckbox showCollisionCheckbox; 
GButton objectCollision; 
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
GPanel exportPannel; 
GButton saveMapButton; 
