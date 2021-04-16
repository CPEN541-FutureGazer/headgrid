import json
import random

from configHelper import *

def generateExpA():
    out_json_name = 'gen_expA.json'
    out = getConfigTemplate()
    out['windowTitle'] = 'FutureGazer Experiment A'
    out['soundFiles'].append('E1_P1_norm.wav')

    N = 9

    # Generate participants
    for i in range(N):
        out['init']['participants'].append(getParticipantObj(
            id=i
        ))

    presenter_id = N // 2
    presenter = [presenter_id]
    listeners = [i for i in range(N) if i != presenter_id]

    # Generate deterministic events
    e = out['events']
    addPlaySoundEvent(e, 0, out['soundFiles'][0])
    addSetWobbleEvent(e, 0, [i for i in range(9)], True)
    addSetFocusedEvent(e, 2111, presenter, True)
    addSetModeEvent(e, 2111, presenter, 'stare')

    # Generate randomize events between 2400 and 3000 for listeners
    for i in range(N):
        if i == presenter_id:
            continue
        
        trigger = random.randint(2400, 3200)
        addSetModeEvent(e, trigger, [i], 'normal')
        addSetViewTargetIdEvent(e, trigger, [i], presenter_id)
    
    # Back to generating predetermined events
    addSetFocusedEvent(e, 15833, presenter, False)
    addSetModeEvent(e, 16000, presenter, 'normal')
    addSetViewTargetIdEvent(e, 16000, presenter, random.choice(listeners))
    addSetViewTargetIdEvent(e, 18800, presenter, random.choice(listeners))
    addSetModeEvent(e, 19400, presenter, 'stare')
    addSetFocusedEvent(e, 19406, presenter, True)
    addSetFocusedEvent(e, 26267, presenter, False)
    addSetModeEvent(e, 27500, presenter, 'normal')
    addSetViewTargetIdEvent(e, 27500, presenter, presenter_id + 1)
    addSetFocusedEvent(e, 30570, presenter, True)
    addSetModeEvent(e, 31000, presenter, 'stare')
    addStopEvent(e, 130000)

    # Add other randomized events throughout
    num_stares = 10
    start = 20000
    end = 120000
    duration_min = 1000
    duration_max = 8000
    for i in range(num_stares):
        target = random.choice(listeners)
        start_trigger = random.randint(start, end - duration_max)
        end_trigger = start_trigger + random.randint(duration_min, duration_max)

        addSetModeEvent(e, start_trigger, [target], 'stare')
        addSetModeEvent(e, end_trigger, [target], 'normal')

    # Finished
    # Sort the event list by trigger time
    sortedEvents = sorted(e, key=lambda k: k['millis'])

    # Replace template with sorted event list
    out['events'] = sortedEvents

    # Dump the file
    with open(out_json_name, 'w') as outfile:
        json.dump(out, outfile, indent=4)

if __name__ == '__main__':
    generateExpA()