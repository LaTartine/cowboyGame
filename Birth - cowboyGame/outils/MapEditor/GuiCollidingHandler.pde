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
  //println("tableau new remplit");
  



    for(int i = 0; i<panels_in_main_new.length; i++){
        //println("comparaison");
        //println("old="+panels_in_main_new[i].getY()+" ; new="+panels_in_main_old[i]);
     if(panels_in_main_new[i].getY() != panels_in_main_old[i] || panels_in_main_new[i].isOver( mouseX, mouseY )){
         //println("changments détectés");
        panels_in_main_old[i]=panels_in_main_new[i].getY();
        for(int k = 0 ; k<panels_in_main_new.length ; k++){
          testCollision(panels_in_main_new[i], panels_in_main_new[k]);
        }
        
     }
  }

}

void initializeArrayOfPanels(){
      panels_in_main_old [0] = camera_panel.getY(); 
      panels_in_main_old [1] = collision_panel.getY();
      panels_in_main_old [2] = objects_panel.getY();
      //println("old est plein");
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
}
