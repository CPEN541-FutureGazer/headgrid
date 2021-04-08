void keyPressed() {

    /* Selection keys */
    if (key == 'a') { selectAll(true); }
    if (key == 'q') { selectAll(false); }
    if (keyCode == LEFT) { selectNextFocused(-1); }
    if (keyCode == RIGHT) { selectNextFocused(1); }

    /* Set attention mode */
    if (key == '1') {
        /* set selected view's attention mode to normal */
        setAttentionMode(AttentionMode.ATT_NORMAL);
    } else if (key == '2') {
        /* Set selected view's attention mode to stare */
        setAttentionMode(AttentionMode.ATT_STARE);
    } else if (key == '3') {
        /* Set selected view's attention mode to random */
        setAttentionMode(AttentionMode.ATT_RANDOM);
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

    if (key == 't') {
        /* toggle tracking by enabling/disabling */
        toggleTracking();
    }

    /* Application controls */
    if (key == 'd') { g_debug = !g_debug; }
    if (keyCode == UP) { addView(); }
    if (keyCode == DOWN) { removeView(); }

    /* Add / remove view mode set */
    if (key == 'e') {
        if (g_addType == AddType.ADD_HEAD) {
            g_addType = AddType.ADD_EYE;
        } else {
            g_addType = AddType.ADD_HEAD;
        }
    }
}


void selectAll(Boolean select) {
    for (View v : g_views) {
        v.isFocused = select;
    }
}

int g_activeId = 0;
void selectNextFocused(int n) {
    if (g_views.size() != 0) {
        g_views.get(g_activeId).isFocused = false;
        g_activeId = constrain(g_activeId + n, 0, g_views.size() - 1);
        g_views.get(g_activeId).isFocused = true;
    }
}

void toggleTracking() {
    Boolean t = false;
    if (g_views.size() != 0) {
        t = g_views.get(0).isEnabled;
    }
    for (int i = 0; i < g_views.size(); i++) {
        g_views.get(i).isEnabled = !t;
    }
}

void toggleNoise() {
    Boolean n;
    find: {
        for (View v : g_views) {
            if (v.isFocused) {
                n = v.isNoisy;
                break find;
            }
        }

        return;
    }


    for (View v : g_views) {
        if (v.isFocused) {
            v.isNoisy = !n;
        }
    }
}

void toggleScaleAttention() {
Boolean n;
    find: {
        for (View v : g_views) {
            if (v.isFocused) {
                n = v.scaleAttention;
                break find;
            }
        }

        return;
    }


    for (View v : g_views) {
        if (v.isFocused) {
            v.scaleAttention = !n;
        }
    }
}

void setAttentionMode(AttentionMode mode) {
    for (View v : g_views) {
        if (v.isFocused) {
            v.attentionMode = mode;
        }
    }
}

void addView() {
    if (g_addType == AddType.ADD_HEAD) {
        g_views.add(new HeadView(g_nextViewID++, head, 0, 0));
    } else {
        g_views.add(new EyeView(g_nextViewID++, 0, 0));
    }

    if (g_views.size() == 1) {
        g_views.get(0).isFocused = true;
    }
    arrangeViews();
}

void removeView() {
    if (g_views.size() == 0) return;
    g_views.remove(g_views.size() - 1);
    arrangeViews();
}
