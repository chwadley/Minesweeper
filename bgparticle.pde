class bgparticle {
  float w,h,x,y,dx,dy;
  int r,g,b;
 
  public bgparticle(float _w, float _h, float _x, float _y, float _a, int _r, int _g, int _b) {
    w=_w;
    h=_h;
    x=_x;
    y=_y;
    dx=cos(_a)*5;
    dy=sin(_a)*5;
    r=_r;
    g=_g;
    b=_b;
  }
 
  public void move() {
    x+=dx;
    y+=dy;
    if (x<-w) {x=width+w;}
    if (y<-w) {y=height+w;}
    if (x>width+w) {x=-w;}
    if (y>height+w) {y=-w;}
  }
 
  public void show() {
    stroke(r,g,b);
    strokeWeight(h);
    float mag = (float)Math.sqrt(dx*dx+dy*dy);
    line(x-dx*w/mag,y-dy*w/mag,x+dx*w/mag,y+dy*w/mag);
  }
}
