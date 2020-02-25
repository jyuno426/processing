float x,y,r,vx,vy;
int check=0;
PImage ball,jump;
void setup()
{
  size(1000,1000);
  x=200;
  y=200;
  r=70;
  vx=0;
  vy=0;
}
void draw()
{
  float a,b;
  background(255,255,255);
  if(check<6)ball=loadImage("soccer ball4.png");
  else if(check<12)ball=loadImage("soccer ball3.png");
  else if(check<18)ball=loadImage("soccer ball2.png");
  else if(check<24)ball=loadImage("soccer ball1.png"); 
  image(ball,x,y);
  jump=loadImage("jump.png");
  image(jump,700,670);
  line(0,700,1000,700);
  if(x>650&&x<750&&y+r>670)
  {
    vy=-15;
    y+=vy;
  }
  else if(x<0||x+r>1000)
  {
    x-=vx;
    vx=-vx*3/4;
  }
  else if(y+r>700)
  {
    y-=vy;
    vy=-vy*3/4;
  }
  x+=vx;
  y+=vy;
  vy+=0.2;
  check++;
  while(check<0)check+=24;
  check%=24;
}
void keyPressed()
{
  if(keyCode==LEFT)vx-=0.1;
  if(keyCode==RIGHT)vx+=0.1;
}
