int WIDTH = 500;
int HEIGHT = 500;
int mouseState = 0;
boolean interactLocked = false;

DataNode worldNode;

void setup() {
  size(WIDTH, HEIGHT);
  background(0);
  stroke(255);
  worldNode = loadWorldNode();
  
  debugSetupStuff();
}

void draw() {
   background(0);
   worldNode.render();
   worldNode.doMouseInput(mouseX, mouseY, mouseState);
   
   debugDrawStuff();
}


//mouse interaction 
void mousePressed() {  
  mouseState = 1;
}

void mouseDragged() {
  if((mouseX <= 0 || mouseY <= 0) || (mouseX >= WIDTH || mouseY >= HEIGHT)){
      mouseState = 0;      //out of bounds, reset state
      interactLocked = false;
  }
}

void mouseReleased() {
  mouseState = 0;
  interactLocked = false;
}

  
//basic world loading
DataNode loadWorldNode()
{
  DataNode world = new DataNode();
  
  DataNode firstChild = new DataNode(world, WIDTH/4, HEIGHT/4, 75);
  DataNode secondChild = new DataNode(world, WIDTH*3/4, HEIGHT*3/4, 75); 
  DataNode thirdChild = new DataNode(world, WIDTH*3/4, HEIGHT/4, 75); 
  DataNode fourthChild = new DataNode(world, WIDTH/4, HEIGHT*3/4, 75); 
  DataNode fourthFirstChild = new DataNode(fourthChild, WIDTH/8, HEIGHT*3/8, 45); 
  fourthChild.children = new DataNode[1];
  fourthChild.children[0] = fourthFirstChild;

  world.children = new DataNode[4];
  world.children[0] = firstChild;
  world.children[1] = secondChild;
  world.children[2] = thirdChild;
  world.children[3] = fourthChild;
   
  //Other setup vars here, from separate data
  return world;
}
