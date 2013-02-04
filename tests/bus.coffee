chai   = require "chai"
sinon  = require "sinon"
should = chai.should()

chai.use(require "sinon-chai")

Bus    = require "../lib/bus.coffee"
Signal = require "../lib/signal.coffee"
Event  = require "../lib/event.coffee"

describe "Bus", ->

    describe "#constructor()", ->
        bus = new Bus()
        it "should have a property signals", ->
            bus.should.have.property "signals"

    describe "#addSignal()", ->
        bus = new Bus()
        signal = new Signal()
        bus.addSignal signal
        it "should add a new signal into the bus signal array", ->
            bus.signals.should.have.length 1
            bus.signals[0].should.equal signal

    describe "#addSignals()", ->
        bus = new Bus()
        signal = new Signal()
        signalOne = new Signal()
        signalTwo = new Signal()
        bus.addSignals signal, signalOne, signalTwo
        it "should have added all three signals to the bus", ->
            bus.signals.should.have.length 3

    describe "#all()", ->
        bus = new Bus()
        signalOne = new Signal()
        signalTwo = new Signal()
        bus.addSignals(signalOne, signalTwo)
        allSpy = sinon.spy()
        bus.all "react", allSpy
        bus.all "emit", 3
        it "should call an existing method for each available signal", ->
            allSpy.should.have.been.calledWith (new Event(3))

    describe "#merge()", ->
        bus = new Bus()
        signalOne = new Signal()
        signalTwo = new Signal()
        bus.addSignals(signalOne, signalTwo)
        mergedSpy = sinon.spy()
        bus.merge().react mergedSpy
        signalOne.emit 4
        signalTwo.emit 4
        it "should merge all signals into a single resulting signal", ->
            mergedSpy.should.have.been.calledTwice

