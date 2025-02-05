//import processing.video.*;
import processing.sound.*;
import java.util.Map;

/* Config file path */
final String TEST_CONFIG = "config.json";

final String EXP_A_CONFIG = "experimentConfigs/gen_expA.json";
final String EXP_B_CONFIG = "experimentConfigs/gen_expB.json";
final String EXP_C_CONFIG = "experimentConfigs/gen_expC.json";
final String EXP_D_CONFIG = "experimentConfigs/gen_expD.json";

final String EXP_EA_CONFIG = "experimentConfigs/gen_expE_A.json";
final String EXP_EB_CONFIG = "experimentConfigs/gen_expE_B.json";
final String EXP_EC_CONFIG = "experimentConfigs/gen_expE_C.json";
final String EXP_ED_CONFIG = "experimentConfigs/gen_expE_D.json";

/* Whatever config we're testing right now */
String ACTIVE_CONFIG = EXP_ED_CONFIG;

JSONObject config;
JSONArray events;
int eventIndex = 0;

HeadModel head;

int gid = 0;
Boolean g_debug = false;
Boolean g_highlightMouse = false;
boolean g_displayNamePlates = true;
Boolean g_enableKeyboard = true;

AddType g_addType = AddType.ADD_HEAD;

ArrayList<View> g_views;

String g_participantName = "Sherlock Holmes";

/* Whether to show milliseconds on the debug screen */
boolean g_showMillis;

/* Use this to offset the millis() function because millis() don't account for load times */
int g_millisOffset = 0;
int g_additionalMillisOffset = 3000;

/* Wrapper function for millis that applies the offset */
int ms() {
    return millis() - g_millisOffset - g_additionalMillisOffset;
}

PGraphics nameOverlayImage;

// self viwe mode:
// 0 - no view (name only)
// 1 - camera
// 2 - avatar (3d head)
// 3 - avatar (2d eyes)
int g_selfViewMode;

UI g_uiControl;

PImage zoomUI;

//Capture webcam;

Boolean g_finished = false;
Boolean g_started = false;

/* Sound files */
HashMap<String, SoundFile> soundFilesMap = new HashMap<String, SoundFile>();

void settings() {
    size(1280, 720, P3D);
}

void setup() {
    config = loadJSONObject(ACTIVE_CONFIG);

    surface.setTitle(config.getString("windowTitle"));

    background(33);
    head = loadHead(0);

    g_views = new ArrayList<View>(); 
    
    // WIP: webcam capture
    //String[] cameras = Capture.list();
    //if (cameras.length == 0) {
    //    println("No cameras"); //<>// //<>// //<>//
    //} else {
    //    for (int i = 0; i < cameras.length; i++) {
    //        println(cameras[i]);
    //    }

    //    webcam = new Capture(this, cameras[1]);
    //}

    if (config.getBoolean("uiModeControl")) {
        g_uiControl = new UI(UIMode.UI_CONTROL);
    } else  {
        g_uiControl = new UI(UIMode.MOCK_ZOOM);
    }

    g_highlightMouse = config.getBoolean("highlightMouse");
    g_displayNamePlates = config.getBoolean("displayNamePlates");

    g_enableKeyboard = config.getBoolean("enableKeyboard");

    //g_showMillis = config.getBoolean("showMillis");
    g_showMillis = false;

    JSONArray configParticipants = config.getJSONObject("init").getJSONArray("participants");
    populateSceneWithConfig(configParticipants);

    /* Load sound files */
    JSONArray sounds = config.getJSONArray("soundFiles");
    for (int i = 0; i < sounds.size(); i++) {
        String soundFileName = sounds.getString(i);
        SoundFile newSound = new SoundFile(this, "sounds/" + soundFileName);
        soundFilesMap.put(soundFileName, newSound);
    }

    events = config.getJSONArray("events");

    /* Finished setting up; reset millis offset */
}

void draw() {
    if (!g_started) return;
    
    background(33);
    fill(255);
    noStroke();

    if (g_showMillis) {
        textAlign(LEFT, TOP);
        text(int(frameRate) + " fps : " + str(ms()) + " ms", 20, 20);
    }
    
    lights();
    directionalLight(255, 255, 255, 0, 1, - 1);

    if (g_highlightMouse) {
        lightFalloff(1.0, 0.005, 0.0001);
        pointLight(50, 255, 100, mouseX, mouseY, 100);
    }

    // draw UI control
    g_uiControl.draw();

    // finished?
    if (g_finished) {
        textSize(40);
        text("Experiment ended.", width / 2, height / 2 - 40);
        text("Press \"Leave\" button to finish.", width / 2, height / 2 + 10);
        textSize(14);
        return;
    }
    
    /* Draw */
    for (View v : g_views) {
        v.draw();
    }

    if (g_displayNamePlates) {
        float nameOffsetZ = 150;
        float scaleOffset = -0.00145 * nameOffsetZ + 1;
        scale(scaleOffset);
        translate(164, 88, nameOffsetZ);
        if (nameOverlayImage != null) {
            image(nameOverlayImage, 0, 0, width, height);
        }   
    }

    /* Execute potential events happening on this frame */
    while(executeNextEvent(ms()));
}

void populateSceneWithConfig(JSONArray arr) {
    for (int i = 0; i < arr.size(); i++) {
        JSONObject p = arr.getJSONObject(i);

        int newId = p.getInt("id");
        String newName = p.getString("name");
        Boolean is3D = p.getBoolean("head3d");

        Boolean trackMouse = false;
        try {
            trackMouse = p.getBoolean("trackingMouse");
        } catch (Exception e) {
        }
        
        String modeStr = p.getString("mode");
        AttentionMode newMode;
        if (modeStr.equals("ATT_NORMAL")) {
            newMode = AttentionMode.ATT_NORMAL;
        } else if (modeStr.equals("ATT_STARE")) {
            newMode = AttentionMode.ATT_STARE;
        } else if (modeStr.equals("ATT_RANDOM")) {
            newMode = AttentionMode.ATT_RANDOM;
        } else {
            println("Invalid mode for id=" + str(newId));
            continue;
        }

        // create the object and add it to view/scene
        View newView;
        if (is3D) {
            newView = new HeadView(newId, head, 0, 0);
        } else {
            newView = new EyeView(newId, 0, 0);
        }

        newView.name = newName;
        newView.attentionMode = newMode;

        newView.trackingMouse = trackMouse;
        if (trackMouse) {
            newView.attentionMode = AttentionMode.ATT_NORMAL;
        }

        g_views.add(newView);
    }

    arrangeViews();
}

// executes the pre-programmed event imported from the config file
Boolean executeNextEvent(int time_ms) {
    if (events.size() == 0 || eventIndex == events.size()) {
        return false;
    }

    JSONObject nextEvent = events.getJSONObject(eventIndex);
    int nextFrame = nextEvent.getInt("millis");

    /* Return if the time millis hasn't been reached */
    if (nextFrame > time_ms) {
        return false;
    }

    String action = nextEvent.getString("action");

    if (action.equals("setMode")) {
        String modeStr = nextEvent.getString("value");

        AttentionMode newMode = AttentionMode.ATT_NORMAL;
        if (modeStr.equals("ATT_NORMAL")) {
            newMode = AttentionMode.ATT_NORMAL;
        } else if (modeStr.equals("ATT_STARE")) {
            newMode = AttentionMode.ATT_STARE;
        } else if (modeStr.equals("ATT_RANDOM")) {
            newMode = AttentionMode.ATT_RANDOM;
        }

        JSONArray targets = nextEvent.getJSONArray("target");
        for (int i = 0; i < targets.size(); i++) {
            int id = targets.getInt(i);

            // FIXME: not the most effiicent way but whatever
            for (View v: g_views) {
                if (v.id == id) {
                    v.attentionMode = newMode;
                    break;
                }
            }
        }
    } else if (action.equals("setWobble")) {
        Boolean wobble = nextEvent.getBoolean("value");

        JSONArray targets = nextEvent.getJSONArray("target");
        for (int i = 0; i < targets.size(); i++) {
            int id = targets.getInt(i);

            // FIXME: not the most effiicent way but whatever
            for (View v: g_views) {
                if (v.id == id) {
                    v.isNoisy = wobble;
                    break;
                }
            }
        }
    } else if (action.equals("setViewTargetId")) {
        int viewTargetId = nextEvent.getInt("value");

        float targetX = 0;
        float targetY = 0;
        for (View v : g_views) {
            if (v.id == viewTargetId) {
                targetX = v.x;
                targetY = v.y;
                break;
            }
        }

        JSONArray targets = nextEvent.getJSONArray("target");
        for (int i = 0; i < targets.size(); i++) {
            int id = targets.getInt(i);

            // FIXME: not the most effiicent way but whatever
            for (View v: g_views) {
                if (v.id == id) {
                    v.targetX = targetX;
                    v.targetY = targetY;
                    break;
                }
            }
        }
    } else if (action.equals("setFocused")) {
        Boolean focus = nextEvent.getBoolean("value");

        JSONArray targets = nextEvent.getJSONArray("target");
        for (int i = 0; i < targets.size(); i++) {
            int id = targets.getInt(i);

            // FIXME: not the most effiicent way but whatever
            for (View v: g_views) {
                if (v.id == id) {
                    v.isFocused = focus;
                    break;
                }
            }
        }

    } else if (action.equals("playSound")) {
        String sound = nextEvent.getString("value");
        soundFilesMap.get(sound).play();

    } else if (action.equals("stop")) {
        println("Stopped!");
        g_finished = true;
    } else {
        println("Error, unidentified action: " + action);
        return false;
    }

    eventIndex++;

    /* Return true as there could be more incoming events */
    return true;
}
