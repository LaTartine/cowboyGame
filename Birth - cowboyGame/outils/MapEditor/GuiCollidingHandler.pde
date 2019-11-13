//remplit le tableau de panels
void GuiCollidingHandler()
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
  println("tableau new remplit");
  if(initialize == false){
      panels_in_main_old [0] = camera_panel; 
      panels_in_main_old [1] = collision_panel;
      panels_in_main_old [2] = objects_panel;
      initialize = true;
        println("tableau old remplit");
  }
    for(int i = 0; i<panels_in_main_new.length; i++){
        println("comparaison");
     if(panels_in_main_new[i].getY() == panels_in_main_old[i].getY()){
         println("ras");
     }else {
         println("changments détectés");
        panels_in_main_old[i]=panels_in_main_new[i];
        testAllCollisions(panels_in_main_new);
        
     }
  }

}

//regarde si les panels ont changés de place
void testAllCollisions(GPanel [] panel){
  for(int i = 0; i<panel.length ; i++) {
    for(int k = 0 ; k<panel.length ; k++){
      if(i!=k){
        if( panel[i].isOver( mouseX, mouseY ) || panel[i].isDragging() )
        {
          testCollision(panel[i],panel[k]);
        }
        else if( panel[k].isOver( mouseX, mouseY ) || panel[k].isDragging() )
        {
          testCollision(panel[k],panel[i]);
        }
      }
    }
  }
}

//s'ocuppe des collisions entre 2 pannels
void testCollision( GPanel panelInHand, GPanel panelToPush )
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
    /*println(collision_panel.getWidth());
    if( camera_panel.getY() < collision_panel.getY() )
    {
      if( collision_panel.getY() > camera_panel.getY() && collision_panel.getY() < camera_panel.getY()+camera_panel.getTabHeight() &&
          collision_panel.getX()+collision_panel.getWidth() > camera_panel.getX() && collision_panel.getX() < camera_panel.getX()+camera_panel.getWidth() )
      {
        camera_panel.moveTo( camera_panel.getX(), collision_panel.getY()-camera_panel.getTabHeight());
      }
     }
    else if( camera_panel.getY() > collision_panel.getY())
    {
       if( collision_panel.getY()+collision_panel.getTabHeight() > camera_panel.getY() && collision_panel.getY()+collision_panel.getTabHeight() < camera_panel.getY()+camera_panel.getTabHeight() &&
           collision_panel.getX()+collision_panel.getWidth() > camera_panel.getX() && collision_panel.getX() < camera_panel.getX()+camera_panel.getWidth()  )
       {
         camera_panel.moveTo( camera_panel.getX(), collision_panel.getY()+collision_panel.getTabHeight());
       }
    }*/
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
  
  /*if( panelToPush.getY()-panelToPush.getTabHeight() < main_layout_panel.getY()-main_layout_panel.getTabHeight() || panelToPush.getY()+panelToPush.getHeight()+panelToPush.getTabHeight() > main_layout_panel.getY()+main_layout_panel.getHeight()-main_layout_panel.getTabHeight() ) //si la fenetre sort du parent et qu'elle est donc bloquée, la fenetre avec laquelle on pousse est aussi bloquée
  {
    panelInHand.setDraggable(false);
  }
  else
  {
    panelInHand.setDraggable(true);
  }*/
}
