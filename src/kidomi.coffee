window['kidomi'] =
kidomi = (data) ->
    if isString(data)
        return document.createTextNode(data)

    if not isArray(data)
        throw "Expected an array, got: #{data}"
    if data.length == 0
        throw 'Expected a non-empty array'

    tagToken = data[0]
    tagData = parseTagToken(tagToken)
    tagName = tagData.name
    if tagName == ''
        throw 'Empty tag name in #{data}'

    elem = document.createElement(tagName)
    elem.id = tagData.id
    elem.className = tagData.classes.join(' ')

    if data.length == 2
        # Cases:
        # ['elem', 'text']
        # ['elem', ['sub-elem']]
        # ['elem', {'attr1' : value}]
        token = data[1]
        if isString(token) or isArray(token)
            childElem = kidomi(token)
        else
            parsedAttr = parseAttributes(token)
            addAttributes(elem, parsedAttr)
            childElem = kidomi('')
        elem.appendChild(childElem)
    else if data.length >= 3
        # Cases:
        # ['elem', ['sub-elem1', ...], ['sub-elem2', ...], ..., text]
        # ['elem', ['sub-elem1'], ['sub-elem2'], ...]
        # ['elem', {'attr1' : value}, ['sub-elem1', ...], ['sub-elem2', ...], ..., text]
        # ['elem', {'attr1' : value}, ['sub-elem1', ...], ['sub-elem2', ...], ...]
        subElemStartIndex = 1
        if isObject(data[1])
            parsedAttr = parseAttributes(data[1])
            addAttributes(elem, parsedAttr)
            subElemStartIndex = 2
        for subArr in data[subElemStartIndex..]
            childElem = kidomi(subArr)
            elem.appendChild(childElem)
    elem


kidomi.addAttributes =
addAttributes = (elem, parsedAttr) ->
    elem.style.cssText += parsedAttr.css.style
    elem.className += ' ' + parsedAttr.css.class
    for attr, val of parsedAttr.attr
        elem.setAttribute(attr, val)


kidomi.parseAttributes =
parseAttributes = (data) ->
    classData = data.class ? ''
    classString = if isArray(classData)
        classData.join(' ')
    else
        "#{classData}"
    delete data.class

    styleData = data.style ? ''
    styleString = if isString(styleData)
        styleData
    else
        styleItems = []
        for name, val of styleData
            styleItems.push("#{name}: #{val};")
        styleItems.join(' ')
    delete data.style

    attributes = {}
    for name, val of data
        attributes[name] = val
    {
        css:
            class: classString
            style: styleString
        attr: attributes
    }


kidomi.parseTagToken =
parseTagToken = (tagToken) ->
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

kidomi.isArray =
isArray = (arr) ->
    arr instanceof Array

kidomi.isString =
isString = (s) ->
    typeof(s) == 'string' or s instanceof(String);

kidomi.isObject =
isObject = (obj) ->
    obj?.constructor == Object