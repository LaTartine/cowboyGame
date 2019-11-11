
void GuiCollidingHandler()
{
  if( panel5.isOver( mouseX, mouseY ) || panel5.isDragging() )
  {
    testCollision(panel5,panel6);
  }
  else if( panel6.isOver( mouseX, mouseY ) || panel6.isDragging() )
  {
    testCollision(panel6,panel5);
  }
}

void testCollision( GPanel panelInHand, GPanel panelToPush )
{
  if( panelToPush.isCollapsed() && !panelInHand.isCollapsed() )
  {
    if( panelToPush.getY() < panelInHand.getY() && panelToPush.getY() > panel2.getY()-panel2.getTabHeight() )
    {
      if( panelInHand.getY() > panelToPush.getY() && panelInHand.getY() < panelToPush.getY()+panelToPush.getTabHeight() )
      {
        panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()-panelToPush.getTabHeight());
      }
     }
    else if( panelToPush.getY() > panelInHand.getY() && panelToPush.getY()+panelToPush.getHeight() < panel2.getY()+panel2.getHeight()-panel2.getTabHeight()  )
    {
       if( panelInHand.getY()+panelInHand.getHeight() > panelToPush.getY() && panelInHand.getY()+panelInHand.getTabHeight() < panelToPush.getY()+panelToPush.getTabHeight() )
       {
         panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()+panelInHand.getHeight());
       }
    }
  }
  else if( !panelToPush.isCollapsed() && !panelInHand.isCollapsed() )
  {
    if( panelToPush.getY() < panelInHand.getY() && panelToPush.getY() > panel2.getY()-panel2.getTabHeight() ) //si le panneau à pousser est au dessus et si il ne dépasse pas de son parent
    {
      if( panelInHand.getY() > panelToPush.getY() && panelInHand.getY() < panelToPush.getY()+panelToPush.getHeight() ) //si le panneau qui pousse entre en constact avec le panneau à pousser
      {
        panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()-panelToPush.getHeight()); //deplacer le panneau à pousser
      }
     }
    else if( panelToPush.getY() > panelInHand.getY() && panelToPush.getY()+panelToPush.getHeight() < panel2.getY()+panel2.getHeight()-panel2.getTabHeight()  )
    {
       if( panelInHand.getY()+panelInHand.getHeight() > panelToPush.getY() && panelInHand.getY()+panelInHand.getHeight() < panelToPush.getY()+panelToPush.getHeight() )
       {
         panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()+panelInHand.getHeight());
       }
    }
  }
  
  else if( panelToPush.isCollapsed() && panelInHand.isCollapsed() )
  {
    /*println(panel5.getWidth());
    if( panel6.getY() < panel5.getY() )
    {
      if( panel5.getY() > panel6.getY() && panel5.getY() < panel6.getY()+panel6.getTabHeight() &&
          panel5.getX()+panel5.getWidth() > panel6.getX() && panel5.getX() < panel6.getX()+panel6.getWidth() )
      {
        panel6.moveTo( panel6.getX(), panel5.getY()-panel6.getTabHeight());
      }
     }
    else if( panel6.getY() > panel5.getY())
    {
       if( panel5.getY()+panel5.getTabHeight() > panel6.getY() && panel5.getY()+panel5.getTabHeight() < panel6.getY()+panel6.getTabHeight() &&
           panel5.getX()+panel5.getWidth() > panel6.getX() && panel5.getX() < panel6.getX()+panel6.getWidth()  )
       {
         panel6.moveTo( panel6.getX(), panel5.getY()+panel5.getTabHeight());
       }
    }*/
  }
  else if( !panelToPush.isCollapsed() && panelInHand.isCollapsed() )
  {
    if( panelToPush.getY() < panelInHand.getY() && panelToPush.getY() > panel2.getY()-panel2.getTabHeight() )
    {
      if( panelInHand.getY() > panelToPush.getY() && panelInHand.getY() < panelToPush.getY()+panelToPush.getHeight() )
      {
        panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()-panelToPush.getHeight());
      }
     }
    else if( panelToPush.getY() > panelInHand.getY() && panelToPush.getY()+panelToPush.getHeight() < panel2.getY()+panel2.getHeight()-panel2.getTabHeight()  )
    {
       if( panelInHand.getY()+panelInHand.getTabHeight() > panelToPush.getY() && panelInHand.getY()+panelInHand.getTabHeight() < panelToPush.getY()+panelToPush.getHeight() )
       {
         panelToPush.moveTo( panelToPush.getX(), panelInHand.getY()+panelInHand.getTabHeight());
       }
    }
  }
  
  /*if( panelToPush.getY()-panelToPush.getTabHeight() < panel2.getY()-panel2.getTabHeight() || panelToPush.getY()+panelToPush.getHeight()+panelToPush.getTabHeight() > panel2.getY()+panel2.getHeight()-panel2.getTabHeight() ) //si la fenetre sort du parent et qu'elle est donc bloquée, la fenetre avec laquelle on pousse est aussi bloquée
  {
    panelInHand.setDraggable(false);
  }
  else
  {
    panelInHand.setDraggable(true);
  }*/
}
