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

    public Head(float x, float y) {
        this.x = x;
        this.y = y;
        //this.z = -cameraZ;
        this.z = 0;

        /* These two values look directly out the screen */
        /* This is only a function of the position */
        this.baseRotX = 0;
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

            float targetRZ = constrain(
                map(diffX, -width / 2, width / 2, HALF_PI, - HALF_PI),
                -HALF_PI, HALF_PI
            );
            float targetRX = constrain(
                map(diffY, -height / 2, height / 2, PI / 6, - PI / 6),
                -PI / 4, PI / 4
            );
            
            this.rotZ = lerp(this.rotZ, targetRZ, this.inertiaX);
            this.rotX = lerp(this.rotX, targetRX, this.inertiaZ);
            
            rotateZ(this.baseRotZ + this.rotZ);
            rotateX(this.baseRotX + this.rotX);
            
            rotateY((targetRZ - this.rotZ) * 0.3);
        }
        
        specular(150, 150, 150);
        shape(head, 0, 0);
        popMatrix();

        //debug
        fill(255);
        noStroke();
        text("(" + str(this.rotX) + ", " + str(this.rotZ) + ")", 80, -20);
        text("(" + str(this.x) + ", " + str(this.y) + ")", 80, 0);
        // strokeWeight(3);
        // stroke(255, 0, 0);
        // line(0, 0, 100, 0);
        // stroke(0, 255, 0);
        // line(0, 0, 0, 100);
        
        popMatrix();
        
        // if (!this.tracking) return;
        // strokeWeight(1);
        // stroke(255, 0, 255);
        // line(this.x, this.y, this.z, mouseX, mouseY, 0);
        // ellipse(mouseX, mouseY, 5, 5);
    }
}
