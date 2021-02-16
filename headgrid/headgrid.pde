PShape head;

Boolean lookAtMouse = false;

Head[] heads = new Head[9];

void settings() {
	size(1280, 720, P3D);
}

void setup() {
	background(50);
	head = loadShape("head.obj");

	/* Initialize head objects */
	for (int i = 0; i < 9; i++) {
		float paddingX = 300;
		float paddingY = 100;
		float x = map((i % 3), 0, 2, paddingX, width - paddingX);
		float y = map((i / 3), 0, 2, paddingY, height - paddingY);

		heads[i] = new Head(x, y);
	}
}

void draw() {
	background(20);
	fill(255);
	noStroke();
	text(frameRate, 20, 20);
	
	//lights();
	directionalLight(102, 102, 102, 0, 0, - 1);
	lightSpecular(204, 204, 204);
	directionalLight(102, 102, 102, 0, 1, - 1);
	lightSpecular(102, 102, 102);

	/* Draw */

	for (int i = 0; i < heads.length; i++) {
		heads[i].draw();
	}
}
