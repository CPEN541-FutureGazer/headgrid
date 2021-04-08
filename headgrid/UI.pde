enum UIMode { MOCK_ZOOM, UI_CONTROL };

// The UI class that handles user buttons
class UI {
    PImage zoomUI;

    UIMode mode;

    // Quit button
    ButtonView quitButton;
    
    // Participant select mode buttons
    ButtonView noCameraButton;
    ButtonView cameraButton;
    ButtonView avatar2DButton;
    ButtonView avatar3DButton;

    public UI(UIMode mode) {
        this.mode = mode;

        if (this.mode == UIMode.MOCK_ZOOM) {
            this.zoomUI = loadImage("zoomui.jpg");
        }

        int quitButton_w = 100;
        int quitButton_h = 26;
        quitButton = new ButtonView(
            width - quitButton_w - 10,
            height - quitButton_h - (55 - quitButton_h) / 2,
            quitButton_w,
            quitButton_h,
            "Leave"
        );
        quitButton.fill = color(150, 0, 0);
        quitButton.fillOpacity = 255;
        quitButton.hoverFill = color(255, 0, 0);
        quitButton.hoverFillOpacity = 255;

        int buttons_w = 80;
        int buttons_h = 26;
        noCameraButton = new ButtonView(
            10,
            height - buttons_h - (55 - buttons_h) / 2,
            buttons_w,
            buttons_h,
            "No cam"
        );
        cameraButton = new ButtonView(
            2 * 10 + buttons_w,
            height - buttons_h - (55 - buttons_h) / 2,
            buttons_w,
            buttons_h,
            "Cam"
        );
        avatar2DButton = new ButtonView(
            3 * 10 + 2 * buttons_w,
            height - buttons_h - (55 - buttons_h) / 2,
            buttons_w,
            buttons_h,
            "2D eyes"
        );
        avatar3DButton = new ButtonView(
            4 * 10 + 3 * buttons_w,
            height - buttons_h - (55 - buttons_h) / 2,
            buttons_w,
            buttons_h,
            "3D avatar"
        );
    }

    public void draw() {
        if (this.mode == UIMode.MOCK_ZOOM && this.zoomUI != null) {
            image(zoomUI, 0, height - 55, width, 55);
            return;
        }

        // Otherwise, do actual UI handling
        noStroke();
        fill(29);
        rect(0, height - 55, width, 55);

        // Draw buttons
        quitButton.draw();
        noCameraButton.draw();
        cameraButton.draw();
        avatar2DButton.draw();
        avatar3DButton.draw();

        this.update();
    }

    public void update() {
    }

    public void handleMouseClicked() {
        if (quitButton.isMouseHover()) {
            exit();
        }


    }
}

class ButtonView {
    int x;
    int y;
    int w;
    int h;
    color fill;
    int fillOpacity;
    color textFill;
    color hoverFill;
    int hoverFillOpacity;

    String label;

    public ButtonView(int x, int y, int w, int h, String label) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;

        this.label = label;

        this.fill = color(0, 0, 0);
        this.fillOpacity = 0;
        this.textFill = color(255, 255, 255);
        this.hoverFill = color(255, 255, 255);
        this.hoverFillOpacity = 100;
    }

    public Boolean isMouseHover() {
        return (mouseX >= this.x &&
                mouseY >= this.y &&
                mouseX <= this.x + this.w &&
                mouseY <= this.y + this.h);
    }

    public void draw() {
        if (this.isMouseHover()) {
            fill(this.hoverFill, this.hoverFillOpacity);
        } else {
            fill(this.fill, this.fillOpacity);
        }

        rect(this.x, this.y, this.w, this.h);
        textAlign(CENTER, CENTER);
        fill(this.textFill);
        text(this.label, this.x + this.w / 2, this.y + this.h / 2);
    }
}
