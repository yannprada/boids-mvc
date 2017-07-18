
class Flock {
  
  ArrayList<Boid> boids;
  PVector boidSize;
  PVector topLeftBoundary, bottomRightBoundary;
  
  // default values, boids values can be modified later via events
  final float BOID_MASS = 1;
  final float BOID_MAXSPEED = 5;
  final float BOID_MAXFORCE = 0.1;
  final FlockingParam BOID_SEPARATION = new FlockingParam(1.1, 50);
  final FlockingParam BOID_ALIGNMENT = new FlockingParam(1, 100);
  final FlockingParam BOID_COHESION = new FlockingParam(0.75, 100);
  
  final float FLEE_COEF = 1;
  final float FLEE_DIST = 150;
  
  Flock(PVector topLeft, PVector botRight, PVector bs) {
    boids = new ArrayList<Boid>();
    boidSize = bs;
    topLeftBoundary = topLeft;
    bottomRightBoundary = botRight;
  }
  
  void addBoid(float x, float y) {
    boids.add(new Boid(x, y, boidSize, BOID_MASS, BOID_MAXSPEED, BOID_MAXFORCE, BOID_SEPARATION, BOID_ALIGNMENT, BOID_COHESION));
  }
  
  void generateBoids(float x, float y, int n) {
    for (int i = 0; i < n; i++) {
      addBoid(x + random(-100, 100), y + random(-10, 10));
    }
  }
  
  void run() {
    for (Boid b: boids) {
      b.flock(boids);
      b.update();
      b.wrapBorders(topLeftBoundary, bottomRightBoundary);
    }
  }
  
  void flee(float x, float y) {
    PVector target = new PVector(x, y);
    for (Boid b: boids) {
      b.fleeTarget(target, FLEE_COEF, FLEE_DIST);
    }
  }
  
  ArrayList<Boid> getBoids() {
    return boids;
  }
  
  void setMass(float mass) {
    for (Boid b: boids) {
      b.mass = mass;
    }
  }
  
  void setMaxspeed(float maxspeed) {
    for (Boid b: boids) {
      b.maxspeed = maxspeed;
    }
  }
  
  void setMaxforce(float maxforce) {
    for (Boid b: boids) {
      b.maxforce = maxforce;
    }
  }
  
  void setSeparationCoef(float coef) {
    for (Boid b: boids) {
      b.separation.coefficient = coef;
    }
  }
  
  void setAlignmentCoef(float coef) {
    for (Boid b: boids) {
      b.alignment.coefficient = coef;
    }
  }
  
  void setCohesionCoef(float coef) {
    for (Boid b: boids) {
      b.cohesion.coefficient = coef;
    }
  }
  
  void setSeparationDist(float dist) {
    for (Boid b: boids) {
      b.separation.distance = dist;
    }
  }
  
  void setAlignmentDist(float dist) {
    for (Boid b: boids) {
      b.alignment.distance = dist;
    }
  }
  
  void setCohesionDist(float dist) {
    for (Boid b: boids) {
      b.cohesion.distance = dist;
    }
  }
}