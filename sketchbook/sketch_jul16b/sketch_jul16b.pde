float x,y,r,vx,vy;
float f(float k)
{
  return k*k;
}
void setup()
{
  size(1000,1000);
  x=200;
  y=200;
  r=20;
  vx=0;
  vy=0;  
  background(69,170,117);
}
void draw()
{
  float a,b;
  a=mouseX;
  b=mouseY;
  if(mousePressed==true&&f(a-x)+f(b-y)<=f(r))
  {
    x=a;
    y=b;
  }
  stroke(255,255,0);
  fill(255,255,0);
  ellipse(x,y,2*r,2*r);
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
