chai   = require "chai"
sinon  = require "sinon"
should = chai.should()

chai.use(require "sinon-chai")

Source = require "../lib/source.coffee"

describe "Source", ->

    beforeEach ->
        clock  = sinon.useFakeTimers()
        source = new Source()

    afterEach ->
        source.kill()
        clock.restore()

    describe "#constructor()", ->
        it "should have one initial signal in the signals array", ->
            source.should.have.property("signals").with.length(1)
        it "should have an empty object for named signals", ->
            source.should.have.property("named", {})
        it "should not have ended", ->
            source.should.have.property("ended", false)

    describe "#createSignal()", ->
        before ->
            createdSignal = source.createSignal()
        it "should have returned the created signal", ->
            createdSignal.should.exist
        it "should have a new signal in the signals array", ->
            source.signals.should.have.length 2

    describe "#createSignal(name)", ->
        before ->
            source.createSignal "test"
        it "should have two signals in the signals arary", ->
            source.signals.should.have.length 2
        it "should have a named signal 'test'", ->
            source.named.test.should.exist
            
    describe "#emit()", ->
        before ->
            createdSignal = source.createSignal()
            source.createSignal "test"

            emitSpyNamed = sinon.spy()
            emitSpyUnNamed = sinon.spy()

            source.named.test.react emitSpyNamed
            createdSignal.react emitSpyUnNamed

            source.emit("test")
        it "should send a value through each of the signals"
            emitSpyNamed.should.have.been.calledWith "test"
            emitSpyUnNamed.should.have.been.calledWith "test"

    describe "#poll()", ->
        before ->
            signal  = source.createSignal()
            pollSpy = sinon.spy()
            signal.react pollSpy
            source.poll 1000, (-> 2)
        it "should emit the result of the function every interval", ->
            clock.tick 1000
            pollSpy.should.have.been.called
            clock.tick 1000
            clock.tick 1000
            pollSpy.should.have.been.calledThrice


    describe "#interval()", ->
        before ->
            createdSignal = source.createSignal()
            intervalSpy   = sinon.spy()
            createdSignal.react intervalSpy
            source.interval 1000, 5
        after ->
            clock.restore()
        it "should emit a value every interval", ->
            for i in [0..3] #call a few times
                clock.tick 1000
                intervalSpy.should.have.been.calledWith 5

    describe "#kill()", ->
        before ->
            createdSignal = source.createSignal()
            source.kill()
        it "should no longer emit events to anything", ->
            source.emit 5
        it "should have last sent _commitsudoku to all signals", ->
            createdSignal._frame.last.should.equal "_commitsudoku"

