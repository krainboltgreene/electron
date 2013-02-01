_      = require "underscore"
Signal = require "./signal.coffee"
Bus    = require "./bus.coffee"

class Source
    signals: []
    named: {}
    ended: false

    # create new source
    constructor: (signalName) ->
        @createSignal(signalName)
        return this

    # create new signal and add to this source
    createSignal: (signalName) ->
        signal = new Signal(this)
        if signalName
            @signals.push signal
            @named[name] = signal
        else
            @signals.push signal
        return signal


    # handle the emission of events from the source, propagating to signals, can also be used manually
    emit: (event) ->
        _(@signals).map (signal) ->
            signal.propagate(event)
        return this #allow emission chaining

    # these are probbably things that belong in electron for generating sources
    # poll a function with arguments and propagate the results
    poll: (timer = 5000, args..., func) ->
        setInterval (-> @emit func args...), timer

    # emit a value on an interval
    interval: (timer = 5000, value) ->
        setInterval (-> value), timer

    # remove all signals and their listeners, send kill to all signals
    kill: () ->
        @signals = _(@signals).map (signal) ->
            signal.propagate ("_commitsudoku") #tell all signals that they need to die
        @signals = []


exports = Source
