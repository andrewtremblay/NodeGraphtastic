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
      if(pointCollides(mX, mY) && mState != 0){ //mouse down, time to act
        if(hasSomeChildren()){
          toggleChildren();
          interactLocked = true;
        }else
        {
          //we're leaf, so collapse?
          collapseNode();
        }
      }
      else       
      {
        //if the parent didn't eat the mouse click, pass the click to the children
        if(children != null)
        {
         for(int i = 0; i < children.length; i++)
         {
          children[i].doMouseInput(mX, mY, mState);
         } 
        }
      }
    }
  }
  
  boolean hasSomeChildren()
  {
    boolean toRet = false;
    if(children != null)
    {
      toRet = children.length > 0;
    }
    return toRet;
  }

  boolean allChildrenCollapsed()
  {
    boolean toRet = true;
    if(children != null)
    {
       for(int i = 0; i < children.length; i++)
       {
         if(!children[i].collapsed){
            toRet = false;
            break;
          }
       } 
    }
    return toRet;
  }


  boolean pointCollides(float pX, float pY)
  {   //thank god we got circles
      float dx = pX - currentXpos;
      float dy = pY - currentYpos;
      float distance = sqrt(dx*dx + dy*dy) * 2;
      return (distance < currentRadius);  
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
    setDest(collapsedXpos, collapsedYpos, collapsedRadius);
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
  
  //find variables with respect to parent state
  float collapsedXpos()
  {
    return collapsedXpos;
  }

  float collapsedYpos()
  {
    return collapsedYpos;
  }

  float collapsedRadius()
  {
    return collapsedRadius;
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
