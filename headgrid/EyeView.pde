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
    float eyeWidthR = 7.0;
    float scaleFactor = 8;
    float pupilRadius;

    final int eyeTextureWidth = int(16 * this.scaleFactor);
    final int eyeTextureHeight = int(16 * this.scaleFactor);

    int blinkTimer;

    public EyeView(float x, float y) {
        super(x, y);

        this.pupilRadius = 1.0;

        /* Create eye mask and texture */
        this.eyeTexture = createGraphics(eyeTextureWidth, eyeTextureHeight);
        this.createEyeMask();

        this.resetBlinkTimer();
    }

    void resetBlinkTimer() {
        blinkTimer = int(random(30, 600));
    }

    void createEyeMask() {
        float r1 = this.eyeHeightR * scaleFactor;
        float r2 = this.eyeWidthR * scaleFactor;
        eyeMask = createGraphics(eyeTextureWidth, eyeTextureHeight);
        eyeMask.beginDraw();
        eyeMask.background(0);
        eyeMask.fill(255);
        eyeMask.ellipse(eyeTextureWidth / 2, eyeTextureWidth / 2, r2, r1);
        eyeMask.endDraw();
    }

    void drawEyeTexture() {

        if (this.blinkTimer <= 0) {
            eyeTexture.beginDraw();
            eyeTexture.background(0);
            eyeTexture.endDraw();
            return;
        }

        /* Find distance and vector to target position */
        PVector diff = new PVector(this.targetX - this.x, this.targetY - this.y);
        diff.mult(0.3);

        eyeTexture.beginDraw();
        eyeTexture.background(255);

        /* Draw pupils */
        float r = 3.0 * scaleFactor;
        float rp = this.pupilRadius * scaleFactor;

        eyeTexture.pushMatrix();
        float offsetXBound = this.eyeWidthR * scaleFactor * 0.3;
        float offsetX = constrain(diff.x, -offsetXBound, offsetXBound);
        float offsetYBound = this.eyeHeightR * scaleFactor * 0.3;
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

        switch (this.attentionMode) {
            case ATT_NORMAL:
                targetX = mouseX;
                targetY = mouseY;
                break;
            case ATT_STARE:
                targetX = this.x;
                targetY = this.y;
                break;
            case ATT_RANDOM:
                float randomR = map(noise(frameCount * 0.01 + this.id), 0, 1, 0, width / 2);
                float randomTheta = map(noise(frameCount * 0.01 + this.id), 0, 1, 0, TWO_PI);
                targetX = this.x + randomR * cos(randomTheta);
                targetY = this.y + randomR * sin(randomTheta);
                break;
        }

        if (this.isNoisy) {
            targetX += (2 * noise(this.x + frameCount * this.noiseFreq) - 1) * 200;
            targetY += (2 * noise(this.y + frameCount * this.noiseFreq) - 1) * 100;
        }

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
        image(this.eyeTexture, -8 + this.eyeLeftX, -8 + this.eyeY, 16, 16);
        image(this.eyeTexture, -8 + this.eyeRightX, -8 + this.eyeY, 16, 16);

        if (this.isFocused) {
            drawFocused();
        }

        popMatrix();

        this.blinkTimer--;

        if (this.blinkTimer < -5) {
            this.resetBlinkTimer();
        }
    }
}
