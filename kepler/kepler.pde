final int sizeX = 1600, sizeY = 900;
final float G = 4*PI*PI;
final float speedPortion = 0.01;
float portion = 30;
float starSize = 0.3;
final float dt = 0.001;
final float oX = sizeX/2, oY = sizeY/2;

final int numOfplanet = 9;
int numOfrocket = 0;
float pressedX, pressedY;

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
OBJECTS[] planet = new OBJECTS[numOfplanet];
OBJECTS[] rocket = new OBJECTS[100];

void setup()
{
  size(sizeX,sizeY);
  background(255,255,255);
  
  star.initMass(1);
  star.addColor(255,0,0);
  
  String[] data = loadStrings("data.txt");
  
  
  for(int i = 0 ; i < numOfplanet; i++)
  {
    float [] v = float(split(data[i],","));
    float a = v[0], e = v[1], m = v[2];
    
    planet[i] = new OBJECTS(a*(1+e),0,starSize/2);
    planet[i].initSpeed(0,sqrt((G*(1-e))/(a*(1+e))));
    planet[i].initMass(m);
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
  A.move();
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
    drawObjects(planet[i]);
    
  for(int i = 0; i < numOfrocket; i++)
    drawObjects(rocket[i]);
 
  drawObjects(star);
}

void draw()
{
  background(255,255,255);
  
  for(int i = 0; i < numOfplanet; i++)
  {
    forceBtoA(planet[i],star);
  }
  
  for(int i = 0; i < numOfrocket; i++)
  {
    forceBtoA(rocket[i],star);
    for(int j = 0; j < numOfplanet; j++)
      forceBtoA(rocket[i],planet[j]);
  }
  
  drawAll();
  
  
  if(mousePressed && mouseButton == LEFT)
  { 
    stroke(0,0,0);
    line(pressedX,pressedY,mouseX,mouseY);
  }
  
}

void mousePressed()
{
  pressedX = mouseX;
  pressedY = mouseY;
}

void mouseReleased()
{
  if(mouseButton == LEFT)
  {
    if(numOfrocket == 100) numOfrocket = 0;
    rocket[numOfrocket] = new OBJECTS((pressedX-oX)/portion,(pressedY-oY)/portion,starSize/3);
    rocket[numOfrocket].addColor(120,120,0);
    rocket[numOfrocket].initSpeed((pressedX-mouseX)*speedPortion, (pressedY-mouseY)*speedPortion);
    numOfrocket++;
  }
}

void mouseWheel(MouseEvent event)
{
  float e = -event.getCount();
  if((e > 0 && portion < 1000) || (e < 0 && portion > 10))
    portion += e * portion / 10;
}
