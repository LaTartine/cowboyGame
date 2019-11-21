

public class Scroller {
  PVector pos = new PVector(0,0);
  float sWidth = 0;
  float sHeight = 0;
  boolean isSelected=false;
  
  
  Scroller (float posX, float posY, float sWidth, float sHeight) {
    this.pos.x = posX;
    this.pos.y = posY;
    this.sWidth = sWidth;
    this.sHeight = sHeight;
    this.isSelected=false;
  }
  
  //GETTERS
  public PVector getPos(){
    return this.pos;
  }
  
  public float getPosX(){
    return this.pos.x;
  }
  
  public float getPosY(){
    return this.pos.y;
  }
  
  public float getWith(){
    return this.sWidth;
  }
  
  public float getHeight(){
    return this.sHeight;
  }
  
  //SETTERS
  
  public void setPosY( float y )
  {
    this.pos.y = y;
  }
  
  
  public void setWidth( float width )
  {
    this.sWidth = width;
  }
  
  public void setHeight( float height )
  {
    this.sHeight = height ;
  }
  
  //methode pour afficher scroller
  public void drawScroller(PGraphics view){
    noStroke();
    if (this.isSelected == true) {
      fill(200, 200, 200, 255);
    } else {
      fill(255, 255, 255, 255);
    }
    
    view.rect(this.pos.x, this.pos.y, this.sWidth, this.sHeight);
  }
  
  
 
}
