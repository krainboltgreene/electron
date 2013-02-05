# Electron
_      = require "lodash"

Signal = require "./lib/signal.coffee"
Bus    = require "./lib/bus.coffee"
Event  = require "./lib/event.coffee"

Electron        = {}
Electron.Bus    = Bus
Electron.Signal = Signal
Electron.Event  = Event

Electron.fromEventTarget = (target, eventName) ->
    signal = new Signal()
    handler = ((value) -> signal.emit value)
    if target.addEventListener
        unbind = -> target.removeEventListener eventName, handler, false
        target.addEventListener eventName, handler, false
        #we can't just listen to EVERYTHING and just use meta apparently
    else
        unbind = -> target.removeListener eventName, handler
        target.addListener eventName, handler
    signal

Electron.fromPoll = (timer = 5000, args..., func) ->
    signal = new Signal()
    setInterval (-> signal.emit(func args...)), timer
    signal

Electron.fromInterval = (timer = 5000, value) ->
    signal = new Signal()
    setInterval (-> signal.emit(value)), timer
    signal

Electron.fromPromise = (promise) ->
    signal = new Signal()
    promise.then(((value)-> signal.emit value), ((value) -> signal.emit value, {isError: true}))
    signal

if window
    window.Electron = Electron
    (window.jQuery || window.Zepto)?.fn.asSignal = (eventName) ->
        signal = new Signal()
        unbind = -> @off(eventName, ((value)-> signal.emit value))
        @on(eventName, ((value) -> signal.emit value))
        signal

module.exports = exports = Electron
