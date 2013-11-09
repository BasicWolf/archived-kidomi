window['kidomi'] = kidomi = (data) ->
    parseArray(data)


kidomi.parseArray =
parseArray = (data) ->
    if isString(data)
        return document.createTextNode(data)

    if not isArray(data)
        throw "Expected an array, got: #{data}"
    if data.length == 0
        throw 'Expected a non-empty array'
    else if data.length > 3
        throw 'Array can contain 3 items max.'

    tagToken = data[0]
    tagData = parseTagToken(tagToken)
    tagName = tagData.name
    if tagName == ''
        throw 'Empty tag name in #{data}'

    elem = document.createElement(tagName)
    elem.id = tagData.id
    elem.className = tagData.classes.join(' ')

    switch data.length
        when 2
            token = data[1]
            if isString(token) or isArray(token)
                childElem = parseArray(token)
            else
                parsedAttr = parseAttributes(token)
                addAttributes(elem, parsedAttr)
                childElem = parseArray('')
            elem.appendChild(childElem)
        when 3
            parsedAttr = parseAttributes(data[1])
            addAttributes(elem, parsedAttr)
            childElem = parseArray(data[2])
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
