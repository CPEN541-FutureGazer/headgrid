PShape head;

Boolean lookAtMouse = false;

int px, py;

void settings() {
  size(1280, 720, P3D);
}

void setup() {
  background(50);
  head = loadShape("head.obj");
  px = width / 2;
  py = height / 2;
}

void draw() {
  background(20);
  
  if (mousePressed) {
    lookAtMouse = false;
    px = mouseX;
    py = mouseY;
  } else {
    lookAtMouse = true;
  }
    
  //lights();
  //lightSpecular(220, 220, 220);
  directionalLight(102, 102, 102, 0, 0, -1);
  lightSpecular(204, 204, 204);
  directionalLight(102, 102, 102, 0, 1, -1);
  lightSpecular(102, 102, 102);
  drawTarget();
  drawTestHead();
}

void drawTestHead() {
  pushMatrix();
  translate(px, py);
  pushMatrix();
  scale(10);
  
  rotateX(HALF_PI);
  if (lookAtMouse) {
    rotateZ(map(mouseX, 0, width, HALF_PI, -HALF_PI));
  } else {
    // look straight forward
  }
  
  specular(150, 150, 150);
  shape(head, 0, 0);
  popMatrix();
  // debug
  fill(255);
  noStroke();
  text("(" + str(mouseX) + ", " + str(mouseY) + ")", 80, -20);
  strokeWeight(3);
  stroke(255, 0, 0);
  line(0, 0, 100, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 100);
  popMatrix();
}

void drawTarget() {
  if (!lookAtMouse) return;
  
  strokeWeight(1);
  stroke(255, 0, 255);
  line(px, py, mouseX, mouseY);
  ellipse(mouseX, mouseY, 5, 5);
}
