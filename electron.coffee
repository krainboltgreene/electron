# Electron
_      = require "underscore"

Signal = require "./lib/signal.coffee"
Bus    = require "./lib/bus.coffee"
Event    = require "./lib/event.coffee"

Electron        = {}
Electron.Bus    = Bus
Electron.Signal = Signal
Electron.Event  = Event

Electron.fromPromise = (promise) ->
    signal = new Signal()
    #onSuccess, onError
    promise.then(signal.emit, signal.emit)
    signal

Electron.fromEventTarget = (target, eventName) ->
    signal = new Signal()
    if target.addEventListener
        unbind = -> target.removeEventListener(eventName, signal.emit, false)
        target.addEventListener(eventName, ((value) -> signal.emit value), false)
    else
        unbind = -> target.removeListener(eventName, signal.emit)
        target.addListener eventName, ((value) -> signal.emit value)
    signal

Electron.fromPoll = (timer = 5000, args..., func) ->
    signal = new Signal()
    setInterval (-> signal.emit(func args...)), timer
    signal

Electron.fromInterval = (timer = 5000, value) ->
    signal = new Signal()
    setInterval (-> signal.emit(value)), timer
    signal

unless module and module.exports
    $      = require "jquery"
    (this.jQuery || this.Zepto)?.fn.asEventStream = (eventName) ->
        signal = new Signal()
        unbind = -> this.off(eventName, signal.emit)
        this.on(eventName, signal.emit)
        signal


module.exports = exports = Electron
