chai   = require "chai"
sinon  = require "sinon"
should = chai.should()

chai.use(require "sinon-chai")

Event = require "../lib/event.coffee"

describe "Event", ->

    describe "#constructor()", ->
