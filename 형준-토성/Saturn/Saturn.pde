final int sizeX = 1600, sizeY = 900;
final float G = 4*PI*PI;
final float speedPortion = 0.01;
float portion = 60000;
float starSize = 0.00003;
final float dt = 0.000001;
final float oX = sizeX/2, oY = sizeY/2;

final int numOfplanet = 14;
int numOfdust = 0;
float pressedX, pressedY;

int drawCount = 0;

class OBJECTS
{
  float x, y;
  float vx, vy;
  float mass;
  float r;
  
  int R, G, B;
  
  OBJECTS(){
    
  }
  
  OBJECTS(float a, float b, float c){
    x = a;
    y = b;
    r = c;
  }
  
  void addColor(int a, int b, int c){
    R = a;
    G = b;
    B = c;
  }
  
  void initSpeed(float a, float b){
    vx = a;
    vy = b;
  }
  
  void initMass(float a){
    mass = a;
  }
  
  void force(float a, float b){
    vx += a * dt;
    vy += b * dt;
  }
  
  void move(){
    x += vx * dt;
    y += vy * dt;
  }
}

OBJECTS star = new OBJECTS(0,0,starSize);
OBJECTS[] planet = new OBJECTS[100];
OBJECTS[] dust = new OBJECTS[10000];

void setup()
{
  size(sizeX,sizeY);
  background(255,255,255);
  
  star.initMass(0.0002855706385118150000);
  star.addColor(255,0,0);
  print("("+star.x+","+star.y+")");
  
  String[] data = loadStrings("data.txt");
  
  
  for(int i = 0 ; i < numOfplanet; i++)
  {
    float [] v = float(split(data[i],","));
    float a = v[0], e = v[1], m = v[2];
    
    planet[i] = new OBJECTS(a*(1+e),0,starSize/2);
    planet[i].initSpeed(0,sqrt((G*star.mass*(1-e))/(a*(1+e))));
    planet[i].initMass(m);
    print(planet[i].mass);
    planet[i].addColor(0,0,255);
  }
}

void forceBtoA(OBJECTS A, OBJECTS B)
{
  if(A == B) return;
  
  float x = A.x - B.x;
  float y = A.y - B.y;
  float a = G * B.mass / (x*x + y*y);
  float ax = a * (-x / sqrt(x*x + y*y));
  float ay = a * (-y / sqrt(x*x + y*y));
  
  A.force(ax,ay);
}

void drawObjects(OBJECTS A)
{
  stroke(A.R,A.G,A.B);
  fill(A.R,A.G,A.B);
  ellipse(oX + A.x*portion,oY + A.y*portion,A.r*portion,A.r*portion);
}

void drawAll()
{
  for(int i = 0; i < numOfplanet; i++)
  {
    planet[i].move();
    drawObjects(planet[i]);
  }
    
  for(int i = 0; i < numOfdust; i++)
  {
    dust[i].move();
    drawObjects(dust[i]);
  }
  
  star.move();
  drawObjects(star);
}

void draw()
{
  background(255,255,255);
  if(++drawCount == 30)
  {
   numOfdust = 500;
   for(int i = 0; i < numOfdust; i++)
   {
     float r = random(0.00044,0.0011);
     float theta = random(0,2*PI);
     float v = sqrt(G*star.mass/r);
     
     dust[i] = new OBJECTS(r*cos(theta),r*sin(theta),starSize/100);
     dust[i].initSpeed(-v*sin(theta),v*cos(theta));
     dust[i].addColor(220,100,50);
   }
  }
  
  for(int count = 100; count>0; count--)
  {
    for(int i = 0; i < numOfplanet; i++)
    {
      forceBtoA(star,planet[i]);
      forceBtoA(planet[i],star);
      for(int j = 0; j < numOfplanet; j++)
        forceBtoA(planet[i],planet[j]);
    }
    
    for(int i = 0; i < numOfdust; i++)
    {
      forceBtoA(dust[i],star);
      for(int j = 0; j < numOfplanet; j++)
        forceBtoA(dust[i],planet[j]);
    }
    
    drawAll();
  }
  
}

void mouseWheel(MouseEvent event)
{
  float e = -event.getCount();
  if((e > 0 && portion < 1000000) || (e < 0 && portion > 10))
    portion += e * portion / 10;
}
