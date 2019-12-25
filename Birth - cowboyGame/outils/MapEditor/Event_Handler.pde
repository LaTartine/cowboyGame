
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
    
    if( float(CamX.getText()) > -999999999 && float(CamX.getText()) < 999999999 ) //si l'utilisateur entre bien un chiffre
    {
      viewPos.x = float(CamX.getText()); //deplacer la cam
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

    if( float(CamY.getText()) > -999999999 && float(CamY.getText()) < 999999999 )
    {
      viewPos.y = float(CamY.getText());
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

    if( float(camZoom.getText()) > -999999999 && float(camZoom.getText()) < 999999999 )
    {
      viewZoom = float(camZoom.getText())/100;
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

    if( float(chunkX.getText()) > -999999999 && float(chunkX.getText()) < 999999999 )
    {
      chunkSize.x=(float(chunkX.getText()));
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

    if( float(chunkY.getText()) > -999999999 && float(chunkY.getText()) < 999999999 )
    {
      chunkSize.y=(float(chunkY.getText()));
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
       if( float(posXObj.getText()) > -999999999 && float(posXObj.getText()) < 999999999 )
       {
        items.get(i).setMapPos( float(posXObj.getText()) , items.get(i).getMapPos().y );
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
       if( float(posYObj.getText()) > -999999999 && float(posYObj.getText()) < 999999999 )
       {
        items.get(i).setMapPos( items.get(i).getMapPos().x , float(posYObj.getText()) );
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
       if( float(posYObj.getText()) > -999999999 && float(posYObj.getText()) < 999999999 )
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
