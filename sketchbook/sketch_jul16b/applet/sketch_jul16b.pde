float x,y;
void setup()
{
  size(400,400);
  x=200;
  y=200;
}
void draw()
{
  background(69,170,117);
  ellipse(x,y,50,50);
}
void keyPressed()
{
  if(keyCode==UP)y-=5;
  if(keyCode==DOWN)y+=5;
  if(keyCode==LEFT)x-=5;
  if(keyCode==RIGHT)x+=5;
}
