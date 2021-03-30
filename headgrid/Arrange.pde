final float ARRANGE_RATIO = 1.2;

void arrangeViews() {
    int numheads = g_views.size();
    
    int w = floor(sqrt(numheads * ARRANGE_RATIO));
    int h = ceil(w / ARRANGE_RATIO);
    while((w * h) < numheads)
        w++;
    
    float paddingY = constrain( - 20 * (h - 2) + 200, 100, 500);
    float paddingX = constrain(100 * exp( - w + 2.5) + 200, 0, 500);
    
    int i = 0;
    for (int j = 0; j < w; j++) {
        for (int k = 0; k < h; k++) {
            if (i >= g_views.size()) {
                break;
            }
                
            float x, y;
            if (w == 1) {
                x = width / 2;
            } else {
                x = map(j, 0, w - 1, paddingX, width - paddingX);
            }
                
            if (h == 1) {
                y = height / 2;
            } else {
                y = map(k, 0, h - 1, paddingY, height - paddingY); 
            }
            
            g_views.get(i).setPosition(x, y);
            g_views.get(i).scale = constrain(exp( - 0.55 * (h - 6)) + 3, 1, 20);
            
            i++;
        }
    }
}
