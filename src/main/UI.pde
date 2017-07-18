
class UI {
  
  Flock flock;
  ControlP5 cp5;
  PVector sliderPosition;
  
  final color BOID_FILL_COLOR = color(255, 99);
  final color BOID_STROKE_COLOR = color(255);
  
  final PFont FONT = createFont("Arial", 16);
  final color LABEL_COLOR = color(255);
  final PVector SLIDER_SIZE = new PVector(100, 20);
  final float SLIDER_SPACING = 5;
  
  UI(PApplet parent, Flock f) {
    flock = f;
    cp5 = new ControlP5(parent);
    sliderPosition = new PVector(5, 5);
    
    createLabel("Left click: repulse boids");
    createLabel("Right click: add boids");
    incPosition();
    createLabel("Misc");
    createSlider(flock, "setMass", "mass", 0.1, 5, flock.BOID_MASS);
    createSlider(flock, "setMaxspeed", "maxspeed", 0, 10, flock.BOID_MAXSPEED);
    createSlider(flock, "setMaxforce", "maxforce", 0, 1, flock.BOID_MAXFORCE);
    incPosition();
    createLabel("Coefficients");
    createSlider(flock, "setSeparationCoef", "separation", 0, 2, flock.BOID_SEPARATION.coefficient);
    createSlider(flock, "setAlignmentCoef", "alignment", 0, 2, flock.BOID_ALIGNMENT.coefficient);
    createSlider(flock, "setCohesionCoef", "cohesion", 0, 2, flock.BOID_COHESION.coefficient);
    incPosition();
    createLabel("Distances");
    createSlider(flock, "setSeparationDist", "separation", 0, 250, flock.BOID_SEPARATION.distance);
    createSlider(flock, "setAlignmentDist", "alignment", 0, 250, flock.BOID_ALIGNMENT.distance);
    createSlider(flock, "setCohesionDist", "cohesion", 0, 250, flock.BOID_COHESION.distance);
  }
  
  void incPosition() {
    sliderPosition.y += SLIDER_SIZE.y + SLIDER_SPACING;
  }
  
  void createSlider(Object object, String valueName, String labelName, float mini, float maxi, float defaultValue) {
    cp5.addSlider(object, valueName)
       .setRange(mini, maxi)
       .setValue(defaultValue)
       .setSize(int(SLIDER_SIZE.x), int(SLIDER_SIZE.y))
       .setPosition(sliderPosition.x, sliderPosition.y)
       .setLabel(labelName)
       .setColorLabel(LABEL_COLOR)
       .setFont(FONT)
       ;
    incPosition();
  }
  
  void createLabel(String name) {
    cp5.addTextlabel(name)
       .setText(name)
       .setPosition(sliderPosition.x, sliderPosition.y)
       .setColorValue(LABEL_COLOR)
       .setFont(FONT)
       ;
    incPosition();
  }
  
  void displayFlock() {
    for (Boid b: flock.getBoids()) {
      fill(BOID_FILL_COLOR);
      stroke(BOID_STROKE_COLOR);
      
      PVector pos = b.getPosition();
      float angle = b.getAngle();
      PVector s = b.getSize();
      
      pushMatrix();
      translate(pos.x, pos.y);
      rotate(angle);
      
      beginShape();
      vertex(s.x, 0);
      vertex(-s.x, s.y);
      vertex(-s.x, -s.y);
      endShape(CLOSE);
      
      popMatrix();
    }
  }
  
  void displayMouse(float x, float y) {
    fill(255, 0, 0, 75);
    noStroke();
    ellipseMode(RADIUS);
    ellipse(x, y, flock.FLEE_DIST, flock.FLEE_DIST);
  }
}