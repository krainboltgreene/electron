chai   = require "chai"
should = chai.should()

chai.use(require "sinon-chai")

Source = require "../lib/Source.coffee"

describe "Source", ->

    beforeEach ->
        source = new Source()

    afterEach ->
        source.kill()

    describe "#constructor()", ->
        it "should have an empty array for signals", ->
            source.should.have.property("signals").with.length(0)
        it "should have an empty object for named signals", ->
            source.should.have.property("named", {})
        it "should not have ended", ->
            source.should.have.property("ended", false)

    describe "#createSignal()", ->
        before ->
            createdSignal = source.createSignal()
        it "should have a signal in the signals array", ->
            source.signals.should.have.length 1

    describe "#createSignal(name)", ->
        before ->
            source.createSignal()
            source.createSignal "test"
        it "should have another signal in the signals arary", ->
            source.signals.should.have.length 2
        it "should have a named signal 'test'", ->
            source.named.test.should.exist
            
    describe "#emit()", ->
        before ->
            source.createSignal()
            source.createSignal "test"

            emitSpyNamed = sinon.spy()
            emitSpyUnNamed = sinon.spy()

            source.named.test.react emitSpyNamed
            createdSignal.react emitSpyUnNamed

            source.emit("test")
        it "should send a value through each of the signals"
            emitSpyNamed.should.have.been.calledWith "test"
            emitSpyUnNamed.should.have.been.calledWith "test"

    # this test can be substantially better
    describe "#poll()", ->
        before ->
            signal = source.createSignal()
            clock = sinon.useFakeTimers()
            pollSpy = sinon.spy()
            signal.react pollSpy
            source.poll 1000, (-> 2)
        after ->
            clock.restore()
        it "should emit the result of the function every interval", ->
            clock.tick(1000)
            pollSpy.should.have.been.called
            clock.tick(1000)
            clock.tick(1000)
            pollSpy.should.have.been.calledThrice


    describe "#interval()", ->
        before ->
            clock = sinon.useFakeTimers()
            intervalSpy = sinon.spy()
            source.interval 1000, intervalSpy
        after ->
            clock.restore()
        it "should emit a value every interval", ->

    describe "#kill()", ->
        it "should kill the source", ->

