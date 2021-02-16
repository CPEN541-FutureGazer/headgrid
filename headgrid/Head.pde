class Head {

    float x;
    float y;
    
    float rotX;
    float rotZ;

    boolean tracking;

    public Head(float x, float y) {
        this.x = x;
        this.y = y;
        
        this.rotX = 0;
        this.rotZ = 0;

        this.tracking = true;
    }

    public void draw() {
        pushMatrix();
        translate(this.x, this.y);
        pushMatrix();
        scale(10);
        
        rotateX(HALF_PI);

        if (this.tracking) {
            float diffX = mouseX - this.x;
            float diffY = mouseY - this.y;

            float targetRZ = map(diffX, -width / 2, width / 2, HALF_PI, - HALF_PI);
            float targetRX = map(diffY, -height / 2, height / 2, PI / 6, - PI / 6);
            
            this.rotZ = lerp(this.rotZ, targetRZ, 0.2);
            this.rotX = lerp(this.rotX, targetRX, 0.1);
            
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
        // text("(" + str(mouseX) + ", " + str(mouseY) + ")", 80, - 20);
        // strokeWeight(3);
        // stroke(255, 0, 0);
        // line(0, 0, 100, 0);
        // stroke(0, 255, 0);
        // line(0, 0, 0, 100);
        popMatrix();


        if (!this.tracking) return;
        strokeWeight(1);
        stroke(255, 0, 255);
        line(this.x, this.y, mouseX, mouseY);
        ellipse(mouseX, mouseY, 5, 5);
    }
}
