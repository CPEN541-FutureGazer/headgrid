import json
import random

from configHelper import *

def generateExpA(filename, head3d=True):
    out_json_name = filename
    out = getConfigTemplate()
    out['windowTitle'] = 'FutureGazer Experiment A'
    out['soundFiles'].append('E1_P1_norm.wav')

    N = 9

    # Generate participants
    for i in range(N):
        out['init']['participants'].append(getParticipantObj(
            id=i,
            head3d=head3d
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

def generateExpB(filename, head3d=True):
    out_json_name = filename
    out = getConfigTemplate()
    out['windowTitle'] = 'FutureGazer Experiment B'
    out['soundFiles'].append('E2_P1_norm.wav')

    N = 9

    # Generate participants
    for i in range(N):
        out['init']['participants'].append(getParticipantObj(
            id=i,
            head3d=head3d
        ))

    presenter_id = N // 2
    presenter = [presenter_id]
    listeners = [i for i in range(N) if i != presenter_id]

    # Generate deterministic events
    e = out['events']
    addPlaySoundEvent(e, 0, out['soundFiles'][0])
    addSetWobbleEvent(e, 0, [i for i in range(N)], True)

    # Focus modes
    addSetFocusedEvent(e, 4121, presenter, True)
    addSetFocusedEvent(e, 6534, presenter, False)
    addSetFocusedEvent(e, 8092, presenter, True)
    addSetFocusedEvent(e, 10404, presenter, False)
    addSetFocusedEvent(e, 11710, presenter, True)
    addSetFocusedEvent(e, 12012, presenter, False)
    addSetFocusedEvent(e, 13268, presenter, True)
    addSetFocusedEvent(e, 73227, presenter, False)
    addSetFocusedEvent(e, 75137, presenter, True)

    # End
    addStopEvent(e, 130000)

    # When presenter starts talking, make everyone focus
    for i in range(N):
        if i == presenter_id:
            continue
        
        trigger = random.randint(4200, 5000)
        addSetModeEvent(e, trigger, [i], 'normal')
        addSetViewTargetIdEvent(e, trigger, [i], presenter_id)
    
    # Add other randomized events throughout
    num_stares = 10
    start = 6000
    end = 110000
    duration_min = 5000
    duration_max = 20000
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

def generateExpC(filename, head3d=True):
    out_json_name = filename
    out = getConfigTemplate()
    out['windowTitle'] = 'FutureGazer Experiment C'

    N = 5

    # Generate participants
    for i in range(N):
        out['init']['participants'].append(getParticipantObj(
            id=i,
            mode='stare',
            head3d=head3d
        ))

    presenter_id = -1
    listeners = [i for i in range(N)]

    # Generate deterministic events
    e = out['events']
    addSetWobbleEvent(e, 0, [i for i in range(N)], True)

    # End (set to 5 minutes)
    addStopEvent(e, 5 * 60 * 1000)
    
    # Add other randomized events throughout
    num_stares = 30
    start = 5000
    end = 200000
    duration_min = 3000
    duration_max = 20000
    for i in range(num_stares):
        target = random.choice(listeners)
        viewTarget = random.choice([l for l in listeners if l != target])
        start_trigger = random.randint(start, end - duration_max)
        end_trigger = start_trigger + random.randint(duration_min, duration_max)

        addSetModeEvent(e, start_trigger, [target], 'normal')
        addSetViewTargetIdEvent(e, start_trigger, [target], viewTarget)
        addSetModeEvent(e, end_trigger, [target], 'stare')

    # Finished
    # Sort the event list by trigger time
    sortedEvents = sorted(e, key=lambda k: k['millis'])

    # Replace template with sorted event list
    out['events'] = sortedEvents

    # Dump the file
    with open(out_json_name, 'w') as outfile:
        json.dump(out, outfile, indent=4)

def generateExpD(filename, head3d=True):
    out_json_name = filename
    out = getConfigTemplate()
    out['windowTitle'] = 'FutureGazer Experiment D'
    out['soundFiles'].append('E4_norm.wav')

    N = 4

    # Generate participants
    for i in range(N):
        out['init']['participants'].append(getParticipantObj(
            id=i,
            head3d=head3d
        ))

    def getListener(presenter_id):
        return [i for i in range(N) if i != presenter_id]

    def addEventsTurnTowardsPresenter(presenter_id, start, end, presenterStare=True, ignore=[]):
        if (presenterStare):
            addSetModeEvent(e, start, [presenter_id], 'stare')
        for i in getListener(presenter_id):
            if i in ignore:
                continue
            trigger = random.randint(start, end)
            addSetModeEvent(e, trigger, [i], 'normal')
            addSetViewTargetIdEvent(e, trigger, [i], presenter_id)

    # Generate deterministic events
    e = out['events']
    addPlaySoundEvent(e, 0, out['soundFiles'][0])
    addSetWobbleEvent(e, 0, [i for i in range(N)], True)

    # Determined events
    addSetFocusedEvent(e, 11284, [0], True)
    addEventsTurnTowardsPresenter(0, 11300, 13500)
    addSetFocusedEvent(e, 22674, [0], False)
    addSetFocusedEvent(e, 23085, [0], True)
    addSetFocusedEvent(e, 26009, [0], False)
    addSetFocusedEvent(e, 27394, [1], True)
    addEventsTurnTowardsPresenter(1, 27600, 30000)
    addSetFocusedEvent(e, 48067, [1], False)
    addSetFocusedEvent(e, 49298, [2], True)
    addEventsTurnTowardsPresenter(2, 49300, 52000)
    addSetFocusedEvent(e, 72947, [2], False)
    addSetFocusedEvent(e, 74486, [1], True)
    addEventsTurnTowardsPresenter(1, 74500, 75000, False)
    addSetFocusedEvent(e, 80283, [1], False)
    addSetFocusedEvent(e, 80847, [2], True)
    addEventsTurnTowardsPresenter(2, 80900, 82000, False)
    addSetFocusedEvent(e, 97520, [2], False)
    addSetFocusedEvent(e, 98084, [1], True)
    addEventsTurnTowardsPresenter(2, 98000, 99500, False)
    addSetFocusedEvent(e, 108190, [1], False)
    addSetFocusedEvent(e, 109575, [3], True)
    addEventsTurnTowardsPresenter(3, 109800, 110500)

    # End
    addStopEvent(e, 140000)
    
    # Finished
    # Sort the event list by trigger time
    sortedEvents = sorted(e, key=lambda k: k['millis'])

    # Replace template with sorted event list
    out['events'] = sortedEvents

    # Dump the file
    with open(out_json_name, 'w') as outfile:
        json.dump(out, outfile, indent=4)

if __name__ == '__main__':
    generateExpA('gen_expA.json')
    generateExpB('gen_expB.json')
    generateExpC('gen_expC.json')
    generateExpD('gen_expD.json')

    generateExpA('gen_expE_A.json', head3d=False)
    generateExpB('gen_expE_B.json', head3d=False)
    generateExpC('gen_expE_C.json', head3d=False)
    generateExpD('gen_expE_D.json', head3d=False)
