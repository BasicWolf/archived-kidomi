module('QUnit')

test('Smoketest', ->
    equals(1, 1))


module('extractNode')

test('extract text', ->
    n = kidomi.extractNode('some text')
    ok(n instanceof Text))

test('extract node', ->
    n2 = document.createElement('div')
    n = kidomi.extractNode(n2)
    ok(n instanceof Node))

module('addAttributes')

test('add attributes to form', ->
    attr =
        'class': ['class1', 'class2']
        'style':
            'color': '#aaa'
            'text-decoration': 'line-through'
        'action': 'getform.php'
        'method': 'get'
    n = document.createElement('form')
    parsedAttr = kidomi.parseAttributes(attr)
    kidomi.addAttributes(n, parsedAttr)
    equals('getform.php', n.getAttribute('action'))
)

module('parseAttributes')

test('class only; class as a list', ->
    a = kidomi.parseAttributes({'class': ['class1', 'class2']})
    equals('class1 class2', a.css.class))

test('class only; class as a string', ->
    a = kidomi.parseAttributes({'class': 'class1 class2'})
    equals('class1 class2', a.css.class))

test('style only; style as a map', ->
    attr = 'style':
        'color': '#aaa'
        'text-decoration': 'line-through'

    a = kidomi.parseAttributes(attr)
    equals('color: #aaa; text-decoration: line-through;',
           a.css.style))

test('style only; style as a string', ->
    a = kidomi.parseAttributes({'style': 'color: #aaa;'})
    equals('color: #aaa;', a.css.style))

test('various attributes, no class or style', ->
    a = kidomi.parseAttributes({'action': 'getform.php', 'method': 'get'})
    equals('getform.php', a.attr.action)
    equals('get', a.attr.method))

test('various attributes, with class and style', ->
    attr =
        'class': ['class1', 'class2']
        'style':
            'color': '#aaa'
            'text-decoration': 'line-through'
        'action': 'getform.php'
        'method': 'get'

    a = kidomi.parseAttributes(attr)
    equals('class1 class2', a.css.class)
    equals('color: #aaa; text-decoration: line-through;',
           a.css.style)
    equals('getform.php', a.attr.action)
    equals('get', a.attr.method))


module('parseTagToken')

test('id without classes', ->
    tagData = kidomi.parseTagToken('div#content')
    equals('content', tagData.id)
    equals('div', tagData.name)
    deepEquals([], tagData.classes))

test('one class only', ->
    tagData = kidomi.parseTagToken('div.class1')
    equals('div', tagData.name)
    deepEquals(['class1'], tagData.classes)
    equals('', tagData.id))

test('many classes', ->
    tagData = kidomi.parseTagToken('div.class1.class2')
    equals('div', tagData.name)
    deepEquals(['class1', 'class2'], tagData.classes)
    equals('', tagData.id))

test('id and one class', ->
    tagData = kidomi.parseTagToken('div#content.class1')
    equals('div', tagData.name)
    deepEquals(['class1'], tagData.classes)
    equals('content', tagData.id))

test('id and many classes', ->
    tagData = kidomi.parseTagToken('div#content.class1.class2')
    equals('div', tagData.name)
    deepEquals(['class1', 'class2'], tagData.classes)
    equals('content', tagData.id))

test('blank tag name, id only', ->
    tagData = kidomi.parseTagToken('#content')
    equals('', tagData.name)
    equals('content', tagData.id))

test('blank tag name, classes only', ->
    tagData = kidomi.parseTagToken('.class1.class2')
    equals('', tagData.name)
    deepEquals(['class1', 'class2'], tagData.classes))

test('blang tag name, id and classes', ->
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

test('isObject', ->
    ok(kidomi.isObject({}))
    ok(not kidomi.isObject(''))
    ok(not kidomi.isObject([]))
    ok(not kidomi.isObject(10)))