HeadModel head;

Boolean lookAtMouse = false;

<<<<<<< HEAD
float cameraZ;

Head[] heads = new Head[9];

int mode = 0;
=======
ArrayList<HeadView> heads;

int mode = 1;
int gid = 0;
>>>>>>> 3026bf5... refactored to view

void settings() {
    size(1280, 720, P3D);
}

int activeId = 0;
void setActive(int n) {
    if (heads.size() != 0) {
        heads.get(activeId).isEnabled = false;
        heads.get(activeId).isFocused = false;
        
        activeId = constrain(activeId + n, 0, heads.size() - 1);
        heads.get(activeId).isEnabled = true;
        heads.get(activeId).isFocused = true;
    }
}

void toggleTracking() {
    Boolean t = false;
    if (heads.size() != 0) {
        t = heads.get(0).isEnabled;
    }
    for (int i = 0; i < heads.size(); i++) {
        heads.get(i).isEnabled = !t;
    }
}

void addHead() {
    heads.add(new HeadView(head, 0, 0));
    if (heads.size() == 1) {
        heads.get(0).isFocused = true;
    }
    arrangeHeads();
}

void removeHead() {
    if (heads.size() == 0) return;
    heads.remove(heads.size() - 1);
    arrangeHeads();
}

void setup() {
    background(20);
    
    head = loadHead(0);
    
    heads = new ArrayList<HeadView>();
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
    
void keyPressed() {
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
