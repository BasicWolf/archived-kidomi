equals = (expected, actual, message) ->
    window['equal'](actual, expected, message)

deepEquals = (expected, actual, message) ->
    window['deepEqual'](actual, expected, message)

raises = (block, expected, message) ->
    window['throws'](block, expected, message)