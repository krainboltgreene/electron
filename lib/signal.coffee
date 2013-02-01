_  = require "underscore"
ff = (f, args) -> _.bind f, {}, args...

class Signal
    transforms: []
    framesize: 2
    frame: []
    _frame: _(@frame)
    source: null

    # source and transforms are used for the recursive generation of new signals as transforms are contributed
    # we should be able to create signals _without_ sources
    # signals always have a source object that they are bound to - thus we can trace their events
    # why are we keeping track of their sources, who cares, their source doesn't tell you ANYTHING
    # shouldn't adding transforms need to register themselves with the same source in order to get events?
    constructor: (@source, @transforms = [], @framesize = 2) ->
        @framesize = 2 if @framesize < 2

    # create new signal with the added transforms, replace at source, and return the new signal from this function
    addTransform: (tranform) ->
        (new Signal(@source, (@transforms.push(transform)), @framesize))

    # Log everything moving through this
    log: (event) ->
        @addTransform (event) ->
            logger(event)
            event

    # extend signal to overwrite this?
    # this needs to be functional
    logger: (value) ->
        console.log(value)

    replaceLogger: (newFunction) ->
        @logger = newFunction

    # Filter for errors only
    # TODO: We need to wrap events in something so that this can be done properly
    errors: ->
        @filter (value) -> value[0] is "_error"

    # Skip duplicate values
    skipDuplicates: (isEqual = (a, b) -> a is b) ->
        @filter (event) -> isEqual @_frame.initial().last(), event

    # React to values moving through the signal
    react: (args..., f) ->
        @addTranform (event) ->
            ff(f, args)(event) if event

    # Filter values moving through the signal
    filter: (args..., f) ->
        @addTransform (event) ->
            event if ff(f, args)(event) else false

    # Skip number of values moving through the signal
    skip: (count) ->
        @addTransform (event) ->
            _.after(count, (-> event)) # util this function has been called "count" times, don't compute

    span: (size, args..., f) ->
        # captures a range of values using the frame, if larger than frame, defaults to entire frame
        # note that all of these transform functions affect the subsequent ones
        @addTransform (event) ->

    # Send value through all transforms - called whenever a new value is presented - optional callback to 
    propagate : (event, callback) ->
        @frame.push(event)                                      # add event to frame
        @frame.pop() if @frame.length > @framesize              # if over framesize, remove old events
        computed = _.compose((@transforms.reverse())...)(event) # compute all transforms
        callback(computed) if callback                          # if callback is set, call with computed
        this                                                    # return self

    # Change the frame size, the case where you'd like to capture more values within the frame
    changeFrameSize: (size) ->
        @framesize = size # set frame size value
        this              # return self for chaining

    # merge another signal into this signal
    merge: (signal) ->
        signal.react (event) => # set a reaction transform on the other signal
            @propagate(event)        # it routes it's events through this one as well

    # sample by another signal
    sampleBy: (signal) ->
        freshSignal = (new Bus()).createSignal()
        signal.react (event) =>               # when the other signal emits
            bus.emit([_.last(@frame), event]) # emit through the bus the last value of this signal
        freshSignal


exports = Signal
