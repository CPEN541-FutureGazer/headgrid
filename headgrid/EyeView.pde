/* Like implementation of x-eyes */

class EyeView extends View {

    float targetX = 0;
    float targetY = 0;

    PGraphics eyeTexture;
    PGraphics eyeMask;

    float eyeLeftX = -4.0;
    float eyeRightX = 4.0;
    float eyeY = 0.0;
    float eyeHeightR = 5.0;
    float eyeWidthR = 8.0;
    float scaleFactor = 32;
    float pupilRadius;

    final int eyeTextureWidth = int(16 * this.scaleFactor);
    final int eyeTextureHeight = int(16 * this.scaleFactor);

    public EyeView(float x, float y) {
        super(x, y);

        this.pupilRadius = 1.0;


        /* Create eye mask */
        this.createEyeMask();
    }

    void createEyeMask() {
        float r1 = this.eyeHeightR * scaleFactor;
        float r2 = this.eyeWidthR * scaleFactor;
        eyeMask = createGraphics(eyeTextureWidth, eyeTextureHeight);
        eyeMask.beginDraw();
        eyeMask.background(0);
        // noStroke();
        eyeMask.fill(255);
        eyeMask.ellipse(eyeTextureWidth / 2, eyeTextureWidth / 2, r2, r1);
        eyeMask.endDraw();
    }

    void drawEyeTexture() {

        /* Find distance and vector to target position */
        PVector diff = new PVector(this.targetX - this.x, this.targetY - this.y);
        diff.mult(0.3);

        eyeTexture = createGraphics(eyeTextureWidth, eyeTextureHeight);
        eyeTexture.beginDraw();
        eyeTexture.background(255);

        /* Draw pupils */
        float r = 3.0 * scaleFactor;
        float rp = this.pupilRadius * scaleFactor;

        eyeTexture.pushMatrix();
        float offsetXBound = this.eyeWidthR * scaleFactor * 0.4;
        float offsetX = constrain(diff.x, -offsetXBound, offsetXBound);
        float offsetYBound = this.eyeHeightR * scaleFactor * 0.4;
        float offsetY = constrain(diff.y, -offsetYBound, offsetYBound);
        eyeTexture.translate(eyeTextureWidth / 2 + offsetX, eyeTextureWidth / 2 + offsetY);
        eyeTexture.fill(60, 40, 20);
        eyeTexture.ellipse(0, 0, r, r);
        eyeTexture.fill(0);
        eyeTexture.ellipse(0, 0, rp, rp);
        eyeTexture.popMatrix();

        eyeTexture.endDraw();
    }

    @Override
    public void draw() {

        targetX = mouseX;
        targetY = mouseY;

        pushMatrix();
        translate(this.x, this.y);

        float targetScale = this.scale;
        if (this.scaleAttention) {
            // TODO
            targetScale += 0.0;
        }
        scale(targetScale);

        this.drawEyeTexture();
        this.eyeTexture.mask(this.eyeMask);
        image(this.eyeTexture, -8, -8, 16, 16);

        if (this.isFocused) {
            drawFocused();
        }

        popMatrix();
    }
}
