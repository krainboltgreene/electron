chai   = require "chai"
sinon  = require "sinon"
should = chai.should()

chai.use(require "sinon-chai")

Event = require "../lib/event.coffee"

describe "Event", ->

    describe "#constructor(value)", ->
        event = new Event()
        it "should have property value", ->
            event.should.have.property "value"
        it "should have property meta", ->
            event.should.have.property "meta"
