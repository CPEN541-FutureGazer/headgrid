class View {
    private static int nextId = 0;
    final int id;

    float x;
    float y;
    float z;

    float scale;

    boolean isTracking;
    boolean isFocused;
    boolean isDebug;

    public View() {
        this.id = this.nextId++;
        this.isTracking = true;
        this.isFocused = false;
        this.isDebug = false;
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