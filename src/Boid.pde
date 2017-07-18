
class Boid {
  
  PVector position, velocity, acceleration;
  float angle, mass, maxspeed, maxforce;
  FlockingParam separation, alignment, cohesion;
  PVector size;
  
  Boid(float x, float y, PVector s, float m, float mspeed, float mforce, FlockingParam sep, FlockingParam ali, FlockingParam coh) {
    position = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
    angle = 0;
    mass = m;
    maxspeed = mspeed;
    maxforce = mforce;
    separation = sep;
    alignment = ali;
    cohesion = coh;
    size = s;
  }
  
  void applyForce(PVector force) {
    acceleration.add(PVector.div(force, mass));
  }
  
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.set(0, 0);
    
    float heading = velocity.heading();
    if (heading != 0) {
      angle = heading;
    }
  }
  
  void wrapBorders(PVector topLeft, PVector botRight) {
    float minX = topLeft.x - size.x/2;
    float minY = topLeft.y - size.y/2;
    float maxX = botRight.x + size.x/2;
    float maxY = botRight.y + size.y/2;
    
    if (position.x < minX) {
      position.x = maxX;
    } else if (position.x > maxX) {
      position.x = minX;
    }
    if (position.y < minY) {
      position.y = maxY;
    } else if (position.y > maxY) {
      position.y = minY;
    }
  }
  
  // combined behaviors
  void flock(ArrayList<Boid> boids) {
    PVector sep = getSeparationForce(boids, separation.distance);
    PVector ali = getAlignmentForce(boids, alignment.distance);
    PVector coh = getCohesionForce(boids, cohesion.distance);
    
    sep.mult(separation.coefficient);
    ali.mult(alignment.coefficient);
    coh.mult(cohesion.coefficient);
    
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  
  void fleeTarget(PVector target, float coef, float dist) {
    float d = PVector.dist(position, target);
    if ((d > 0) && (d < dist)) {
      applyForce(PVector.mult(getFleeingForce(target), coef));
    }
  }
  
  // complex behaviors
  PVector getSeparationForce(ArrayList<Boid> boids, float dist) {
    PVector average = new PVector();
    int count = 0;
    
    for (Boid other: boids) {
      PVector dir = PVector.sub(position, other.position);
      float d = dir.mag();
      
      if ((d > 0) && (d < dist)) {
        dir.normalize();
        dir.div(d);
        average.add(dir);
        count++;
      }
    }
    
    if (count > 0) {
      average.div(count);
      average.setMag(maxspeed);
      
      return getSteeringForce(average);
    } else {
      return new PVector();
    }
  }
  
  PVector getAlignmentForce(ArrayList<Boid> boids, float dist) {
    PVector average = new PVector();
    int count = 0;
    
    for (Boid other: boids) {
      float d = PVector.dist(position, other.position);
      
      if ((d > 0) && (d < dist)) {
        average.add(other.velocity);
        count++;
      }
    }
    
    if (count > 0) {
      average.div(count);
      average.setMag(maxspeed);
      
      return getSteeringForce(average);
    } else {
      return new PVector();
    }
  }
  
  PVector getCohesionForce(ArrayList<Boid> boids, float dist) {
    PVector average = new PVector();
    int count = 0;
    
    for (Boid other: boids) {
      float d = PVector.dist(position, other.position);
      
      if ((d > 0) && (d < dist)) {
        average.add(other.position);
        count++;
      }
    }
    
    if (count > 0) {
      average.div(count);
      
      return getSeekingForce(average);
    } else {
      return new PVector();
    }
  }
  
  // basic behaviors
  PVector getSeekingForce(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.setMag(maxspeed);
    
    return getSteeringForce(desired);
  }
  
  PVector getFleeingForce(PVector target) {
    PVector desired = PVector.sub(position, target);
    desired.setMag(maxspeed);
    
    return getSteeringForce(desired);
  }
  
  PVector getArrivingForce(PVector target, float dist) {
    PVector desired = PVector.sub(target, position);
    float d = desired.mag();
    desired.normalize();
    
    if (d < dist) {
      float m = map(d, 0, dist, 0, maxspeed);
      desired.mult(m);
    } else {
      desired.mult(maxspeed);
    }
    
    return getSteeringForce(desired);
  }
  
  // steering
  void steer(PVector desired) {
    applyForce(getSteeringForce(desired));
  }
  
  PVector getSteeringForce(PVector desired) {
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    return steer;
  }
  
  // getters
  PVector getPosition() { return position; }
  float getAngle() { return angle; }
  PVector getSize() {return size; }
}