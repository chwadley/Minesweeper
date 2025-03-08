class explodeparticle {
  float x,y,dx,dy; //pos&vel
  int r,g,b;       //color
  float s;         //size
  float fr;        //friction
  float gr;        //gravity
  ArrayList <Float> historyX = new ArrayList <Float>();
  ArrayList <Float> historyY = new ArrayList <Float>();
  public explodeparticle(float _x, float _y, float _a, float _v, int _r, int _g, int _b) {
    x = _x;
    y = _y;
    dx = cos(_a)*_v;
    dy = sin(_a)*_v;
    r = _r;
    g = _g;
    b = _b;
    fr = 0.97;
    gr = 0.5;
    s = 15;
  }
 
  public void move() {
    dy+=gr;
    dx*=fr;
    dy*=fr;
    s*=0.99;
    s-=0.2;
    x+=dx;
    y+=dy;
  }
 
  public void show() {
    noStroke();
    fill(r,g,b);
    ellipse(x,y,s,s);
  }
 
  /*public void draw() {
    if (s<=5) {
      move();
      show();
    }
  }*/
}
