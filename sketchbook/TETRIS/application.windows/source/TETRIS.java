import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class TETRIS extends PApplet {

boolean d, l, r, gameover=false, hold_check;
int td=0, tl=0, tr=0, lock_delay=0, clear_delay=0;
int check=0, removed_linecnt=0, cnt=0, combo=0;
int now, x, y, time=0, effect, hold=0;
int tp=0;
final float p=0.4f;
int[][] tet=new int[4][2];
int[][] tile=new int[22][12];
int[][] temp=new int[4][2];
int[][] HOLD_pic=new int[4][2];
boolean[] check_mino=new boolean[8];
PImage[] mino=new PImage[10];
PImage HOLD;
final int s=40, w=10, h=20, move_delay=12, n=5;
final float fps=200;
final int lock_delay_changer=20,drop=75,RLmove=2;
final int[][] I=
{
  { 0, 0, +1, 0, -2, 0, +1, -2, -2, +1}, 
  { 0, 0, -2, 0, +1, 0, -2, -1, +1, +2}, 
  { 0, 0, -1, 0, +2, 0,  1, +2, +2, -1}, 
  { 0, 0, +2, 0, -1, 0, +2, +1, -1, -2}
};
final int[][] noI=
{
  { 0, 0, -1, 0, -1, -1, 0, +2, -1, +2}, 
  { 
    0, 0, -1, 0, -1, +1, 0, -2, -1, -2
  }
  , 
  { 
    0, 0, +1, 0, +1, -1, 0, +2, +1, +2
  }
  , 
  { 
    0, 0, +1, 0, +1, +1, 0, -2, +1, -2
  }
};
public void setup()
{
  frameRate(fps);
  size(PApplet.parseInt(22*s*p), PApplet.parseInt(22*s*p));
  d=false;
  l=false;
  r=false;
  for (int i=0;i<=9;i++) mino[i]=loadImage("mino"+i+".png");
  int i, j;
  for (i=1;i<=7;i++)check_mino[i]=false;
  check_mino[0]=true;
  HOLD=loadImage("hold.png");
  textSize(s);
}
public void appear()
{
  for (int i=0;i<4;i++)
  {
    switch(now)
    {
    case 1:
      tet[0][0]=4;
      tet[0][1]=0;
      tet[1][0]=5;
      tet[1][1]=0;
      tet[2][0]=5;
      tet[2][1]=1;
      tet[3][0]=6;
      tet[3][1]=1;
      break;
    case 2:
      tet[0][0]=5;
      tet[0][1]=0;
      tet[1][0]=6;
      tet[1][1]=0;
      tet[2][0]=5;
      tet[2][1]=1;
      tet[3][0]=4;
      tet[3][1]=1;
      break;
    case 3:
      tet[0][0]=4;
      tet[0][1]=1;
      tet[1][0]=6;
      tet[1][1]=1;
      tet[2][0]=5;
      tet[2][1]=1;
      tet[3][0]=6;
      tet[3][1]=0;
      break;
    case 4:
      tet[0][0]=4;
      tet[0][1]=1;
      tet[1][0]=6;
      tet[1][1]=1;
      tet[2][0]=5;
      tet[2][1]=1;
      tet[3][0]=4;
      tet[3][1]=0;
      break;
    case 5:
      tet[0][0]=4;
      tet[0][1]=1;
      tet[1][0]=6;
      tet[1][1]=1;
      tet[2][0]=5;
      tet[2][1]=1;
      tet[3][0]=5;
      tet[3][1]=0;
      break;
    case 6:
      tet[0][0]=5;
      tet[0][1]=0;
      tet[1][0]=5;
      tet[1][1]=1;
      tet[2][0]=6;
      tet[2][1]=0;
      tet[3][0]=6;
      tet[3][1]=1;
      break;
    case 7:
      tet[0][0]=4;
      tet[0][1]=1;
      tet[1][0]=5;
      tet[1][1]=1;
      tet[2][0]=6;
      tet[2][1]=1;
      tet[3][0]=7;
      tet[3][1]=1;
      break;
    }
  }
}
public void draw_effect()
{
  cnt++;
  fill(0, 0, 255);
  if (effect==4)text("TETRIS!", (12+n)*s, 18*s);
  if (cnt%25==0) {
    cnt=0;
    effect=0;
  }
}
public void draw_now()
{
  for (int i=0;i<4;i++)
  {
    x=tet[i][0];
    y=tet[i][1];
    if (tile[y][x]==0)continue;
    image(mino[now], (x+n)*s, y*s);
  }
}

public boolean crash()
{
  int cnt=0;
  for (int i=0;i<4;i++)
  {
    x=tet[i][0];
    y=tet[i][1];
    if (x>w||x<=0||y<0||y>21||tile[y][x]<8)cnt++;
    if (y==0&&x>=1&&x<=w)cnt--;
  }
  if (cnt>0)return true;
  return false;
}

public void moving(int dir, int v)
{
  for (int i=0;i<4;i++)
  {
    if (dir==1)tet[i][0]+=v;
    else tet[i][1]+=v;
  }
}
public void pic()
{
  for (int i=0;i<4;i++)
  {
    x=tet[i][0];
    y=tet[i][1];
    tile[y][x]=now;
  }
}

public void rotation(boolean clock)
{
  if (now==6)return;
  if (now==7&&clock)
  {
    if (tet[0][0]<tet[1][0])
    {
      tet[0][0]+=2;
      tet[0][1]--;
      tet[1][0]++;
      tet[2][1]++;
      tet[3][0]--;
      tet[3][1]+=2;
      return;
    }
    else if (tet[0][1]<tet[1][1])
    {
      tet[0][0]++;
      tet[0][1]+=2;
      tet[1][1]++;
      tet[2][0]--;
      tet[3][0]-=2;
      tet[3][1]--;
      return;
    }
    else if (tet[0][0]>tet[1][0])
    {
      tet[0][0]-=2;
      tet[0][1]++;
      tet[1][0]--;
      tet[2][1]--;
      tet[3][0]++;
      tet[3][1]-=2;
      return;
    }
    else
    {
      tet[0][0]--;
      tet[0][1]-=2;
      tet[1][1]--;
      tet[2][0]++;
      tet[3][0]+=2;
      tet[3][1]++;
      return;
    }
  }
  else if (now==7&&clock==false)
  {
    if (tet[0][0]<tet[1][0])
    {
      tet[0][0]++;
      tet[0][1]+=2;
      tet[1][1]++;
      tet[2][0]--;
      tet[3][0]-=2;
      tet[3][1]--;
      return;
    }
    else if (tet[0][1]<tet[1][1])
    {
      tet[0][0]-=2;
      tet[0][1]++;
      tet[1][0]--;
      tet[2][1]--;
      tet[3][0]++;
      tet[3][1]-=2;
      return;
    }
    else if (tet[0][0]>tet[1][0])
    {
      tet[0][0]--;
      tet[0][1]-=2;
      tet[1][1]--;
      tet[2][0]++;
      tet[3][0]+=2;
      tet[3][1]++;
      return;
    }
    else
    {
      tet[0][0]+=2;
      tet[0][1]--;
      tet[1][0]++;
      tet[2][1]++;
      tet[3][0]--;
      tet[3][1]+=2;
      return;
    }
  }
  for (int i=0;i<4;i++)
  {
    int a, b;
    x=tet[i][0];
    y=tet[i][1];
    a=tet[2][0];
    b=tet[2][1];
    if (clock) {
      tet[i][0]=a+b-y;
      tet[i][1]=b+x-a;
    }
    else {
      tet[i][0]=a+y-b;
      tet[i][1]=b+a-x;
    }
  }
}
public int ghost()
{
  int i, j;
  int c=0;
  for (i=1;i<=h;i++)
  {
    moving(2, i);
    if (crash())c=1;
    moving(2, -i);
    if (c==1)
    {
      i--;
      if (i==0)return i;
      tint(255, 120);
      for (j=0;j<4;j++)image(mino[now], (tet[j][0]+n)*s, (tet[j][1]+i)*s);
      tint(255, 255);
      break;
    }
  }
  return i;
}

public void back()
{
  smooth();
  scale(p);
  background(240);
  int i, j;
  for (i=0;i<=h+1;i++)for (j=0;j<=w+1;j++)
  {
    if (tile[i][j]>0&&tile[i][j]<8)continue;
    if (i==0||j==0||i==h+1||j==w+1)tile[i][j]=0;
    else if ((i+j)%2==0)tile[i][j]=8;
    else tile[i][j]=9;
  }
  for (i=0;i<=h+1;i++)for (j=0;j<=w+1;j++)
  {
    int asdf;
    if ((i+j)%2==0)asdf=8;
    else asdf=9;
    image(mino[asdf], (j+n)*s, i*s);
    image(mino[tile[i][j]], (j+n)*s, i*s);
  }
  if (removed_linecnt>0)
  {
    effect=removed_linecnt;
    removed_linecnt=0;
  }
  if (effect>0)draw_effect();
  for (i=4;i<=7;i++)if (tile[1][i]<8)gameover=true;
  fill(220);
  float vy=s;
  image(HOLD, s/2, s+vy);
  rect(s/4, 2.5f*s+vy, s*n/1.1f, s*n/1.5f);
  fill(255, 255);
  if(hold>0)
  {
    if(hold==6)for(i=0;i<4;i++)image(mino[hold],HOLD_pic[i][0]*s-s/3,HOLD_pic[i][1]*s+vy);
    else if(hold==7)for(i=0;i<4;i++)image(mino[hold],HOLD_pic[i][0]*s-s/3,HOLD_pic[i][1]*s-s/3+vy);
    else for(i=0;i<4;i++)image(mino[hold],HOLD_pic[i][0]*s,HOLD_pic[i][1]*s+vy);
  }
  for (i=0;i<=w+1;i++)image(mino[0], (i+n)*s, 0);
}
public void line_check1()
{
  int i, j, k;
  for (i=1;i<=h;i++)
  {
    for (j=1;j<=w;j++)if (tile[i][j]>7)break;
    if (j==w+1)removed_linecnt++;
  }
  if (removed_linecnt>0)clear_delay=PApplet.parseInt(fps/30);
}
public void rand_now()
{
  draw_now();
  if (check==1)return;
  int i;
  boolean kk=true;
  for (i=1;i<=7;i++)if (check_mino[i]==false) {
    kk=false;
    break;
  }
  if (kk)for (i=1;i<=7;i++)check_mino[i]=false;
  i=0;
  while (check_mino[i])i=(int)random(1, 8);
  check_mino[i]=true;
  check=1;
  now=i;
  if (tp>0){now=tp;tp=0;}
  appear();
}
public boolean lock()
{
  lock_delay++;
  lock_delay%=lock_delay_changer;
  if (lock_delay==0)
  {
    hold_check=false;
    return true;
  }
  else return false;
}
public void check_key()
{
  boolean qw=false;
  time++;
  time%=drop;
  if (d) {
    td++;
    td%=3;
  }
  else td=0;
  if (time==0)
  {
    moving(2, 1);
    if(crash())
    {
      moving(2, -1);
      if(!d)qw=true;
    }
  }
  if(qw)
  {
    pic();
    check=0;
    qw=false;
    hold_check=false;
  }
  if ((d&&td==0))
  {
    moving(2, 1);
    if (crash())
    {
      moving(2, -1);
      if (lock())
      {
        pic();
        check=0;
      }
    }
  }
  if (l)
  {
    if (tl++%RLmove==0&&(tl>move_delay||tl==1)) {
      moving(1, -1);
      if (crash())moving(1, 1);
    }
  }
  if (r)
  {
    if (tr++%RLmove==0&&(tr>move_delay||tr==1)) {
      moving(1, 1);
      if (crash())moving(1, -1);
    }
  }
}
public void line_check2()
{
  int i, j, k;
  clear_delay--;    
  for (i=1;i<=h;i++)
  {
    for (j=1;j<=w;j++)if (tile[i][j]>7)break;
    if (j==w+1)
    {
      if (clear_delay==1)
      {
        for (k=i;k>1;k--)for (j=1;j<=w;j++)tile[k][j]=tile[k-1][j];
        for (j=1;j<=w;j++)
        {
          if (j%2==0)tile[1][j]=8;
          else tile[1][j]=9;
        }
      }
      else
      {
        for (j=1;j<=w;j++)
        {
          if ((j+i)%2==0)k=8;
          else k=9;
          image(mino[k], (j+n)*s, i*s);
        }
      }
    }
  }
}
public void draw()
{
  if (gameover)
  {
    smooth();
    scale(p);
    for (int i=0;i<=w+1;i++)image(mino[0], (i+n)*s, 0);
    fill(255, 0, 0);
    textSize(2.2f*s);
    text("Game Over", (n)*s, 5*s);
    return;
  }
  if (clear_delay>0)line_check2();
  else
  {
    back();
    line_check1();
    rand_now();
    if (clear_delay==0)
    {
      check_key();
      ghost();
    }
  }
}
public void wallkick(boolean r)
{
  if (now==6)return;
  int i=0, j, vx=0, vy=0;
  for (i=1;i<=5;i++)
  {
    if (now<=5)
    {
      if (r)
      {
        if (tet[0][0]<tet[1][0]) {
          vx=noI[0][2*i-2];
          vy=noI[0][2*i-1];
        }
        else if (tet[0][1]<tet[1][1]) {
          vx=noI[1][2*i-2];
          vy=noI[1][2*i-1];
        }
        else if (tet[0][0]>tet[1][0]) {
          vx=noI[2][2*i-2];
          vy=noI[2][2*i-1];
        }
        else {
          vx=noI[3][2*i-2];
          vy=noI[3][2*i-1];
        }
      }
      else
      {
        if (tet[0][0]>tet[1][0]) {
          vx=noI[0][2*i-2];
          vy=noI[0][2*i-1];
        }
        else if (tet[0][1]<tet[1][1]) {
          vx=noI[1][2*i-2];
          vy=noI[1][2*i-1];
        }
        else if (tet[0][0]<tet[1][0]) {
          vx=noI[2][2*i-2];
          vy=noI[2][2*i-1];
        }
        else {
          vx=noI[3][2*i-2];
          vy=noI[3][2*i-1];
        }
      }
    }
    else
    {
      if (r)
      {
        if (tet[0][0]<tet[1][0]) {
          vx=noI[0][2*i-2];
          vy=I[0][2*i-1];
        }
        else if (tet[0][1]<tet[1][1]) {
          vx=noI[1][2*i-2];
          vy=I[1][2*i-1];
        }
        else if (tet[0][0]>tet[1][0]) {
          vx=noI[2][2*i-2];
          vy=I[2][2*i-1];
        }
        else {
          vx=noI[3][2*i-2];
          vy=noI[3][2*i-1];
        }
      }
      else
      {
        if (tet[0][0]>tet[1][0]) {
          vx=noI[0][2*i-2];
          vy=I[0][2*i-1];
        }
        else if (tet[0][1]<tet[1][1]) {
          vx=noI[1][2*i-2];
          vy=I[1][2*i-1];
        }
        else if (tet[0][0]<tet[1][0]) {
          vx=noI[2][2*i-2];
          vy=I[2][2*i-1];
        }
        else {
          vx=noI[3][2*i-2];
          vy=I[3][2*i-1];
        }
      }
    }
    moving(1, vx);
    moving(2, -vy);
    if (crash())
    {
      moving(1, -vx);
      moving(2, vy);
    }
    else break;
  }
  if (i==6)
  {
    for (i=0;i<4;i++)
    {
      tet[i][0]=temp[i][0];
      tet[i][1]=temp[i][1];
    }
  }
}
public void keyPressed()
{
  if (keyCode==UP||keyCode==CONTROL||(key=='z'||key=='Z'))
  {
    for (int i=0;i<4;i++)
    {
      temp[i][0]=tet[i][0];
      temp[i][1]=tet[i][1];
    }
    if (keyCode==UP) {
      rotation(true);
      wallkick(true);
    }
    else {
      rotation(false);
      wallkick(false);
    }
  }
  if (keyCode==DOWN)d=true;
  if (keyCode==LEFT)
  {
    l=true;
    if (r==true) {
      r=false;
      tr=0;
    }
  }
  if (keyCode==RIGHT)
  {
    r=true;
    if (l==true) {
      l=false;
      tl=0;
    }
  }
  if (key==32)
  {
    if (clear_delay<=1) {

      int k=ghost();
      moving(2, k);
      pic();
      check=0;
      hold_check=false;  
    }
  }
  if (keyCode==SHIFT)
  {
    if (hold_check)return;
    if (hold==0)
    {
      hold=now;
      check=0;
    }
    else
    {
      tp=hold;
      hold=now;
      check=0;
    }
    hold_check=true;
    appear();
    for(int i=0;i<4;i++)
    {
      HOLD_pic[i][0]=tet[i][0]-n+2;
      HOLD_pic[i][1]=tet[i][1]+3;
    }
  }
}
public void keyReleased()
{
  if (keyCode==DOWN)d=false;
  if (keyCode==LEFT) {
    l=false;
    tl=0;
  }
  if (keyCode==RIGHT) {
    r=false;
    tr=0;
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "TETRIS" });
  }
}
