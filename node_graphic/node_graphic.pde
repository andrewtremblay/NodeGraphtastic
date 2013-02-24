int WIDTH = 500;
int HEIGHT = 500;

DataNode worldNode;

void setup() {
  size(WIDTH, HEIGHT);
  background(0);
  stroke(255);
  worldNode = loadWorldNode();
}

void draw() {
   background(0);
   worldNode.render();
   doDebugInput();
}

  
  ////////////////////////////////////////////////

  void doDebugInput()
  {
    if (keyPressed) {
      
      if (key == 'c') {
        worldNode.shedChildren();
      }
      if (key == 'v') {
        worldNode.absorbChildren();
      }

    }
  }


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
