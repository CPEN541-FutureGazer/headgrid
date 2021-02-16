class Head {

    float x;
    float y;
    float z;
    
    float rotX;
    float rotZ;
    float baseRotX;
    float baseRotZ;

    float inertiaX;
    float inertiaZ;

    boolean tracking;

    float noiseFreq = random(0.003, 0.01);

    public Head(float x, float y) {
        this.x = x;
        this.y = y;
        //this.z = -cameraZ;
        this.z = 0;

        /* These two values look directly out the screen */
        /* This is only a function of the position */
        this.baseRotX = map(this.y, 120, 600, -0.291, 0.234);
        this.baseRotZ = map(this.x, 300, 980, -0.462, 0.520);
        
        this.rotX = 0;
        this.rotZ = 0;

        this.tracking = true;

        this.inertiaX = random(0.15, 0.3);
        this.inertiaZ = random(0.05, 0.15);
    }

    public void draw() {
        pushMatrix();
        translate(this.x, this.y, this.z);
        pushMatrix();
        scale(10);
        
        rotateX(HALF_PI);

        if (this.tracking) {
            float diffX = mouseX - this.x;
            float diffY = mouseY - this.y;

            float targetRZ = map(diffX, -width / 2, width / 2, HALF_PI, - HALF_PI);
            float targetRX = map(diffY, -height / 2, height / 2, PI / 6, - PI / 6);

            if (mode == 1) {
                targetRZ += this.baseRotZ;
            } else if (mode == 2) {
                targetRX += this.baseRotX;
            } else if (mode == 3) {
                targetRZ += this.baseRotZ;
                targetRX += this.baseRotX;
            } else if (mode == 4) {
                targetRZ = this.baseRotZ;
                targetRX = this.baseRotX;
            }

            if (noiseMove) {
                targetRZ += (2 * noise(this.x + frameCount * this.noiseFreq) - 1) * 0.25;
                targetRX += (2 * noise(this.y + frameCount * this.noiseFreq) - 1) * 0.15;
            }

            targetRZ = constrain(targetRZ, -HALF_PI, HALF_PI);
            targetRX = constrain(targetRX + this.baseRotX, -PI / 4, PI / 4);

            this.rotZ = lerp(this.rotZ, targetRZ, this.inertiaX);
            this.rotX = lerp(this.rotX, targetRX, this.inertiaZ);
            
            rotateZ(this.rotZ);
            rotateX(this.rotX);
            
            rotateY((targetRZ - this.rotZ) * 0.3);
        }
        
        specular(150, 150, 150);
        shape(head, 0, 0);
        popMatrix();

        //debug
        // fill(255);
        // noStroke();
        // text("(" + str(this.rotX) + ", " + str(this.rotZ) + ")", 80, -20);
        // text("(" + str(this.x) + ", " + str(this.y) + ")", 80, 0);
        
        popMatrix();
        
        // if (!this.tracking) return;
        // strokeWeight(1);
        // stroke(255, 0, 255);
        // line(this.x, this.y, this.z, mouseX, mouseY, 0);
        // ellipse(mouseX, mouseY, 5, 5);
    }
}
