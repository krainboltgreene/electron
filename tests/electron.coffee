chai   = require "chai"
sinon  = require "sinon"
should = chai.should()

chai.use(require "sinon-chai")

describe "Electron", ->

    describe "#fromPromise()", ->

    describe "#fromEventTarget()", ->

    describe "#asEventStream()", -> #this is a fairly difficult one to test since it requires jquery 
        # going to spin up a phantomjs instance JUST FOR THIS I suppose

