PFont arial;
long lastFrame;
float appFps;

void debugSetupStuff()
{
  debugSetupFrameCount();
}

void debugDrawStuff()
{
  doDebugInput();
  debugDrawFrameCount();
}


void debugSetupFrameCount()
{
arial = loadFont("Arial.vlw");
lastFrame = millis();
appFps = 0;
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

