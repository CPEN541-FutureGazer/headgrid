PShape head;

void settings() {
  size(1280, 720, P3D);
}

void setup() {
  background(50);
  head = loadShape("head.obj");
}

void draw() {
  background(50);
  lights();
  drawTestHead();
}

void drawTestHead() {
  pushMatrix();
  translate(mouseX, mouseY);
  pushMatrix();
  scale(10);
  rotateX(HALF_PI);
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
