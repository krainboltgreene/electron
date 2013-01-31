_      = require "underscore"
Signal = require "./Signal.coffee"
Bus    = require "./Bus.coffee"

class Source
    signals: []
    named: {}
    ended: false

    constructor: () ->
        #no initial signal we need to create one

    createSignal: (name) ->
        @named[name] = new Signal(this) if name else new Signal(this)

    # handle the emission of events from the source, propagating to signals, can also be used manually
    emit: (event) ->
        _(@signals).map (signal) ->
            signal.propagate(event)

    # poll a function with arguments and propagate the results
    poll: (timer = 5000, args..., func) ->
        setInterval ->
            _(@signals).map (signal) ->
                signal.propagate (func args...) 
        , timer

    # emit a value on an interval
    interval: (timer = 5000, value) ->
        @poll timer, value

    # remove all signals and their listeners, send died to all signals
    kill: () ->


exports = Source
