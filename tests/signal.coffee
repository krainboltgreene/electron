chai   = require "chai"
sinon  = require "sinon"
should = chai.should()

chai.use(require "sinon-chai")

Source = require "../source.coffee"
Signal = require "../signal.coffee"

describe "Signal", ->

    beforeEach ->
        source = new Source()
        signal = new Signal()
        signalFromSource = source.createSignal()

    describe "#constructor()", ->
        it "should have built a new signal", ->
            signal.should.exist
        it "should have an empty array of transforms", ->
            signal.should.have.property "transforms", []
        it "should have default framesize of 2", ->
            signalFromSource.should.have.property "frameSize", 2
        it "should have an empty frame array", ->
            signal.should.have.property "frame", []
        it "should have a null source property", ->
            signal.should.have.property "source", null

    describe "#constructor(source)", ->
        it "should have built a new signal", ->
            signalFromSource.should.exist
        it "should have an empty array of transforms", ->
            signalFromSource.should.have.property "transforms", []
        it "should have default framesize of 2", ->
            signalFromSource.should.have.property "frameSize", 2
        it "should have an empty frame array", ->
            signalFromSource.should.have.property "frame", []
        it "should have the source that initalized it in it's source property", ->
            signalFromSource.should.have.property "source", source

    describe "#propagate()", ->
        before ->
            reactSpy = sinon.spy()
            signal.react reactSpy
        it "should have propagated the value through the signal", ->
            signal.propagate 10
            reactSpy.should.have.been.callWith 10

    describe "#addTransform()", ->
        before ->
            signalFromSource.addTransform (event) ->
                event++
        it "should have added a transform that increases event value by one", ->
            source.emit(2)
            signalFromSource._frame.last().should.equal 3

    describe "#replaceLogger()", ->
        before ->
            newLogger = (value, callback) ->
                callback(value + "log")
            signalFromSource.replaceLogger newLogger
        it "should have replaced the logger function with newLogger", ->
            signalFromSource.logger.should.equal newLogger

    describe "#logger()", -> # I am currently unsure how to property test the default state of this

    # this test could be more thorough, I'm sure many can, but mostly this one
    describe "#log()", ->
        before ->
            logSpy = sinon.spy()
            newLogger = (value) ->
                logSpy(value + "log")
            signalFromSource.replaceLogger newLogger
            testingLog = signalFromSource.log()
        it "should be called as a transform when an event passes through the source", ->
            source.emit (2)
            logSpy.should.have.been.calledWith "2log"

    # needs more work on signals and event management
    describe "#errors()", ->

    describe "#react()", ->
        before ->
            reactSpy = sinon.spy()
            signalFromSource.react reactSpy
        it "should call reactSpy with event when an event passes through it", ->
            source.emit(2)
            reactSpy.should.have.been.called

    describe "#skipDuplicates()", ->
        before ->
            skipDuplicatesSpy = sinon.spy()
            signalFromSource.skipDuplicates().react skipDuplicatesSpy
        it "should react to the first emission"
            source.emit(2)
            skipDuplicatesSpy.should.have.been.calledOnce
        it "should not react to the second identical emission"
            source.emit(2)
            skipDuplicatesSpy.should.have.been.calledOnce
        it "should react to the different third emission"
            source.emit(3)
            skipDuplicatesSpy.should.have.been.calledTwice

    describe "#filter()", ->
        before ->
            reactSpy = sinon.spy()
            signalFromSource.react reactSpy
        it "should call reactSpy with event when an event passes through it", ->
            source.emit(2)
            reactSpy.should.have.been.called

    describe "#skip()", ->
        before ->
            reactSpy = sinon.spy()
            signalFromSource.skip(2).react reactSpy
        it "should not call reactSpy until it has been called twice", ->
            source.emit(1)
            source.emit(2)
            source.emit(3)
            reactSpy.should.have.been.calledOnce

    # not yet implemented
    describe "#span()", ->
        before ->

    describe "#changeFrameSize()", ->
        before ->
            signalFromSource.changeFrameSize(5)
        it "should have changed the frame size to 5", ->
            signalFromSource.framesize.should.equal 5

    describe "#changeFrameSize() where frame was larger and populated prior", ->
        before ->
            signalFromSource.changeFrameSize(5)
            for i in 0..15
                source.emit(i)
            signalFromSource.changeFrameSize(2)
         it "should have sliced off whatever values were in the frame outside of the new size", ->


    describe "#merge()", ->
        before ->


    describe "#sampleBy()", ->
        before ->
