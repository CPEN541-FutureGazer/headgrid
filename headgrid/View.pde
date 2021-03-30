int g_nextViewID = 0;

class View {
    final int id;

    float x;
    float y;
    float z;

    float scale;

    boolean isEnabled;
    boolean isFocused;

    public View() {
        this.id = g_nextViewID++;
        this.isEnabled = true;
        this.isFocused = false;
    }

    public View(float x, float y) {
        this();
        this.setPosition(x, y);
    }

    public View(float x, float y, float z) {
        this();
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