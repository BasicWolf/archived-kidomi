equals = (expected, actual, message) ->
    equal(actual, expected, message)

deepEquals = (expected, actual, message) ->
    deepEqual(actual, expected, message)


module('QUnit')

test('Smoketest', ->
    equals(1, 1))


module('parseArray')

test('Wrong input type', ->
    throws(-> kidomi.parseArray({}))
    throws(-> kidomi.parseArray([])))

test('Wrong tag token name', ->
    throws(-> kidomi.parseArray([''])))


test('Node with no-id no-classes name', ->
    n = kidomi.parseArray(['div'])
    equals("DIV", n.tagName))

test('Node with id, no-classes name', ->
    n = kidomi.parseArray(['div#content'])
    equals("content", n.id))

test('Node with id and classes name', ->
    n = kidomi.parseArray(['div#content.class1.class2'])
    equals('class1 class2', n.className))


test('Node is HTMLElement', ->
    n = kidomi.parseArray(['div'])
    ok(n instanceof HTMLElement))

# test('Parse classes list', ->
#     n = kidomi.parseArray(['div', {'class': ['class1', 'class2']}])
#     equals('class1 class2', n.className))


module('parseAttributes')

test('class only; class as a list', ->
    a = kidomi.parseAttributes({'class': ['class1', 'class2']})
    equals('class1 class2', a.class))

test('class only; class as a string', ->
    a = kidomi.parseAttributes({'class': 'class1 class2'})
    equals('class1 class2', a.class))

test('style only; style as a map', ->
    attr = 'style':
        'color': '#aaa'
        'text-decoration': 'line-through'

    a = kidomi.parseAttributes(attr)
    equals('color: #aaa; text-decoration: line-through;',
           a.style))

test('style only; style as a string', ->
    a = kidomi.parseAttributes({'style': 'color: #aaa;'})
    equals('color: #aaa;', a.style))


module('parseTagToken')

test('ID without classes', ->
    tagData = kidomi.parseTagToken('div#content')
    equals('content', tagData.id)
    equals('div', tagData.name)
    deepEquals([], tagData.classes))

test('One class only', ->
    tagData = kidomi.parseTagToken('div.class1')
    equals('div', tagData.name)
    deepEquals(['class1'], tagData.classes)
    equals('', tagData.id))

test('Many classes', ->
    tagData = kidomi.parseTagToken('div.class1.class2')
    equals('div', tagData.name)
    deepEquals(['class1', 'class2'], tagData.classes)
    equals('', tagData.id))

test('ID and one class', ->
    tagData = kidomi.parseTagToken('div#content.class1')
    equals('div', tagData.name)
    deepEquals(['class1'], tagData.classes)
    equals('content', tagData.id))

test('ID and many classes', ->
    tagData = kidomi.parseTagToken('div#content.class1.class2')
    equals('div', tagData.name)
    deepEquals(['class1', 'class2'], tagData.classes)
    equals('content', tagData.id))

test('Blank tag name, ID only', ->
    tagData = kidomi.parseTagToken('#content')
    equals('', tagData.name)
    equals('content', tagData.id))

test('Blank tag name, classes only', ->
    tagData = kidomi.parseTagToken('.class1.class2')
    equals('', tagData.name)
    deepEquals(['class1', 'class2'], tagData.classes))

test('Blang tag name, ID and classes', ->
    tagData = kidomi.parseTagToken('')
    equals('', tagData.name)
    equals('', tagData.id)
    deepEquals([], tagData.classes))


module('util')

test('isArray', ->
    ok(kidomi.isArray([]))
    ok(not kidomi.isArray({}))
    ok(not kidomi.isArray(''))
    ok(not kidomi.isArray(10)))

test('isString', ->
    ok(kidomi.isString(''))
    ok(not kidomi.isString({}))
    ok(not kidomi.isString([]))
    ok(not kidomi.isString(10)))
