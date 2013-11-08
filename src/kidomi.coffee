window.kidomi = kidomi = (data) ->
    @parseArray(data)

kidomi.parseArray = (data) ->
    if data not instanceof Array
        throw "Expected an array, got: " + data
    if data.length == 0
        throw "Expected a non-empty array"

    tagName = data.shift()
    document.createElement(tagName)

kidomi.parseTagToken = (tagToken) ->
    classSplitData = tagToken.split('.')
    tagNameAndId = classSplitData.shift()
    tagNameAndIdSplit = tagNameAndId.split('#')
    tagName = tagNameAndIdSplit[0]
    tagId = tagNameAndIdSplit[1] ? ''

    {
        name: tagName
        id: tagId
        classes: classSplitData
    }
