import processing.sound.*;


boolean hit(float x, float y, float x1, float y1, float x2, float y2) {
//tests if the bullet line intersects with zombie
//its all witchcraft
  float A = x - x1;
  float B = y - y1;
  float C = x2 - x1;
  float D = y2 - y1;
  boolean ret;
  float dot = A * C + B * D;
  float len_sq = C * C + D * D;
  float param = -1;
  if (len_sq != 0) //in case of 0 length line
    param = dot / len_sq;

  float xx, yy;

  if (param < 0) {//if the zombie is begind player measure from player
    xx = x1;
    yy = y1;
  } else if (param > 1) {//if zombie is past bullet distance then measure from where it lands
    xx = x2;
    yy = y2;
  } else {//otherwise measure distance from closest point on line
    xx = x1 + param * C;
    yy = y1 + param * D;
  }

  ret=dist(x, y, xx, yy)<13;//test if line is close enough to zombie to hit
  return ret;//returns boolean if it hit the zombie
}
void zombie(){//auto places a zombie with 100 health at a random wall at a random point on that wall
  float[] xyh=new float[4];{//used to get x,y,health,speed of zombies
    xyh[2]=100;//health at 100%
    xyh[3]=0;
  }
  boolean one=random(1)<.5;//gets random bool
  boolean two=random(1)<.5;//random bool 2
  if(one&&two){//25% chance of spawning at top
    xyh[0]=random(0,400);
    xyh[1]=-20;
  }
  if(!one&&two){//spawn at bottom
    xyh[0]=random(0,width);
    xyh[1]=height+20;
  }
  if(!one&&!two){//spawn at right
    xyh[0]=width+20;
    xyh[1]=random(0,height);
  }
  if(one&&!two){//spawn at left
    xyh[0]=-20;
    xyh[1]=random(0,height);
  }
  zombies.add(xyh);//put the new zombie values into arrayList
} 
void mine(float x,float y,ArrayList<float[]>mines){
  float[] xyt=new float[3];
  xyt[0]=x;
  xyt[1]=y;
  xyt[2]=108;
  mines.add(xyt);
}
void rocket(float x, float y, float angle, ArrayList<float[]> rockets){
  float[] xya={x,y,angle,30};
  rockets.add(xya);
}
ArrayList <float[]> boom(float x,float y,ArrayList<float[]>zombies){
  explotion.play();
  fill(255,255,0);
  ellipse(x,y,100,100);
  float[] xyh=new float[4];
  int zombieSize=zombies.size();
  float damage;
  float angle;
  for(int i=0;i<zombieSize;i++){
    xyh=zombies.get(i);
    damage=150-dist(x,y,xyh[0],xyh[1]);
    if(damage<0)damage=0;
    angle=atan2(xyh[1]-y,xyh[0]-x);
    
    xyh[0]+=cos(angle)*damage/10;
    xyh[1]+=sin(angle)*damage/10;
    xyh[2]-=damage;
    //xyh[3]-=damage/20;
    if(xyh[2]<0)xyt[2]=0;
    zombies.set(i,xyh);
    if(xyh[2]<=0){
        zombies.remove(i);
        i--;
        zombieSize--;
        points++;
        money+=2;
        zombie();
        if (points>highScore){
          highScore=points;
        }  
        
    }//if zombie is out of health it dies
    
  }
  return zombies;
}
void zombie(float x, float y, int health){//un used overload to manually place zombie at an x and y with health
  float[] xyh=new float[4];
  xyh[0]=x;
  xyh[1]=y;
  xyh[2]=health;
  xyh[3]=0;
  zombies.add(xyh);
}
boolean button(int x1,int y1,int x2,int y2, int mouseX, int mouseY){
  boolean returns=(((x1<mouseX&&mouseX<x2)||(x2<mouseX&&mouseX<x2))&&((y1<mouseX&&mouseX<y2)||(y1<mouseY&&mouseY<y2)));
  return returns;
}
ArrayList<float[]> bullet(float x, float y, float angle,float damage, ArrayList<float[]>zombies) {//everything that is run when firing
  
  float range=dist(0, 0, width, height);//shoot just far enough to go from corner to opostie corner
  float x2=x+range*cos(angle);//end point of bullet, where it lands
  float y2=y+range*sin(angle);
  float gunEndX=x+cos(angle)*30;//playerX+cos(gunAngle)*30,playerY+sin(gunAngle)*30
  float gunEndY=y+sin(angle)*30;
  line(x+cos(angle)*30, y+sin(angle)*30, x2, y2);//draw the bullet
  strokeWeight(6);
  stroke(255,255,0);
  float rangle=random(-PI/8,PI/8);//draw muzzle flash
  line(gunEndX,gunEndY,gunEndX+cos(angle+rangle)*20,gunEndY+sin(angle+rangle)*20);
  rangle=random(-PI/8,PI/8);
  line(gunEndX,gunEndY,gunEndX+cos(angle+rangle)*20,gunEndY+sin(angle+rangle)*20);
  rangle=random(-PI/8,PI/8);
  line(gunEndX,gunEndY,gunEndX+cos(angle+rangle)*20,gunEndY+sin(angle+rangle)*20);
  strokeWeight(3);
  stroke(0);
  for (int i=0; i<zombies.size(); i++) {//run through each zombie and test if hit etc
    xyh=zombies.get(i);//put array list at i in the array
    if(hit(xyh[0],xyh[1],x,y,x2,y2)){//text if the zombie was hit by the bullet
      xyh[2]-=damage;//zombie takes damage
      xyh[3]=-3;//zombie get knocked back
      if(xyh[2]<=0){
        zombies.remove(i);
        i--;
        points++;
        money+=2;
        zombie();
        if (points>highScore){
          highScore=points;
        }  
        
      }//if zombie is out of health it dies
    }
  }
  return zombies;
};
void drawLegs (float x, float y, float angle ,float frame){
   float x1=cos(angle+PI/2)*7+x;
   float y1=sin(angle+PI/2)*7+y;
   float x2=cos(angle-PI/2)*7+x;
   float y2=sin(angle-PI/2)*7+y;
   float x3=x1+cos (angle)*sin (frame/10)*15;
   float y3=y1+sin(angle)*sin (frame/10)*15;
   float x4=x2+cos (angle)*sin (-frame/10)*15;
   float y4=y2+sin(angle)*sin (-frame/10)*15;
   line(x1,y1,x3,y3);
   line(x2,y2,x4,y4);
}
void mouseWheel(MouseEvent event){
  textTimer=30;
  gs-=event.getCount();
  if(gs<0)gs+=6;
  if(gs>5)gs-=6;
  while(guns[gs][0]==0||gs<0||gs>6){
  
    if(event.getCount()>0){
      gs--;
    }else if(event.getCount()<0){
      gs++;
    }
  
    if(gs<0)gs+=6;
    if(gs>6)gs-=6;
  }
}
void keyPressed() {//sets bool to true if the key is pressed
  if (key=='w') keys[0]=true;
  if (key=='a') keys[1]=true;
  if (key=='s') keys[2]=true;
  if (key=='d') keys[3]=true;
  if(key==' '&&playerMines>0){//spawn a mine when you press space
    mine(playerX,playerY,mines);
    playerMines--;
  }
}
void keyReleased() {//if a key is released then set its bool to false
  if (key=='w') keys[0]=false;
  if (key=='a') keys[1]=false;
  if (key=='s') keys[2]=false;
  if (key=='d') keys[3]=false;
}
void mousePressed(){
  if(menu){
    if(gs==4){
      stop();
    }
    menu=!button(10,220,70,250,mouseX,mouseY);
    for(int i=0;i<guns.length;i++){
      if (button(250,i*60+20,380,i*60+70,mouseX,mouseY)&&money>=guns[i][7]&&guns[i][0]==0){
        
         guns[i][0]=1;
        money-=guns[i][7]; 
        gs=i;
      }
    }
  }
}
boolean menu=false;
boolean[] keys=new boolean[4];//used to hold key inputs
int playerHealth=100;//start health of player
int playerSpeed=2;//player speed multiplier
int lives=0;//player lives
int points=0;
int highScore=0;
int money=0;
int frames=0;
int fireRate=15;
int fireRateTimer=0;
int playerMines=5;
int rocketCount;
int textTimer=0;

String[] wNames={"Glock 19","M1 Garand","Spaz 12","AK 47","Minigun","Grenade launcher"};
float[][] guns={//[weapon][attribute]
{1,20,0,1,0,10,3,0,33},//0-glock
{1,30,0,1,0,25,3,200,100},//1-M1 Garand
{1,25,PI/30,5,0,20,5,500,33},//2-Shotgun
{1,5,PI/90,1,0,25,4,1200,49},//3-AK 47
{1,1,PI/30,2,0,30,10,3000,5},//4-MiniGun
{1,15,0,1,1,20,10,5000,0}};//5-Rocket Launcher
//attributes:0-if owned 1-frames per shot 2-spread 3-shots 4-if rocket 5-length 6-thinckness 7-cost 8-damage
int gs=0; //gun selection. current held gun.
float[] xyt=new float[3];//mines read write
float[] xya=new float[4];//rockets read write
ArrayList<float[]> rockets=new ArrayList<float[]>();
ArrayList<float[]> mines=new ArrayList<float[]>();//mines in world
ArrayList<float[]> zombies=new ArrayList<float[]>();//holds the zombies, array holds x,y,health
float[] xyh=new float[4];//used to take and add arrays to zombie arraylist
int spawnrate=200;// amount of frames between each zombie spawn
float zA;//used to make zombie walk toward player
float gunAngle;
float inacuracy;
PImage background;
PImage glock;
PImage m1g;
PImage shotgun;
PImage ak_47;
PImage minigun;
PImage rocket;
SoundFile[] wSound;
SoundFile explotion;
void setup() {
  size(400, 400);//screen size, everything should be scalable with height and width
  frameRate(40);
  textSize(15);
  for(int i=0;i<15;i++){
    zombie();
  }
  strokeWeight(3);
  background = loadImage("back.jpg");//load images
  glock=loadImage("glock.png");
  m1g=loadImage("m1_garand.png");
  shotgun=loadImage("shotgun.png");
  ak_47=loadImage("ak_47.png");
  minigun=loadImage("minigun.png");
  rocket=loadImage("grenade_launcher.png");
  explotion=new SoundFile(this, "explotion.wav");
  wSound[0]=new SoundFile(this, "pistol.wav");
  wSound[1]=new SoundFile(this, "rifle.wav");
  wSound[2]=new SoundFile(this, "shotgun.wav");
  wSound[3]=new SoundFile(this, "ak47.wav");
  wSound[4]=new SoundFile(this, "minigun.wav");
  wSound[5]=new SoundFile(this, "grenade-launcher.wav");
  
}
float playerX=200;
float playerY=200;//put player x and y in middle of screen

void draw() {
  
  if(menu){
    background(66,66,66);//draw a back
    fill(255);
    text ("$"+money,20,40);
    
    image(glock,250-90,20);
    image(m1g,100,90);
    image(shotgun,250-174,140);
    image(ak_47,250-166,200);
    image(minigun,250-152,260);
    image(rocket,250-166,320);
    
    fill(70,0,255);
    //draw a dude
    ellipse(50,320,120,120);
    fill(255);
    ellipse(20,320,30,30);
    ellipse(80,320,30,30);
    fill(0);
    ellipse(16,315,10,10);
    ellipse(76,315,10,10);
    line(45,360,70,350);
    line(50,380,50,400);
    
    fill(255);
    rect(10,220,60,30,10);
    fill(0);
    text("Ready?",17,239);
    for(int i=0; i<guns.length;i++){
      fill(50,50,155);
      rect(250,i*60+20,130,50,10);
      fill(255);
      text(wNames[i],275,i*60+40);
      text("cost $"+guns[i][7],275,i*60+60);
      if(guns[i][0]==1){
        fill(0,150);
        rect(250,i*60+20,130,50,10);
        fill(50,50,155);
      }
      
    }
    
    
    
  }else{
    image(background,0,0,width/2,height/2);
    image(background,width/2,0,width/2,height/2);
    image(background,0,height/2,width/2,height/2);
    image(background,width/2,height/2,width/2,height/2);
    if (keys[0]) playerY-=playerSpeed;
    if (keys[1]) playerX-=playerSpeed;
    if (keys[2]) playerY+=playerSpeed;
    if (keys[3]) playerX+=playerSpeed;//make controls take affect
    if (mousePressed){
      
      if(fireRateTimer<=0){
         for(int i=0;i<guns[gs][3];i++){//run for amount of bullets per shot
            inacuracy=random(-guns[gs][2],guns[gs][2]);//find inaccuracy of current shot
            gunAngle=atan2(mouseY-playerY,mouseX-playerX)+inacuracy;//find angle of shot
            if(guns[gs][4]==0){//if its not a rocket
              zombies=bullet(playerX, playerY, gunAngle,guns[gs][8], zombies);//shoot and test if it hits etc
            }else{//if it is a rocket
             rocket(playerX, playerY, gunAngle,rockets);
            }
         }
         if(gs==5){
           //wSound[gs].loop();
         }else{
           //wSound[gs].play();
         }
         fireRateTimer=int(guns[gs][1]);
      }
    }
    for(int i=0;i<mines.size();i++){
      xyt=mines.get(i);
      fill(0);
      ellipse(xyt[0],xyt[1],20,20);
      if(xyt[2]%18<9){
        fill(255,0,0);
        ellipse(xyt[0],xyt[1],5,5);
      }
      xyt[2]--;
      if(xyt[2]<0){
        zombies=boom(xyt[0],xyt[1],zombies);
        mines.remove(i);
      }
    }
    rocketCount=rockets.size();
    
    for(int i=0; i<rocketCount;i++){
      xya=rockets.get(i);
      fill(0);
      ellipse(xya[0],xya[1],5,5);
      for(int j=0;j<zombies.size();j++){
        xyh=zombies.get(j);
        if(dist(xya[0],xya[1],xyh[0],xyh[1])<15||xya[3]<0){
          zombies=boom(xya[0],xya[1],zombies);
          rockets.remove(i);
          rocketCount--;
          break;
        }
      }
      xya[0]+=cos(xya[2])*10;
      xya[1]+=sin(xya[2])*10;
      xya[3]--;
      
    }
    for (int i=0; i<zombies.size();i++){//run for every zombie
      float[] xyh=zombies.get(i);//acces the array list at i
      zA=atan2(playerY-xyh[1],playerX-xyh[0]);//find the angle between guy and zombie
      fill(500-xyh[2]*4,xyh[2]*4 ,0);//color zombie by health, green full, red dead
      drawLegs(xyh[0],xyh[1],zA,frames);
      ellipse(xyh[0],xyh[1],25,25);//draw zombie
      
      //draw zombie arms
      line(xyh[0]+cos(zA+PI/4)*13,xyh[1]+sin(zA+PI/4)*13,xyh[0]+cos(zA+PI/8)*25,xyh[1]+sin(zA+PI/8)*25);
      line(xyh[0]+cos(zA-PI/4)*13,xyh[1]+sin(zA-PI/4)*13,xyh[0]+cos(zA-PI/8)*25,xyh[1]+sin(zA-PI/8)*25);
      
      xyh[0]+=cos(zA)*xyh[3];
      xyh[1]+=sin(zA)*xyh[3];//move toward player by angle
      if(xyh[3]<1)xyh[3]+=.2;
      if(dist(xyh[0],xyh[1],playerX,playerY)<25)playerHealth--;//if you get to close the any zombie loose health
    }
    fill(500-playerHealth*5, 0, playerHealth*5);//player health shown by blue to red
    ellipse(playerX, playerY, 25, 25);//draw player
    gunAngle=atan2(mouseY-playerY,mouseX-playerX);
    strokeWeight(guns[gs][6]);
    line(playerX+cos(gunAngle)*15,playerY+sin(gunAngle)*15,playerX+cos(gunAngle)*(15+guns[gs][5]),playerY+sin(gunAngle)*(15+guns[gs][5]));
    strokeWeight(3);
    fill(0, 0, 255);//lives draw blue
    for (int i=0; i<lives; i++) {
      ellipse(i*15+15, 40, 10, 10);//draw lives circles
    }
    fill(0);
    for (int i=0; i<playerMines; i++) {
      stroke(0);
      ellipse(i*15+15, 55, 10, 10);//draw mines circles
      stroke(255,0,0);
      point(i*15+15,55);
    }
    stroke(0);
    fill(255);
    text("Points: "+points,8,15);
    text("High Score: "+highScore,7,35);
    fireRateTimer--;
    frames++;
    spawnrate=140000/(frames+600)+50;
    if(frames%spawnrate==0){
      zombie();
    }
    if(textTimer>0){
      fill(255);
      textTimer--;
      text("Weapon selected: "+wNames[gs],100,100);
    }
      
    if (playerHealth<=0) {//death code
      lives--;//one less life
      playerHealth=100;//reset player
      playerX=width/2;
      playerY=height/2;//put the player in the center of the screen
      background(255, 0, 0);
    }
    if(lives<0) {//game over code
      delay(1000);//wait a second to make you realize you is kill and you loose
      points=0;//reset points, frames and lives
      frames=0;
      lives=0;
      int minenum=mines.size();//get the length of the zombie arraylist
      for(int i=minenum; i>0;i--){//remove all zombies
        mines.remove(0);
      }
      
      int zombienum=zombies.size();//get the length of the zombie arraylist
      for(int i=zombienum-1; i>0;i--){//remove all zombies
        zombies.remove(i);
      }
      zombies.remove(0);
      for(int i=0;i<15;i++){
        zombie();//spawn a new zombie to start the game again
      }
      menu=true;
    }
  }
}