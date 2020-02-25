int x,y,w,h,n=8,S=64,check_cnt;
PImage[] p=new PImage[4];
int[][] g={
  {2,1},
  {3,1},
  {1,4},
  {3,6},
  {6,6},
};
PImage dora,goal;
int[][] map={
  {1,1,1,1,1,1,1,1},
  {1,0,0,0,1,1,1,1},
  {1,0,2,2,0,1,1,1},
  {1,1,0,1,0,0,0,1},
  {1,0,0,0,1,2,0,1},
  {1,0,0,0,2,0,0,1},
  {1,0,2,0,1,0,0,1},
  {1,1,1,1,1,1,1,1}
};
void setup()
{
  size(10*S,10*S);
  p[0]=loadImage("tile.png");
  p[1]=loadImage("wall.png");
  p[2]=loadImage("box.png");
  goal=loadImage("goal.png");
  dora=loadImage("doraemong.png");
  w=S*(10-n)/2;
  h=S*(10-n)/2;
  x=5;
  y=6;
  int i,j;
  for(i=0;i<n;i++)for(j=0;j<n;j++)if(map[i][j]==2)check_cnt++;
}
void draw()
{
  int cnt=0;
  int i,j;
  background(0,0,0);
  for(i=0;i<n;i++)for(j=0;j<n;j++)image(p[map[i][j]],w+j*S,h+i*S);
  for(i=0;i<check_cnt;i++)
  {
    if(map[g[i][1]][g[i][0]]==2)cnt++;
    else image(goal,w+g[i][0]*S,h+g[i][1]*S);
  }
  image(dora,w+S*x,h+S*y);
  if(check_cnt==cnt)
  {
    stroke(255,255,255);
    textSize(100);
    text("You Win!!",100,300);
  }
}
void keyPressed()
{
  int cx=0,cy=0,tile,a,b;
  if(keyCode==UP)cy=-1;
  else if(keyCode==DOWN)cy=1; 
  else if(keyCode==LEFT)cx=-1;
  else if(keyCode==RIGHT)cx=1;  
  else return;
  a=y+cy;
  b=x+cx;
  if(map[a][b]==1)return;
  else if(map[a][b]==0){x+=cx;y+=cy;}
  else if(map[a][b]==2)
  {
    if(map[a+cy][b+cx]==1||map[a+cy][b+cx]==2)return;
    map[a][b]=0;
    map[a+cy][b+cx]=2;
    x+=cx;
    y+=cy;
  }
}
