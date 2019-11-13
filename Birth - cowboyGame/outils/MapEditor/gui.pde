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

public void panel1_Click1(GPanel source, GEvent event) { //_CODE_:main_panel:382755:
  println("panel1 - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:main_panel:382755:

public void panel2_Click1(GPanel source, GEvent event) { //_CODE_:main_layout_panel:472694:
  println("main_layout_panel - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:main_layout_panel:472694:

public void collision_panel_Click1(GPanel source, GEvent event) { //_CODE_:collision_panel:417304:
  println("collision_panel - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:collision_panel:417304:

public void camera_panel_Click1(GPanel source, GEvent event) { //_CODE_:camera_panel:412621:
  println("camera_panel - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:camera_panel:412621:



public void panel1_Click2(GPanel source, GEvent event) { //_CODE_:objects_panel:468081:
  println("panel1 - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:objects_panel:468081:

public void panel4_Click1(GPanel source, GEvent event) { //_CODE_:down_panel:531207:
  println("panel4 - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:down_panel:531207:

public void panel7_Click1(GPanel source, GEvent event) { //_CODE_:panel7:385929:
  println("panel7 - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:panel7:385929:

public void panel8_Click1(GPanel source, GEvent event) { //_CODE_:settings_panel:419590:
  println("panel8 - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:settings_panel:419590:





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
  collision_panel.addEventHandler(this, "collision_panel_Click1");
  camera_panel = new GPanel(this, 0, 189, 266, 200, "Camera");
  camera_panel.setText("Camera");
  camera_panel.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  camera_panel.setOpaque(true);
  camera_panel.addEventHandler(this, "camera_panel_Click1");
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
  objects_panel = new GPanel(this, 0, 454, 266, 80, "Objets");
  objects_panel.setText("Objets");
  objects_panel.setOpaque(true);
  objects_panel.addEventHandler(this, "panel1_Click2");
  main_layout_panel.addControl(collision_panel);
  main_layout_panel.addControl(camera_panel);
  main_layout_panel.addControl(objects_panel);
  main_panel.addControl(main_layout_panel);
  down_panel = new GPanel(this, 0, 673, 1598, 229, "Tab bar text");
  down_panel.setDraggable(false);
  down_panel.setText("Tab bar text");
  down_panel.setOpaque(true);
  down_panel.addEventHandler(this, "panel4_Click1");
  resetInt = new GButton(this, 206, 635, 60, 15);
  resetInt.setText("Reset");
  resetInt.addEventHandler(this, "resetInt_click1");
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
  label4.setText("Vue");
  label4.setLocalColorScheme(GCScheme.RED_SCHEME);
  label4.setOpaque(true);
  settings_panel.addControl(internVar);
  settings_panel.addControl(internvarop);
  settings_panel.addControl(label2);
  settings_panel.addControl(label3);
  settings_panel.addControl(Resetint);
  settings_panel.addControl(label4);
}

// Variable declarations 
// autogenerated do not edit
GView view1; 
GPanel main_panel; 
GPanel main_layout_panel; 
GPanel collision_panel; 
GPanel camera_panel; 
GButton button3; 
GTextField CamX; 
GTextField CamY; 
GTextField camZoom; 
GButton button1; 
GButton centerCamY; 
GLabel label5; 
GPanel objects_panel; 
GPanel down_panel; 
GButton resetInt; 
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
