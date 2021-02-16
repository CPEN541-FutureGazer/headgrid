PShape head;

Boolean lookAtMouse = false;

float cameraZ;

Head[] heads = new Head[9];

int mode = 0;

void settings() {
  size(1280, 720, P3D);

  cameraZ = height / 2;
}

void setup() {
  background(20);
  head = loadShape("head.obj");

  /* Initialize head objects */
  for (int i = 0; i < 9; i++) {
    float paddingX = 300;
    float paddingY = 120;
    float x = map((i % 3), 0, 2, paddingX, width - paddingX);
    float y = map((i / 3), 0, 2, paddingY, height - paddingY);

    heads[i] = new Head(x, y);
  }
}

void draw() {
  background(20);
  fill(255);
  noStroke();
  text(int(frameRate) + " mode: " + str(mode), 20, 20);

  //lights();
  //directionalLight(102, 102, 102, 0, 0, - 1);
  //lightSpecular(204, 204, 204);
  directionalLight(255, 255, 255, 0, 1, - 1);
  //lightSpecular(102, 102, 102);
  ambient(50, 50, 50);
  pointLight(150, 0, 0, mouseX, mouseY, 0);

  /* Draw */
  for (int i = 0; i < heads.length; i++) {
    heads[i].draw();
  }
}

Boolean noiseMove = false;

void keyPressed() {
	if (key >= '0' && key <= '9') {
		mode = key - '0';
	}

	/* Turn on noisy move */
	if (key == 'n') {
		noiseMove = !noiseMove;
	}
}
