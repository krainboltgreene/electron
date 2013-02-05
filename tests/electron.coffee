EventEmitter = require("events").EventEmitter
chai   = require "chai"
sinon  = require "sinon"
should = chai.should()
jsdom  = require "jsdom"

chai.use(require "sinon-chai")

Electron = require "../electron.coffee"
Event = Electron.Event

describe "Electron", ->

    describe "#fromEventTarget()", ->
        eventEmitter = new EventEmitter()
        reactSpy = sinon.spy()
        Electron.fromEventTarget(eventEmitter, "test").react reactSpy
        eventEmitter.emit("test", "value")
        it "should have called event", ->
            reactSpy.should.have.been.called

    describe "#fromPoll()", ->
        clock = sinon.useFakeTimers()
        testFunction = (event) -> 10
        reactSpy = sinon.spy()
        Electron.fromPoll(1000, testFunction).react reactSpy
        clock.tick(1000)
        clock.tick(1000)
        clock.restore()
        it "should have called reactSpy with Event 10 and have called it twice", ->
            reactSpy.should.have.been.calledWith(new Event(10))
            reactSpy.should.have.been.calledTwice


    describe "#fromInterval()", ->
        clock = sinon.useFakeTimers()
        reactSpyInterval = sinon.spy()
        Electron.fromInterval(1000, 5).react reactSpyInterval
        clock.tick(1000)
        clock.tick(1000)
        clock.restore()
        it "should have called reactSpy twice with Event 5", ->
            reactSpyInterval.should.have.been.calledWith (new Event(5))
            reactSpyInterval.should.have.been.calledTwice

    describe "#fromPromise() - TODO", ->
        it "TODO", ->

# test fromPromise using a promise library
