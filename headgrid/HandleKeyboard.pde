void keyPressed() {

    /* Selection keys */
    if (key == 'a') {
        /* Select all */
        selectAll();
    }

    if (key == 'q') {
        /* Select none */
        selectNone();
    }

    /* Set attention mode */
    if (key == '1') {
        /* set selected view's attention mode to normal */
        setAttentionMode(NORMAL);
    } else if (key == '2') {
        /* Set selected view's attention mode to stare */
        setAttentionMode(STARE);
    } else if (key == '3') {
        /* Set selected view's attention mode to random */
        setAttentionMode(RANDOM);
    }

    /* Other toggles */
    if (key == 'n') {
        /* Toggle whether there's noisy wobble to the view */
        toggleNoise();
    }

    if (key == 's') {
        /* Toggle whether the head should scale based on attention */
        toggleScaleAttention();
    }


    /* Application controls */

    /* Debug flag */
    if (key == 'd') {
        g_debug = !g_debug;
    }
    
    if (keyCode == UP) {
        addHead();
    }
    
    if (keyCode == DOWN) {
        removeHead();
    }
    
    if (keyCode == LEFT) {
        selectNextFocused(-1);
    }
    
    if (keyCode == RIGHT) {
        selectNextFocused(1);
    }
    
    if (key == 't') {
        toggleTracking();
    }
}


void selectAll() {
}

void selectNone() {

}

int g_activeId = 0;
void selectNextFocused(int n) {
    if (heads.size() != 0) {
        heads.get(g_activeId).isEnabled = false;
        heads.get(g_activeId).isFocused = false;
        
        g_activeId = constrain(g_activeId + n, 0, heads.size() - 1);
        heads.get(g_activeId).isEnabled = true;
        heads.get(g_activeId).isFocused = true;
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