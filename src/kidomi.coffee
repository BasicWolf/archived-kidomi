window.kidomi = (data) ->
    parseArray(data)

parseArray = (data) ->
    if not data instanceof Array
        throw "Expected an array, got: " + data