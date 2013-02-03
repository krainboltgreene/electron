# Electron

$      = require "jquery"
_      = require "underscore"

Signal = require "./lib/signal.coffee"
Bus    = require "./lib/bus.coffee"
Source = require "./lib/source.coffee"

Electron = {}

Electron.Bus    = Bus
Electron.Source = Source
Electron.Signal = Signal

Electron.fromPromise = (wut) ->

Electron.fromEventTarget = (target, eventName, initialSignalName) ->
    signal = new Signal()
    if target.addEventListener
        unbind = -> target.removeEventListener(eventName, soure.handler, false)
        target.addEventListener(eventName, signal.emit, false)
    else
        unbind = -> target.removeListener(eventName, signal.emit)
        target.addListener(eventName, signal.emit)
    signal

Electron.fromPoll = (timer = 5000, args..., func) ->
    signal = new Signal()
    setInterval (-> signal.emit(func args...)), timer
    signal

Electron.fromInterval = (timer = 5000, value) ->
    signal = new Signal()
    setInterval (-> signal.emit(value)), timer
    signal



(this.jQuery || this.Zepto)?.fn.asEventStream = (eventName, initialSignalName) ->
    signal = new Signal()
    unbind = -> this.off(eventName, signal.emit)
    this.on(eventName, signal.emit)
    signal


exports = Electron
