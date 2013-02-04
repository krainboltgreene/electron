class Event
    value       : "default"
    meta:
        isError     : false
        isEnd       : false
        isNull      : false

    constructor: (@value = "default", meta = {}) ->
        @meta = meta if meta

module.exports = exports = Event
