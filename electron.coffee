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
    source = new Source(initialSignalName)
    if target.addEventListener
        unbind = -> target.removeEventListener(eventName, soure.handler, false)
        target.addEventListener(eventName, source.emit, false)
    else
        unbind = -> target.removeListener(eventName, source.handler)
        target.addListener(eventName, source.emit)
    source

(this.jQuery || this.Zepto)?.fn.asEventStream = (eventName, initialSignalName) ->
    source = new Source(initialSignalName)
    unbind = -> this.off(eventName, source.emit)
    this.on(eventName, source.emit)
    source


exports = Electron
