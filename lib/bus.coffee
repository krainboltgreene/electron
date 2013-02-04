_      = require "underscore"

ff = (f, args) -> _.bind f, {}, args...

# Bus gives a structure to contain and maniuplate multiple signals simultaneously
# it merely aids in keeping track of which is which
# can also be used to organize signals due to this

Signal = require "./signal.coffee"

class Bus
    signals: []

    constructor: (signals...) ->
        @signals = signals

    # add a new signal to the bus
    addSignal: (signal) ->
        @signals.push(signal)
        this

    addSignals: (signals...) ->
            _(signals).each (signal) => @signals.push(signal)

    # call a method on all signals, using the same arguments and function
    all: (method, args..., func) ->
        _(@signals).map (signal) -> signal[method](args..., func)

    # merge all signals into the passed signal - expected to have a source?
    merge: () ->
        newSignal = new Signal()
        _(@signals).each (signal) ->
            signal.react (event) ->
                newSignal.emit(event)
        newSignal

    # pull all signals into a single signal with their values mapped to an array
    join: () ->

        
module.exports = exports = Bus
