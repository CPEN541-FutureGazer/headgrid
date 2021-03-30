
/*
 * The class encapsulates the loaded 3D model / Pshape
 * with its corrected transformation such that it can 
 * display properly
 */
class HeadModel {

    /* The 3D model or PShape */
    PShape model;

    /* The origin xyz */
    float x;
    float y;
    float z;

    /* The original orientation */
    float rx;
    float ry;
    float rz;

    /* Original scale */
    float scale;

    public HeadModel() {
        this.x = 0;
        this.y = 0;
        this.z = 0;

        this.rx = 0;
        this.ry = 0;
        this.rz = 0;

        this.scale = 1.0;
    }

    public HeadModel(PShape shape) {
        this.model = shape;
        this();
    }

    public void draw() {
        pushMatrix();

        translate(this.x, this.y, this.z);
        rotateX(this.rx);
        rotateY(this.ry);
        rotateZ(this.rz);

        scale(this.scale);

        shape(this.model);

        popMatrix();
    }
}