chai   = require "chai"
sinon  = require "sinon"
should = chai.should()

chai.use(require "sinon-chai")

_ = require "underscore"

Signal = require "../lib/signal.coffee"
Event  = require "../lib/event.coffee"

describe "Signal", ->

    describe "#constructor()", ->
        signal = new Signal()
        it "should have built a new signal", ->
            signal.should.exist
        it "should have array to hold transforms", ->
            signal.should.have.property "transforms"
        it "should have default frameSize of 2", ->
            signal.should.have.property "frameSize", 2
        it "should have an empty frame array", ->
            signal.should.have.property "frame"
        it "should have a null source property", ->
            signal.should.not.have.property "source"

    describe "#setFrameSize()", ->
        describe "where frame is default size", ->
            signal = new Signal()
            signal.setFrameSize(5)
            it "should have changed the frame size to 5", ->
                signal.frameSize.should.equal 5
        ###
        describe "where frame was larger and populated prior", ->
            signal = new Signal()
            signal.changeFrameSize(5)
            for i in [0..15]
                signal.emit(i)
            signal.changeFrameSize(2)
            it "should have sliced off whatever values were in the frame outside of the new size", ->
        ###
        describe "testing the frame itself after frame size change", ->
            signal = new Signal()
            signal.setFrameSize(5)
            for i in [0..20]
                signal.emit i
            it "should have five values in the frame", ->
                signal.frame.should.have.length 5
            it "should have 15 to 20 events as those values", ->
                signal.frame.toString().should.equal [new Event(i) for i in [16..20]].toString()


    describe "#emit()", ->
        signal = new Signal()
        reactSpy = sinon.spy()
        signal.react reactSpy
        signal.emit 10
        it "should have emitd the value through the signal", ->
            reactSpy.should.have.been.calledWith (new Event(10))

    describe "#addTransform()", ->
        signal = new Signal()
        reactSpy = sinon.spy()
        signal.addTransform reactSpy
        signal.emit(2)
        it "should have added a transform that increases event value by one", ->
            reactSpy.should.have.been.calledWith (new Event(2))

    describe "#react()", ->
        signal = new Signal()
        reactSpy = sinon.spy()
        signal.react reactSpy
        signal.emit(2)
        it "should have called reactSpy with event 2", ->
            reactSpy.should.have.been.called
            reactSpy.should.have.been.calledWith (new Event(2))

    describe "#filter()", ->
        signal = new Signal()
        reactSpy = sinon.spy()
        signal.filter( (event) -> event > 2).react reactSpy
        it "should call reactSpy when filter is matched", ->
            signal.emit(2)
            reactSpy.should.have.been.calledOnce
        it "should not call reactSpy when event does match the filter", ->
            signal.emit(8)
            reactSpy.should.not.have.been.calledOnce

    describe "#skipDuplicates()", ->
        signal = new Signal()
        skipDuplicatesSpy = sinon.spy()
        signal.skipDuplicates().react skipDuplicatesSpy
        it "should react to the first emission", ->
            signal.emit(2)
            skipDuplicatesSpy.should.have.been.calledOnce
        it "should not react to the second identical emission", ->
            signal.emit(2)
            skipDuplicatesSpy.should.have.been.calledOnce
        it "should react to the different third emission", ->
            signal.emit(3)
            skipDuplicatesSpy.should.have.been.calledTwice

    describe "#span()", ->
        signal = new Signal()
        reactSpy = sinon.spy()
        signal.setFrameSize(10).span(5).react reactSpy
        for i in [1..10]
            signal.emit(i)
        it "should react with the frame", ->
            reactSpy.should.have.been.called
            reactSpy.should.have.been.calledWith new Event([6..10])

    describe "#log(logger)", ->
        signal = new Signal()
        logSpy = sinon.spy()
        testingLog = signal.log (event) ->
            logSpy(event.value + "log")
        signal.emit (2)
        it "should be called as a transform when an event passes through the source", ->
            logSpy.should.have.been.calledWith "2log"

    describe "#merge() #mergeInner()", ->
        signalOne = new Signal()
        signalTwo = new Signal()
        reactSpy = sinon.spy()
        signalOne.merge(signalTwo).react reactSpy
        signalTwo.emit "mergeInner"
        it "should cause signalOne to be emit when signalTwo does", ->
            reactSpy.should.have.been.called

    describe "#mergeOuter()", ->
        signalOne = new Signal()
        signalTwo = new Signal()
        reactSpy = sinon.spy()
        signalTwo.react reactSpy
        signalOne.mergeOuter(signalTwo)
        signalOne.emit "mergeOuter"
        it "should cause signalTwo to emit when signalOne does", ->
            reactSpy.should.have.been.called

    describe "#join()", ->
        signalOne = new Signal()
        signalTwo = new Signal()
        reactSpy = sinon.spy()
        signalOne.join(signalTwo).react reactSpy
        signalOne.emit(2).emit(3).emit(4)
        signalTwo.emit 3
        it "should only react when signalTwo emits, and then it should take the last value of signalOne", ->
             reactSpy.should.have.been.calledWith new Event([4, 3])

    describe "#kill()", ->
        signal = new Signal()
        reactSpy = sinon.spy()
        signal.react reactSpy
        signal.kill()
        signal.emit 3
        it "prevent all emits from touching any reactors or causing any computation", ->
             reactSpy.should.not.have.been.called
