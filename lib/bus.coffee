_      = require "underscore"
Source = require "./Source.coffee"

ff = (f, args) -> _.bind f, {}, args...

# Bus gives a structure to contain and maniuplate multiple signals simultaneously
# it merely aids in keeping track of which is which
# can also be used to organize signals due to this

class Bus extends Source
    signals: []

    constructor: (signalsObj) ->
        _.extend @signals, signalsObj

    # add a new signal to the bus
    addSignal: (signal) ->
        @signals.push(signal)

    # call a method on all signals, using the same arguments and function
    all: (method, args..., func) ->
        _(@signals).map (signal) ->
            signal[method](args..., func)

    # merge all signals into the passed signal - expected to have a source?
    merge: () ->
        newSignal = new Signal(this)
        _(@signals).map (signal) ->
            signal.react (event) ->
                newSignal.emit(evet)
        
exports = Bus
