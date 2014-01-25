boolean MouseLeftIsPressed = false;
PImage BackgroundImage;
PVector ViewOffset = new PVector(0, 0, 0);
PVector ViewTarget = new PVector(0, 0, 0);

float Feathering = 0.001;
float Attraction = 4.0;
float Break = 2.0;

int Marker;

float TanH_F(float x)
{
  float g = exp(2.0 * x);
  return (g - 1.0) / (g + 1.0);
}

void setup()
{
  size(800, 600, OPENGL);
  frameRate(60);
  smooth();
  BackgroundImage = loadImage("background.png");
}

void mousePressed()
{
  MouseLeftIsPressed = true;
}

void mouseReleased()
{
  MouseLeftIsPressed = false;
}

void draw()
{
  float dT = millis() - Marker;
  Marker = millis();
  
  if(MouseLeftIsPressed)
  {
    ViewTarget.x = mouseX;
    ViewTarget.y = mouseY;
  }
  
  float dist = PVector.dist(ViewOffset, ViewTarget);
  float attr = Attraction / (dist + Attraction);
  float br = Break / (dist + Break);
  float alpha = Feathering * dT + attr - br;
  ViewOffset.x = lerp(ViewOffset.x, ViewTarget.x, alpha);
  ViewOffset.y = lerp(ViewOffset.y, ViewTarget.y, alpha);
  
  background(0);
  pushMatrix();
  translate(ViewOffset.x, ViewOffset.y);
  imageMode(CENTER);
  image(BackgroundImage, 0, 0);
  popMatrix();
  pushMatrix();
  translate(ViewTarget.x, ViewTarget.y);
  ellipseMode(CENTER);
  ellipse(0.0, 0.0, 10, 10);
  popMatrix();
}
