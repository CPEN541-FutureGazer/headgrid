def getConfigTemplate():
    return {
        "windowTitle": "Untitled",
        "uiModeControl": True,
        "enableKeyboard": True,
        "displayParticipant": False,
        "partcipantName": "Sherlock Holmes",
        "highlightMouse": False,
        "displayNamePlates": False,
        "initSceneFromConfig": True,
        "showMillis": True,
        "soundFiles": [],
        "init": {
            "participants": []
        },
        "events": []
    }

def strToMode(mode):
    if mode == 'normal':
        return 'ATT_NORMAL'
    elif mode == 'stare':
        return 'ATT_STARE'
    else:
        return 'ATT_RANDOM'

def addSetModeEvent(eventList, time, targetList, mode):
    value = strToMode(mode)
    eventList.append(
        {
            "millis": time,
            "action": "setMode",
            "target": targetList,
            "value": value
        }
    )

def addSetWobbleEvent(eventList, time, targetList, wobbleHead):
    eventList.append(
        {
            "millis": time,
            "action": "setWobble",
            "target": targetList,
            "value": wobbleHead
        }
    )

def addSetViewTargetIdEvent(eventList, time, targetList, targetId):
    eventList.append(
        {
            "millis": time,
            "action": "setViewTargetId",
            "target": targetList,
            "value": targetId
        }
    )

def addSetFocusedEvent(eventList, time, targetList, isFocused):
    eventList.append(
        {
            "millis": time,
            "action": "setFocused",
            "target": targetList,
            "value": isFocused
        }
    )

def addPlaySoundEvent(eventList, time, sound):
    eventList.append(
        {
            "millis": time,
            "action": "playSound",
            "value": sound
        }
    )

def addStopEvent(eventList, time):
    eventList.append(
        {
            "millis": time,
            "action": "stop",
        }
    )

def getParticipantObj(id, name="noname", head3d=True, trackingMouse=False, mode="random"):
    mode_value = strToMode(mode)
    return {
        "id": id,
        "name": name,
        "head3d": head3d,
        "trackingMouse": trackingMouse,
        "mode": mode_value
    }