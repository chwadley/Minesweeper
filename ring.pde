class ring {
  private float x,y;        //pos
  private float r,dr;       //radius & rate of change of radius
  private float op,dop,opd; //opacity, rate of change of opacity, and opacity decay rate
  
  public ring(float _x, float _y) {
    x = _x;
    y = _y;
    r = 0;
    dr = 5;
    op = 1;
    dop = -0.01;
    opd = 0.99;
  }
  
  public void move() {
    r += dr;
    op += dop;
    op *= opd;
  }
  
  public void show() {
    stroke(255,op*255);
    strokeWeight(3);
    noFill();
    ellipse(x,y,r,r);
  }
}
