lines := File with("input/day7.txt") openForReading readLines

deps := Map clone

lines foreach(line, bits := line split
    start := bits at(1)
    end := bits at(7)
    (deps hasKey(end)) ifFalse(deps atPut(end, List clone))
    deps at(end) append(start))

part1 := method(deps,
    stages := deps values append(deps keys) flatten unique
    loop(next := stages difference(deps keys) sort first
        if(next == nil, "" println; break, next print)
        deps values foreach(d, d remove(next))
        deps = deps select(stage, d, d size > 0)
        stages remove(next)))

part2 := method(deps,
    stages := deps values append(deps keys) flatten unique
    numWorkers := 5
    workers := List clone
    currentTime := 0
    loop(nextAvailable := stages difference(deps keys) sort
        if (nextAvailable isEmpty, break)

        workersAvailable := numWorkers - workers size
        working := workers map(e, e at(2))
        nextStages := nextAvailable select(i, stage, working contains(stage) not)
        nextStages = nextStages slice(0, workersAvailable)

        nextStages foreach(stage, duration := stage at(0) - "A" at(0) + 61
            if(working contains(stage)) ifFalse(
                workers append(list(currentTime + duration, duration, stage))))
        workers sortInPlace

        head := workers removeFirst
        currentTime = head at(0)
        nextDone := head at(2)
        deps values foreach(d, d remove(nextDone))
        deps = deps select(stage, d, d size > 0)
        stages remove(nextDone))
    currentTime println)


depsCopy := deps clone // clone *doesn't* do a deep copy!
depsCopy foreach(key, value, deps atPut(key, value clone))

part1(depsCopy)
part2(deps clone)
