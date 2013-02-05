EventEmitter = require("events").EventEmitter
chai   = require "chai"
sinon  = require "sinon"
#phantom = require "phantom"
should = chai.should()

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

###
    describe "browser dependent tests -- ", ->
        before (done) ->
            phantom.create (ph) ->

        describe "#fromPromise()", ->
            ph.createPage (page) ->
                page.include

        describe "#asEventStream()", ->
            ph.createPage (page) ->
                page.includeJs("") #include jquery 
                page.includeJs("") #include underscore 
                page.injectJs #inject Electron
                test = page.evaluate #evaluate test
            it "should", ->
            ###
