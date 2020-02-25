class Mobile
{
  float px,py,vx,vy;
  void move()
  {
    px+=vx;
    py+=vy;
    if(px<0)px=480;
    if(px>480)px=0;
    if(py<0)py=480;
    if(py>480)py=0;    
  }
}
class Roid extends Mobile
{
  Roid()
  {
    px=random(480);
    py=random(480);
    vx=random(-2,2);
    vy=random(-2,2);
  }
  void move()
  {
    super.move();
    rect(px,py,20,20);
  }
}
class Ship extends Mobile
{
  float r=-PI/2;
  Ship()
  {
    px=240;
    py=240;
  }
  void move()
  {
    super.move();
    if(keyPressed)
    {
      if(keyCode==LEFT)r-=0.125;
      if(keyCode==RIGHT)r+=0.125;
      if(keyCode==UP)
      {
        vx+=0.125*cos(r);
        vy+=0.125*sin(r);        
      }
    }
    pushMatrix();
    translate(px,py);
    rotate(r);
    triangle(0,0,-10,10,-10,-10);
    popMatrix();
  }
}
List<Roid> roids=new ArrayList<Roid>();
Ship player=new Ship();
void setup()
{
  size(480,480);
  rectMode(CENTER);
  for(int x=0;x<10;x++)roids.add(new Roid());
}
void draw()
{
  background(0,0,0);
  for(int x=0;x<roids.size();x++)
  {
    Roid m=roids.get(x);
    m.move();
    if(dist(player.px,player.py,m.px,m.py)<15)player=new Ship();
  }
  player.move();
}
