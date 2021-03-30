HeadModel head;

Boolean lookAtMouse = false;

float cameraZ;

Head[] heads = new Head[9];

int mode = 0;

void settings() {
    size(1280, 720, P3D);
}

int activeId = 0;
void setActive(int n) {
    if (heads.size() != 0) {
        heads.get(activeId).tracking = false;
        
        activeId = constrain(activeId + n, 0, heads.size() - 1);
        heads.get(activeId).tracking = true;
    }
}

void toggleTracking() {
    Boolean t = false;
    if (heads.size() != 0) {
        t = heads.get(0).tracking;
    }
    for (int i = 0; i < heads.size(); i++) {
        heads.get(i).tracking = !t;
    }
}

void addHead() {
    heads.add(new Head(0, 0));
    arrangeHeads();
}

void removeHead() {
    if (heads.size() == 0) return;
    heads.remove(heads.size() - 1);
    arrangeHeads();
}

void setup() {
    background(20);
    
    head = loadHead(1);
    
    heads = new ArrayList<Head>();
}

void draw() {
    background(20);
    fill(255);
    noStroke();
    text(int(frameRate) + " mode: " + str(mode) + ", aid: " + str(activeId), 20, 20);
    
    directionalLight(255, 255, 255, 0, 1, - 1);
    ambient(50, 50, 50);
    lightFalloff(1.0, 0.005, 0.0001);
    pointLight(50, 255, 100, mouseX, mouseY, 100);
    
    /*Draw */
    for (int i = 0; i < heads.size(); i++) {
        heads.get(i).draw();
    }
}
    
voidkeyPressed() {
    if(key >= '0' && key <= '9') {
        mode = key - '0';
    }
    
    /*Turn on noisy move */
    if (key == 'n') {
        noiseMove = !noiseMove;
    }
    
    if (key == 's') {
        attentionScale = !attentionScale;
    }
    
    if (keyCode == UP) {
        addHead();
    }
    
    if (keyCode == DOWN) {
        removeHead();
    }
    
    if (keyCode == LEFT) {
        setActive( - 1);
    }
    
    if (keyCode == RIGHT) {
        setActive(1);
    }
    
    if (key == 't') {
        toggleTracking();
    }
}
