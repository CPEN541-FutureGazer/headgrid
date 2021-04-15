int g_nextViewID = 0;

class View {
    int id;

    float x;
    float y;
    float z;

    float scale;

    boolean isEnabled;
    boolean isFocused;
    Boolean isNoisy;
    Boolean scaleAttention;

    Boolean isProtagonist;

    Boolean trackingMouse;

    float targetX;
    float targetY;

    /* Attention mode */
    AttentionMode attentionMode;

    float lerpRX;
    float lerpRY;

    float noiseFreq = random(0.003, 0.01);

    String name;

    public View(int id, float x, float y) {
        this.id = id;
        this.isEnabled = true;
        this.isFocused = false;
        this.isNoisy = false;
        this.scaleAttention = false;

        isProtagonist = false;

        attentionMode = AttentionMode.ATT_NORMAL;

        trackingMouse = false;

        this.lerpRX = random(0.07, 0.2);
        this.lerpRY = random(0.02, 0.08);

        this.name = "no_name";

        this.setPosition(x, y, 0);
        this.targetX = x;
        this.targetY = y;
    }

    public View(int id, float x, float y, float z) {
        this(id, x, y);
        this.setPosition(x, y, z);
    }

    public void setPosition(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public void setPosition(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public void draw() {
        println("Draw function not implemented.");
    }
}
