import de.bezier.guido.*;
public button[][] buttons;
float ix,iy;
public final static int w = 10;
public final static int h = 10;
boolean[][] mines;
int[][] nums;
boolean dead = false;
boolean isGoat = false;
boolean isPossibleToBeGoated;
int oTimer = 0;
int oAction = 0;
ArrayList <bgparticle> bgparticles = new ArrayList <bgparticle>();
ArrayList <explodeparticle> explodeparticles = new ArrayList <explodeparticle>();
ArrayList <ring> rings = new ArrayList <ring>();
float f;
int oSubAction = 0;
int bgTimer = 0;
int targetMap = 0;
String resetFunction;
public final static int ACT_MAIN_SCREEN = 0;
public final static int ACT_MINESWEEPER = 1;
public final static int ACT_DEATH = 2;
public final static int ACT_WIN = 3;
public final static int SUBACT_PRELOAD = 0;
public final static int SUBACT_LOADED = 1;
public final static int SUBACT_POSTLOAD = 2;
public final static int SUBACT_EXPLODE = 3;
public final static int SUBACT_WIN = 4;

float _random(float a, float b) {
  return (float)(Math.random()*(b-a)+a);
}

int _randint(float a, float b) {
  return (int)(Math.random()*(b-a)+a);
}

public boolean isValid(int x, int y) {
  return x>=0&&y>=0&&x<w&&y<h;
}

public int getNeighbors(boolean[][] mines, int x, int y) {
  int a=0;
  for (int _y=-1;_y<2;_y++) {
    for (int _x=-1;_x<2;_x++) {
      if (x+_x>=0&&y+_y>=0&&x+_x<w&&y+_y<h&&mines[x+_x][y+_y]) a++;
    }
  }
  return a;
}

public void setup() {
  size(800,800);
  oAction = ACT_MAIN_SCREEN;
  oSubAction = SUBACT_LOADED;
  oTimer = 0;
  bgTimer = 0;
  startAction0();
}

public void startAction0() {
  for (int i=0;i<100;i++) {
    bgparticles.add(new bgparticle(_random(10,50),_random(10,20),_random(0,width),_random(0,height),_random(0,2*PI),_randint(0,255),_randint(0,255),_randint(0,255)));
  }
}

public void startAction1() {
  textAlign(CENTER);
  textSize(24);
  // make the manager
  Interactive.make(this);
  buttons = new button[w][h];
  mines = new boolean[w][h];
  nums = new int[w][h];
  float margin = 0;
  ix = (float)(width-margin)/w;
  iy = (float)(height-margin)/h;
  
  for (int i=0;i<w*h/10.;i++) {
    mines[_randint(0,w-1)][_randint(0,h-1)] = true;
  }
  
  for (int y=0;y<h;y++) {
    for (int x=0;x<w;x++) {
      buttons[x][y] = new button(margin+y*iy,margin+x*ix,(ix-margin),(iy-margin),x,y);
      
      //board[x][y].setLabel("X");
    }
  }
 
  for (int y=0;y<h;y++) {
    for (int x=0;x<w;x++) {
      nums[x][y] = getNeighbors(mines,x,y);
    }
  }
 
  //oTimer = 0;
}

public void startDeath(float x, float y) {
  if (explodeparticles.size()<=0) {
    for (int i=0;i<200;i++) {
      explodeparticles.add(new explodeparticle(x,y,_random(0,2*PI),_random(8,16),255,_randint(0,255),0));
    }
  } else {
    for (int i=0;i<200;i++) {
      explodeparticles.set(i,new explodeparticle(x,y,_random(0,2*PI),_random(8,16),255,_randint(0,255),0));
    }
  }
  
  oTimer = 0;
  
  oAction = ACT_DEATH;
}

public void reset() {
  textAlign(CENTER);
  textSize(24);
 
  for (int y=0;y<h;y++) {
    for (int x=0;x<w;x++) {
      buttons[x][y].reset();
      mines[x][y] = (Math.random())>0.9;
    }
  }
 
  for (int y=0;y<h;y++) {
    for (int x=0;x<w;x++) {
      nums[x][y] = getNeighbors(mines,x,y);
    }
  }
 
  oTimer = 0;
  isGoat = false;
  dead = false;
}
//4,-2,3,7,6
//char is b
//number is 2
public void draw() {
  switch (oAction) {
    case ACT_MAIN_SCREEN:
      f = (float)(frameCount)/240*2*PI;
      //System.out.println(f);
      background((int)(sin(f)*64+64),(int)(sin(f)*64+64),(int)(cos(f)*128+128));
     
      for (int i=0;i<bgparticles.size();i++) {
        bgparticle a = bgparticles.get(i);
        a.move();
        a.show();
      }
     
      textAlign(CENTER,CENTER);
      textSize(30);
      float _rot = sin((frameCount)*2*PI/240)*2*PI/24;
      translate(width/2,height/2);
      rotate(_rot);
      fill(0);
      int maxI=30;
      for (int i=0;i<maxI;i++) {
        f = (float)(i)/maxI*2*PI;
        text("minesweeper",cos(f)*3,sin(f)*3);
      }
      fill(255);
      text("minesweeper",0,0);
      rotate(-_rot);
      translate(-width/2,-height/2);
     
      textSize(20);
      noFill();
      fill(0);
      translate(width/2,3*height/4);
      /*int maxI=30;
      for (int i=0;i<maxI;i++) {
        f = (float)(i)/maxI*2*PI;
        text("press enter",cos(f)*5,sin(f)*5);
      }*/
      fill(255,oSubAction==SUBACT_PRELOAD?(255-bgTimer/7.*255):255);
      float sc = (oSubAction==SUBACT_PRELOAD)?(1+bgTimer/20.):1;
      scale(sc);
      text("press enter",0,0);
      scale(1/sc);
      translate(-width/2,-3*height/4);
      strokeWeight(1);
      noStroke();
      break;
    case ACT_MINESWEEPER:
      background(0);
      isPossibleToBeGoated = true;
      for (button[] row:buttons) {
        for (button col:row) {
          if (col.isFlagged()!=col.isMine()) isPossibleToBeGoated = false;
          if (!(col.isOn()||col.isFlagged())) isPossibleToBeGoated = false;
        }
      }
      if (isPossibleToBeGoated && oSubAction == SUBACT_LOADED) startLoad(ACT_WIN,"");
      break;
    case ACT_DEATH:
      background(0);
      translate(width/2-100,height/2);
      float sc1 = 5+(frameCount%120<10?cos(((float)(frameCount)%120)/10*2*PI)-1:0); //scale factor
      scale(sc1);
      translate(0,10);
      fill(0);
      stroke(255);
      strokeWeight(1);
      beginShape();
      vertex(0,0);
      vertex(0,-10);
      float o1 = 3;      //"offset 1" - changes width of cursor
      float a1 = 7*PI/4; //"angle 1"  - changes angle of cursor
      vertex((float)(5*Math.sqrt(2)),(float)(-10+5*Math.sqrt(2)));
      vertex((float)(5*Math.sqrt(2))-o1,(float)(-10+5*Math.sqrt(2)));
      vertex((float)(5*Math.sqrt(2)+cos(3*PI/8)*4)-o1,(float)(-10+5*Math.sqrt(2)+sin(3*PI/8)*4));
      vertex((float)(o1*cos(a1)+cos(3*PI/8)*4),(float)(o1*sin(a1)+sin(3*PI/8)*4));
      vertex((float)(o1*cos(a1)),(float)(o1*sin(a1)));
      endShape(CLOSE);
      translate(0,-10);
      scale(1/sc1);
      translate(-(width/2-50),-(height/2));
      noStroke();
      fill(255*oTimer/10);
      text("restart",width/2+100,height/2);
      for (int r=0;r<buttons.length;r++) {
        for (int c=0;c<buttons[r].length;c++) {
          buttons[r][c].show();
        }
      }
      if (frameCount%120==5) {
        rings.add(new ring(width/2-50,height/2));
      }
      for (int i=0;i<rings.size();i++) {
        ring a = rings.get(i);
        a.move();
        a.show();
      }
      if (oTimer<10) oTimer++;
      break;
    case ACT_WIN:
      background(0);
      noStroke();
      fill(255);
      text("yay",width/2,height/2);
      fill(255*oTimer/10);
      text("restart",width/2,3*height/4);
      if (oTimer<10) oTimer++;
      break;
  }
  
  for (int i=0;i<explodeparticles.size();i++) {
    explodeparticle a = explodeparticles.get(i);
    if (a.s>1) {
      a.move();
      a.show();
    } else {
      explodeparticles.remove(i);
      i--;
    }
  }
  
  //fade in
  if (oSubAction==SUBACT_POSTLOAD) {
    bgTimer--;
    fill(0,(float)(bgTimer)/20*255);
    rect(0,0,width,height);
    if (bgTimer<=0) {
      oSubAction = SUBACT_LOADED;
    }
  }
 
  //fade out
  if (oSubAction==SUBACT_PRELOAD) {
    bgTimer++;
    fill(0,(float)(bgTimer)/20*255);
    rect(0,0,width,height);
    if (bgTimer>=20) {
      oAction = targetMap;
      oSubAction = SUBACT_POSTLOAD;
      switch (resetFunction) {
        case "startAction1":
          startAction1();
          break;
        case "reset":
          reset();
          break;
        default:
          break;
      }
      //System.out.println(resetFunction);
    }
  }
 
  /*fill(255);
  text(oAction,50,50);
  text(oSubAction==0?"PRELOAD":oSubAction==1?"LOADED":"POSTLOAD",50,100);
  text(bgTimer,50,150);*/
  //System.out.println(bgTimer);
}

void startLoad(int _targetMap, String _resetFunction) {
  oSubAction = SUBACT_PRELOAD;
  bgTimer = 0;
  targetMap = _targetMap;
  resetFunction = _resetFunction;
}

void mousePressed() {
  if (oAction==ACT_DEATH&&oTimer>=10) {
    startLoad(ACT_MINESWEEPER,"reset");
  }
  
  if (oAction==ACT_WIN&&oSubAction==SUBACT_LOADED) {
    startLoad(ACT_MINESWEEPER,"reset");
  }
}

void keyPressed() {
  //System.out.println(keyCode);
  if (keyCode==10) {
    if (oAction==ACT_MAIN_SCREEN&&oSubAction==SUBACT_LOADED) {
      oTimer=0;
      startLoad(ACT_MINESWEEPER,"startAction1");
    }
  }
}
