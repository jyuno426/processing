float x,y,r,vx,vy;
PImage ball;
void setup()
{
  size(1000,1000);
  x=200;
  y=200;
  r=20;
  vx=0;
  vy=0;
  ball=loadImage("soccer ball.png");
  background(69,170,117);
}
void draw()
{
  float a,b;
  image(ball,x,y);
  x+=vx;
  y+=vy;
}
void keyPressed()
{
  if(keyCode==UP)vy-=0.1;
  if(keyCode==DOWN)vy+=0.1;
  if(keyCode==LEFT)vx-=0.1;
  if(keyCode==RIGHT)vx+=0.1;
}
