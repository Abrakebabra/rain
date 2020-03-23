void setup() {
  size(600, 600);
}

public class Umbrella {
  int span = 72;
  int depth = 250;
  int xPos = 0;
  int yPos = 0;
  
  public void display() {
    xPos = mouseX;
    yPos = mouseY;
    
    pushMatrix();
      translate(xPos, yPos);
      
      fill(0, 0, 255);
      for (int x = -span; x < span; x++) {
        ellipse(x, pow(x, 2.0) / depth, 2, 2);
      }
    popMatrix();
  }
}

Umbrella umbrella = new Umbrella();

public class RainDrop {
  PVector rainPos = new PVector(mouseX + random(-50, 50), mouseY);
  PVector rainAccel = new PVector(0, 0);
  PVector rainVel = new PVector(0, 0);
  int size = floor(random(2, 4));
  color col1 = color(0, 255, 255, 150);
  boolean contact = false;
  int bounce = 1;
  
  void display() {
    fill(col1);
    ellipse(rainPos.x, rainPos.y, size, size);
  }
  
  public void update() {
    rainVel.add(rainAccel);
    rainAccel.mult(0);
    rainPos.add(rainVel);
    
    if (rainPos.y > 600) {
      rainPos.x = random(-200, 800);
      rainPos.y = random(-100, -1);
      rainVel.set(0, 0);
      bounce = 0;
    }
  }
  
  public void collide() {
    float xPosRelative = rainPos.x - umbrella.xPos;
    float yPosRelative = pow(xPosRelative, 2)
                          / umbrella.depth + umbrella.yPos;
    
    if (rainPos.x < umbrella.xPos + umbrella.span &&
        rainPos.x > umbrella.xPos - umbrella.span &&
        rainPos.y > yPosRelative &&
        rainPos.y < yPosRelative + 20) {
          bounce++;
          rainPos.y = yPosRelative;
          
          if (xPosRelative > 0) {
            rainPos.x = umbrella.xPos +
            sqrt((rainPos.y - umbrella.yPos) * umbrella.depth);
            rainVel.set(0.5, -1 * 1 / bounce);
          } else {
            rainPos.x = umbrella.xPos - 
            sqrt((rainPos.y - umbrella.yPos) * umbrella.depth);
            rainVel.set(-0.5, -1 * 1 / bounce);
          }
        }
  }
  
  public void applyForce(PVector force) {
    PVector f = PVector.div(force, size);
    rainAccel.add(f);
  }
  
  public void applyGravity() {
    rainAccel.add(0, 0.1);
  }
}

ArrayList<RainDrop> rainDrop = new ArrayList<RainDrop>();



float noiseX = random(0, 100);
float noiseY = random(0, 100);

public void draw() {
  background(79, 79, 79);
  noStroke();
  fill(255, 0, 0);
  
  float nX = noise(noiseX);
  float nY = noise(noiseY);
  PVector wind = new PVector(map(nX, 0.0, 1.0, -0.4, 0.4), map(nY, 0.0, 1.0, -0.3, 0.2));
  noiseX += 0.01;
  noiseY += 0.01;
  
  
  
  if (mousePressed && rainDrop.size() < 1000) {
    RainDrop newDrop = new RainDrop();
    rainDrop.add(newDrop);
  }
  
  umbrella.display();
  
  for (int i = 0; i < rainDrop.size(); i++) {
    rainDrop.get(i).applyGravity();
    rainDrop.get(i).applyForce(wind);
    rainDrop.get(i).update();
    rainDrop.get(i).collide();
    rainDrop.get(i).display();
  }
}
