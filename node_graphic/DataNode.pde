class DataNode
{
  float expandedXpos, expandedYpos, expandedRadius;
  float collapsedXpos, collapsedYpos, collapsedRadius;
  float currentXpos, currentYpos, currentRadius;
  float destXpos, destYpos, destRadius;

  float decay = 5;
  float minDecay = decay;
  float maxDecay = 25; //too big and things get weird
  float deltaDecay = 5;
  
  boolean collapsed = true;
  DataNode[] children;
  DataNode parent;
  
  //default (base) node
  DataNode()  
  {
    this(WIDTH/2, HEIGHT/2, 200, 
         WIDTH/2, HEIGHT/2, 250, 
         true, false);
  }
  
  //child nodes
  DataNode(DataNode _parent, float expandX, float expandY, float expandRad) 
  {
    this(_parent.collapsedXpos, _parent.collapsedYpos, _parent.collapsedRadius, 
         expandX, expandY, expandRad, 
         true, true);  //we're a child. start fully collapsed
    parent = _parent;   //constructor must be the first declaration  
  }

  //wordy constructor
  DataNode(float collX, float collY, float collRad, 
           float expX, float expY, float expRad, 
           boolean startCollapsed, boolean destCollapsed) 
  {
     collapsedXpos = collX;
     collapsedYpos = collY;
     collapsedRadius = collRad;
     expandedXpos = expX;
     expandedYpos = expY;
     expandedRadius = expRad;
     
     if(startCollapsed) {
        setCurrent(collapsedXpos, collapsedYpos, collapsedRadius);  
      } else {
        setCurrent(expandedXpos, expandedYpos, expandedRadius);
      }
      
     if(destCollapsed) {
        setDest(collapsedXpos, collapsedYpos, collapsedRadius);
      } else {
        setDest(expandedXpos, expandedYpos, expandedRadius);
      }
  }

  //see

  void render(){
        currentXpos = currentXpos + (destXpos - currentXpos)/decay;
        currentYpos = currentYpos + (destYpos - currentYpos)/decay;
        currentRadius = currentRadius + (destRadius - currentRadius)/decay;
        decay = decay < maxDecay ? decay + deltaDecay : maxDecay;
      renderChildren();
      ellipse(currentXpos, currentYpos, currentRadius, currentRadius);
        //updateCurrentVars();

       doDebugInput();
  }
  
  //change
  void setCurrent(float currX, float currY, float currRad)
  {
    currentXpos = currX;
    currentYpos =  currY;
    currentRadius = currRad;
  }
  
  void setDest(float destX, float destY, float destRad)
  {
    destXpos = destX;
    destYpos =  destY;
    destRadius = destRad;
  }


  //base level
  void collapseNode()
  {
    collapsed = true;
        setDest(collapsedXpos, collapsedYpos, collapsedRadius);
    decay = minDecay;
  }

  void expandNode()
  { 
    collapsed = false;
        setDest(expandedXpos, expandedYpos, expandedRadius);
    decay = minDecay;
  }  
  
  //Child management 
  void renderChildren()
  {
    if(children != null){
       for(int i = 0; i < children.length; i++)
       {
        children[i].render();
       } 
     }
  }
  
  void absorbChildren()
  {
      expandNode();
     if(children != null){
       for(int i = 0; i < children.length; i++)
       {
         children[i].collapseNode();
       }
     }
   }

  void shedChildren()
  {
     collapseNode();
     if(children != null){
       for(int i = 0; i < children.length; i++)
       {
         children[i].expandNode();
       }
     }
  }


  
  
  
  
  ////////////////////////////////////////////////

  void doDebugInput()
  {
    if (keyPressed) {
      
      if (key == 'c') {
        shedChildren();
      }
      if (key == 'v') {
        absorbChildren();
      }

    }
  }
}
