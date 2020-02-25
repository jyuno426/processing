float[][] a=new float[100][4];
int cnt;
boolean check;
void setup()
{
  size(400,400);
  check=true;
  cnt=0;
}

void draw()
{
  background(255,255,255);
  stroke(0,0,0);
  for(int i=0;i<cnt;i++)line(a[i][0],a[i][1],a[i][2],a[i][3]);
  if(mousePressed)line(a[cnt][0],a[cnt][1],mouseX,mouseY);
}
void keyPressed()
{
  if(keyCode==BACKSPACE)
  {
    check=true;
    cnt--;
  }
}
void mousePressed()
{
  a[cnt][0]=mouseX;
  a[cnt][1]=mouseY;
}
void mouseReleased()
{
  a[cnt][2]=mouseX;
  a[cnt][3]=mouseY;
  cnt++;
}
