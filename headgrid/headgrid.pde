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
      	} else{
        	lookAtMouse = true;
      	}
    
    //lights();
    directionalLight(102, 102, 102, 0, 0, - 1);
    lightSpecular(204, 204, 204);
    directionalLight(102, 102, 102, 0, 1, - 1);
    lightSpecular(102, 102, 102);
    drawTarget();
    drawTestHead();
}

float targetRZ = 0;
float targetRX = 0;

float rZ, rX; 

void drawTestHead() {
    pushMatrix();
    translate(px, py);
    pushMatrix();
    scale(10);
    
    rotateX(HALF_PI);
    if (lookAtMouse) {
        	float targetRZ = map(mouseX, 0, width, HALF_PI, - HALF_PI);
        	float targetRX = map(mouseY, 0, height, PI / 6, - PI / 6);
        	
        	rZ = lerp(rZ, targetRZ, 0.2);
        	rX = lerp(rX, targetRX, 0.1);
        	
        	rotateZ(rZ);
        	rotateX(rX);
      	}
    
    specular(150, 150, 150);
    shape(head, 0, 0);
    popMatrix();
    //debug
    fill(255);
    noStroke();
    text("(" + str(mouseX) + ", " + str(mouseY) + ")", 80, - 20);
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
