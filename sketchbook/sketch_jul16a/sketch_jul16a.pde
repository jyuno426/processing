import ddf.minim.*;

Minim minim;
AudioPlayer song;

float f(float x)
{
  return x*x;
}

void setup()
{
  size(400,400);
  background(255,255,255);
  minim = new Minim(this);
  song = minim.loadFile("song.mp3");
  song.play();
}

float px1=50,py1=50,vx1=5,vy1=7;
float px2=200,py2=200,vx2=-3,vy2=-9;
float r1=25,r2=15;

void draw()
{
  background(255,128,0);
  ellipse(px1,py1,2*r1,2*r1);
  ellipse(px2,py2,2*r2,2*r2);
  px1+=vx1;
  py1+=vy1;
  px2+=vx2;
  py2+=vy2;  
  if(px1-r1<0||px1+r1>400)vx1=-vx1;
  if(py1-r1<0||py1+r1>400)vy1=-vy1;
  if(px2-r2<0||px2+r2>400)vx2=-vx2;
  if(py2-r2<0||py2+r2>400)vy2=-vy2;
}
