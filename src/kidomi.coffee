window.kidomi = kidomi = (data) ->
    @parseArray(data)

kidomi.parseArray = (data) ->
    if not isArray(data)
        throw "Expected an array, got: #{data}"
    if data.length == 0
        throw 'Expected a non-empty array'

    tagToken = data.shift()
    tagData = @parseTagToken(tagToken)
    tagName = tagData.name
    if tagName == ''
        throw 'Empty tag name in #{data}'

    elem = document.createElement(tagName)
    elem.id = tagData.id
    elem.className = tagData.classes.join(' ')
    elem

kidomi.parseAttributes = (data) ->
    classData = data.class ? ''
    classString = if isArray(classData)
        classData.join(' ')
    else
        "#{classData}"

    styleData = data.style ? ''
    styleString = if isString(styleData)
        styleData
    else
        styleItems = []
        for name, val of styleData
            styleItems.push("#{name}: #{val};")
        styleItems.join(' ')

    {
        class: classString
        style: styleString
    }

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

### utility functions ###
#########################

kidomi.isArray = isArray = (arr) ->
    arr instanceof Array

kidomi.isString = isString = (s) ->
    typeof(s) == 'string' or s instanceof(String);
