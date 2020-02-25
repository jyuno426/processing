int x,y,cnt1,cnt2,cnt3,check=0,time;
int[][] a=new int[1000][2];
float[][] b=new float[100][3];
boolean u,d,l,r,z;
void setup()
{
  size(800,800);
  x=400;
  y=400;
  cnt1=0;
  cnt2=0;
  cnt3=0;
  time=0;
}
void draw()
{
  if(check==1)
  {
    textSize(70);
    text("Game Over!",200,300);
    return;
  }
  if(x<5)x=5;
  if(x>790)x=790;
  if(y<5)y=5;
  if(y>786)y=786;
  background(0,0,0);
  stroke(255,255,255);
  text("x : "+x,10,20);
  text("y : "+y,10,40);
  text("kills : "+cnt3,10,60);
  stroke(255,0,0);
  fill(255,255,255);
  triangle(x,y,x,y+7,x-5,y+14);
  triangle(x,y,x,y+7,x+5,y+14);  
  fill(255,0,0);
  if(u)y-=5;
  if(d)y+=5;
  if(l)x-=5;
  if(r)x+=5;
  if(z&&time%10==0)
  {
    a[cnt1][0]=x;
    a[cnt1][1]=y;
    cnt1++;
  }
 int i,j;
 if(a[0][1]<0)
 {
   for(i=0;i<cnt1;a[i][0]=a[i+1][0],a[i][1]=a[i+1][1],i++);
   cnt1--;
 }
 
 fill(255,255,255);
 for(i=0;i<cnt1;i++)
 {
   a[i][1]-=11;
   rect(a[i][0],a[i][1]-2,2,2);
 }
 time++;
 time%=250;
 if(time==0)
 {
   b[cnt2][0]=(int)random(100,500);
   b[cnt2][1]=0;
   b[cnt2++][2]=(int)random(10,20);
   b[cnt2][0]=(int)random(100,500);
   b[cnt2][1]=0;
   b[cnt2++][2]=(int)random(5,15);   
 }
 if(b[0][1]>790)
 {
   for(i=0;i<cnt2;b[i][0]=b[i+1][0],b[i][1]=b[i+1][1],b[i][2]=b[i+1][2],i++);
   cnt2--;
 }
 for(i=0;i<cnt2;i++)
 {
   b[i][1]+=0.2;
   if(b[i][2]>=8)rect(b[i][0]-20,b[i][1],40,5);
   else rect(b[i][0]-10,b[i][1],20,5);
 }
 for(i=0;i<cnt1;i++)for(j=0;j<cnt2;j++)
 {
   if(b[j][2]>=8&&a[i][0]>b[j][0]-20&&a[i][0]<b[j][0]+20&&a[i][1]<b[j][1]+15)
   {
     b[j][2]--;
     a[i][0]=-1;
     a[i][1]=-1;
   }
   if(b[j][2]<8&&a[i][0]>b[j][0]-10&&a[i][0]<b[j][0]+10&&a[i][1]<b[j][1]+15)
   {
     b[j][2]--;
     a[i][0]=-1;
     a[i][1]=-1;
   }   
 }
  for(i=0;i<cnt2;i++)
  {
    if(b[i][1]-5<=y&&y<=b[i][1]+5)
    {
      if(b[i][2]>=10&&b[i][0]-20<x&&x<b[i][0]+20)check=1;
      else if(b[i][2]<8&&b[i][0]-10<x&&x<b[i][0]+10)check=1;
    }
    if(b[i][2]<=0)
    {
      cnt3++;
      cnt2--;
      for(j=i;j<cnt2;j++)
      {
        b[j][0]=b[j+1][0];
        b[j][1]=b[j+1][1];
        b[j][2]=b[j+1][2];
      }
      i--;
     }
  }
}
void keyPressed()
{
   if(keyCode==UP)u=true;
   else if(keyCode==DOWN)d=true;
   else if(keyCode==LEFT)l=true;
   else if(keyCode==RIGHT)r=true;
   else if(key=='z'||key=='Z')z=true;
   else return;
}
void keyReleased()
{
   if(keyCode==UP)u=false;
   else if(keyCode==DOWN)d=false;
   else if(keyCode==LEFT)l=false;
   else if(keyCode==RIGHT)r=false;
   else if(key=='z'||key=='Z')z=false;
   else return;  
}
