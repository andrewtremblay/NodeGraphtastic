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
  
  boolean collapsed = false;
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
      if(collapsed)
      {
        fill(100);
      }
      else
      {
        fill(0);
      }
      ellipse(currentXpos, currentYpos, currentRadius, currentRadius);
  }
  
  //change
  void doMouseInput(int mX, int mY, int mState)
  {
    //hierarchy this out to better control the child behavior, block passing of click to children
    if(interactLocked){
      //we've done something already. Do not pass go
    }
    else
    {
      if(pointCollides(mX, mY) && mState != 0){ //mouse down
          toggleChildren();
          interactLocked = true;
      }
      //if the parent ate the mouse click, don't pass to the children
      if(!interactLocked && hasChildNodes()){
         for(int i = 0; i < children.length; i++)
         {
          children[i].doMouseInput(mX, mY, mState);
         } 
       }
    }
  }

  boolean pointCollides(float pX, float pY)
  {   //thank god we got circles
      float dx = pX - currentXpos;
      float dy = pY - currentYpos;
      float distance = sqrt(dx*dx + dy*dy) * 2;
      return (distance < currentRadius);  
  }
  
  boolean hasChildNodes()
  {
    return (children != null)  && (children.length != 0);
  }
  
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
    if(hasChildNodes()){
        setDest(collapsedXpos, collapsedYpos, collapsedRadius);
    }
    else
    {
      
    }
    decay = minDecay;
  }

  void expandNode()
  { 
    collapsed = false;
        setDest(expandedXpos, expandedYpos, expandedRadius);
    decay = minDecay;
  }  
  
  void toggleNode()
  { 
    if(collapsed)
    {
      expandNode();
    }
    else
    {
      collapseNode();
    }
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
     if(hasChildNodes()){
       expandNode();
       for(int i = 0; i < children.length; i++)
       {
         children[i].collapseNode();
       }
     }
   }

  void shedChildren()
  {
     if(hasChildNodes()){
       collapseNode();
       for(int i = 0; i < children.length; i++)
       {
         children[i].expandNode();
       }
     }
  }
  
  void toggleChildren()
  { 
    if(collapsed)
    {
      absorbChildren();
    }
    else
    {
      shedChildren();
    }
  }  


}
