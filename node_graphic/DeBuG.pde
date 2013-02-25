PFont arial;
long lastFrame;
float appFps;
//SETUP
void debugSetupStuff()
{
  debugSetupFrameCount();
}

void debugSetupFrameCount()
{
  arial = loadFont("Arial.vlw");
  lastFrame = millis();
  appFps = 0;
}

//DRAW LOOP
void debugDrawStuff()
{
  doDebugInput();
  debugDrawFrameCount();
  debugDrawInputState();
  debugDrawBounds();
}

void debugDrawFrameCount()
{
  int timeElapsed = (int)(millis() - lastFrame);
  if(timeElapsed != 0)
  { 
    appFps =(float) 1000 / timeElapsed;
  }
  lastFrame = millis(); 
  
  textFont(arial);
  fill(255);
  text(appFps, 0, 40);
}

void debugDrawInputState()
{

  String msg = "";
//  msg = msg + ( ( interactLocked ? "CLICK: LOCKED" : "CLICK: AVAILABLE" ) );
//  msg = msg + ("\n");
      float dx = mouseX - worldNode.currentXpos;
      float dy = mouseY - worldNode.currentYpos;
      float distance = sqrt(dx*dx + dy*dy)*2;
//      return (distance < currentRadius);  


  msg = msg + ("m Y:"+mouseY+ "  X:"+mouseX);
//Compare two things
float thing1 = distance;
float thing2 = worldNode.currentRadius;
  msg = msg + ("\n");
  msg = msg + (thing1 + " " + ((thing1 < thing2) ? "<" : (thing1 > thing2 ? ">" : "=" ) ) + " " + thing2 );


  
  textFont(arial);
  fill(255);
  text(msg, 0, 62);
}

void debugDrawBounds()
{
  //TODO
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

