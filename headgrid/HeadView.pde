
class HeadView extends View {

    float rotX;
    float rotY;
    float baseRotX;
    float baseRotY;

    /* Reference to the head object */
    HeadModel model;
    
    public HeadView(HeadModel model, float x, float y) {
        super(x, y, 0);

        this.model = model;
        
        this.rotX = 0;
        this.rotY = 0;
    }
    
    @Override
    public void setPosition(float x, float y) {
        super.setPosition(x, y);

        /* These two values look directly out the screen */
        /* This is only a function of the position */
        this.baseRotX = map(this.y, 120, 600, - 0.291, 0.234);
        this.baseRotY = map(this.x, 300, 980, - 0.462, 0.520);
    }
    
    @Override
    public void draw() {
        pushMatrix();
        translate(this.x, this.y, this.z);

        float targetScale = this.scale;
        if (this.scaleAttention) {
            float diffRZ = this.rotY - this.baseRotY;
            float diffRX = this.rotX - this.baseRotX;
            targetScale *= map(abs(diffRZ * diffRX), 0, 1, 1.2, 0.4);
        }
        scale(targetScale);

        pushMatrix();
        
        float diffX = mouseX - this.x;
        float diffY = mouseY - this.y;
        
        if (this.isEnabled) {

            
            float targetRX = 0;
            float targetRY = 0;

            switch (this.attentionMode) {
                case ATT_NORMAL:
                    targetRY = map(diffX, - width / 2, width / 2, HALF_PI, - HALF_PI);
                    targetRX = map(diffY, - height / 2, height / 2, PI / 6, - PI / 6);
                    targetRX += this.baseRotX;
                    targetRY += this.baseRotY;
                    break;

                case ATT_STARE:
                    targetRX = this.baseRotX;
                    targetRY = this.baseRotY;
                    break;

                case ATT_RANDOM:
                    targetRX = map(noise(frameCount * 0.01 + PI * this.id), 0, 1, HALF_PI, - HALF_PI);
                    targetRY = map(noise(frameCount * 0.01 - PI * this.id), 0, 1, HALF_PI, - HALF_PI);
                    break;
            }
                
            if (this.isNoisy) {
                targetRY += (2 * noise(this.x + frameCount * this.noiseFreq) - 1) * 0.25;
                targetRX += (2 * noise(this.y + frameCount * this.noiseFreq) - 1) * 0.15;
            }
            
            targetRY = constrain(targetRY, - HALF_PI, HALF_PI);
            targetRX = constrain(targetRX + this.baseRotX, - PI / 4, PI / 4);
            
            this.rotY = lerp(this.rotY, targetRY, this.lerpRY);
            this.rotX = lerp(this.rotX, targetRX, this.lerpRX);

            // Head bobbing
            rotateZ((targetRY - this.rotY) * 0.3);
        }
        
        rotateY(-this.rotY);
        rotateX(this.rotX);
        
        specular(150, 150, 150);

        model.draw();
        popMatrix();

        if (this.isFocused) {
            drawFocused();
        }
        
        popMatrix();
        
        /* Debug */
        if (g_debug) {
            fill(255);
            noStroke();
            text(this.scale, this.x + 80, this.y - 20, 100);
            text("(" + str(this.x) + ", " + str(this.y) + ")", this.x, this.y, 100);
        }

        if (g_debug && this.isEnabled) {
            strokeWeight(1);
            stroke(255, 0, 255);
            line(this.x, this.y, this.z, mouseX, mouseY, 0);
            ellipse(mouseX, mouseY, 5, 5);
        }
    }
}
