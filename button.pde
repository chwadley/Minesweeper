public class button {
  private float initialX,initialY,initialR;
  private float x,y,width,height;
  private float dx,dy; //vel      (used for explosion)
  private float r;     //rotation (used for explosion)
  private float op;    //opacity  (used for explosion)
  private float dr;    //rot vel  (used for explosion)
  private boolean on,flagged;
  private String label;
  private int idx,idy;
  private int __x,__y;
 
  public button(float xx,float yy,float _w,float _h,int _idx,int _idy) {
    initialX = xx;
    initialY = yy;
    initialR = 0;
    x=xx;y=yy;width=_w;height=_h;idx=_idx;idy=_idy;
    resetVel();
    label="";
    r=0;
    op=1;
    Interactive.add(this);
  }
  
  public void resetVel() {
    dx = _random(-5,5);
    dy = _random(-5,5);
    dr = _random(-PI/24,PI/24);
  }
  
  public boolean isMine() {
    return mines[idx][idy];
  }
 
  public void mousePressed() {
    if (mouseButton==LEFT) {
      if (isMine()) {
        if (oAction==ACT_MINESWEEPER) {
          startDeath(x+width/2,y+height/2);
          dead=true;
        }
      }
      else if (!flagged) register();
    }
    else flag();
  }
 
  public void reset() {
    flagged = false;
    on = false;
    label = "";
    resetVel();
    op = 1;
    x = initialX;
    y = initialY;
    r = initialR;
  }
 
  public void flag() {
    flagged = !flagged;
  }
 
  public boolean isFlagged() {return flagged;}
 
  public void register() {
    on=true;
    setLabel(""+nums[idx][idy]); //processing.js doesn't allow you to convert from Integer to String so I have to use this workaround. :(
    if (nums[idx][idy]==0) {
      registerAnother(idx-1,idy);
      registerAnother(idx,idy-1);
      registerAnother(idx+1,idy);
      registerAnother(idx,idy+1);
      registerAnother(idx-1,idy-1);
      registerAnother(idx+1,idy-1);
      registerAnother(idx+1,idy+1);
      registerAnother(idx-1,idy+1);
    }
  }
 
  public void registerAnother(int __x,int __y) {
    if (isValid(__x,__y)&&!buttons[__x][__y].isOn()) {
      buttons[__x][__y].register();
    }
  }
  
  public void show() {
    if (oAction==ACT_DEATH) {
      x+=dx;
      y+=dy;
      r+=dr;
      op*=0.95;
      noStroke();
    } else {
      stroke(0);
    }
    strokeWeight(1);
    fill(on?(mines[idx][idy]?255:200):(flagged?50:100),op*255);
    translate(x+width/2,y+height/2);
    rotate(r);
    rect(-width/2,-height/2,width,height);
    fill(0);
    noStroke();
    text(label,0,0);
    rotate(-r);
    translate(-x-width/2,-y-height/2);
  }
 
  public void draw() {
    if (oAction!=ACT_DEATH && oAction!=ACT_WIN) {
      show();
    }
    if (bgTimer>0) {
      fill(0,(float)(bgTimer)/20*255);
      rect(x,y,width,height);
    }
    /*textAlign(CENTER,CENTER);
    fill(255);
    text(oAction==0?"PRELOAD":oAction==1?"LOADED":"POSTLOAD",50,50);
    text(oSubAction,50,100);
    text(bgTimer,50,150);*/
  }
 
  public boolean isOn() {return on;}
 
  public void setLabel(String _label) {
    label=_label;
  }
 
  public String getLabel() {
    return label;
  }
}
