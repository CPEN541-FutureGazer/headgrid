HeadModel head;

Boolean lookAtMouse = false;

int mode = 1;
int gid = 0;
Boolean g_debug = false;
Boolean g_highlightMouse = false;

AddType g_addType = AddType.ADD_HEAD;

ArrayList<View> g_views;

PImage zoomUI;

void settings() {
    size(1280, 720, P3D);
}

void setup() {
    surface.setTitle("Zoom Meeting");
    background(33);
    head = loadHead(0);
    g_views = new ArrayList<View>();   
}

void draw() {
    background(33);
    // fill(255);
    // noStroke();
    // text(int(frameRate) + " mode: " + str(mode) + ", aid: " + str(activeId), 20, 20);
    
    directionalLight(255, 255, 255, 0, 1, - 1);
    ambient(50, 50, 50);

    if (g_highlightMouse) {
        lightFalloff(1.0, 0.005, 0.0001);
        pointLight(50, 255, 100, mouseX, mouseY, 100);
    }
    
    /* Draw */
    for (View v : g_views) {
        v.draw();
    }
    
    image(zoomUI, 0, height - 55, width, 55);
}
    
