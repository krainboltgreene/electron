class Event
    value       : undefined
    meta:
        isError     : false
        isEnd       : false
        isNull      : false

    constructor: (@value, meta = {}) ->
        @meta = meta if meta

module.exports = exports = Event
