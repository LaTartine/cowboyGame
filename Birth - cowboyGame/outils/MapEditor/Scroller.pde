

public class Scroller {
  PVector pos = new PVector(0,0);
  float sWidth = 0;
  float sHeight = 0;
  boolean isSelected=false;
  float pos_View; //position des élements
  
  
  Scroller (float posX, float posY, float sWidth, float sHeight, float posView) {
    this.pos.x = posX;
    this.pos.y = posY;
    this.sWidth = sWidth;
    this.sHeight = sHeight;
    this.isSelected=false;
    this.pos_View = posView;
  }
  
  //GETTERS
  public PVector getPos(){
    return this.pos;
  }
  
  public float getPosView(){
    return this.pos_View;
  }
  
  public float getPosX(){
    return this.pos.x;
  }
  
  public float getPosY(){
    return this.pos.y;
  }
  
  public float getWidth(){
    return this.sWidth;
  }
  
  public float getHeight(){
    return this.sHeight;
  }
  
   public boolean getSelected(){
    return this.isSelected;
  }
  
  //SETTERS
  
  public void setPosX( float x )
  {
    this.pos.x = x;
  }
  
    public void setPosView( float x )
  {
    this.pos_View = x;
  }
  
  public void setWidth( float width )
  {
    this.sWidth = width;
  }
  
  public void setHeight( float height )
  {
    this.sHeight = height ;
  }
  
  public void setSelected (boolean is )
  {
    this.isSelected = is ;
  }
 
  
  
  //methode pour afficher scroller
  public void drawScroller(PGraphics view){
    noStroke();
    if (this.isSelected == true) {
      fill(200, 200, 200, 255);
    } else {
      fill(0, 0, 0, 255);
    }
    
    view.rect(this.pos.x, this.pos.y, this.sWidth, this.sHeight);
  }
  
  
  
 
}
