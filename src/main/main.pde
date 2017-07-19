import controlP5.*;

Flock flock;
UI ui;

void setup() {
  fullScreen();
  
  float x = min(width, height) / 200; // scale boids to window
  float y = x * 0.66;
  
  flock = new Flock(new PVector(0, 0), new PVector(width, height), new PVector(x, y), 200);
  flock.generateBoids(width/2, height/2, 100);
  
  ui = new UI(this, flock);
}

void draw() {
  background(0);
  
  flock.run();
  ui.displayFlock();
  
  if (mousePressed) {
    switch(mouseButton) {
      case LEFT:
        flock.flee(mouseX, mouseY);
        ui.displayMouse(mouseX, mouseY);
        break;
      case RIGHT:
        flock.addBoid(mouseX, mouseY);
        break;
    }
  }
}