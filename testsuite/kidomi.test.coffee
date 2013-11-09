module('QUnit')

test('Smoketest', ->
    equals(1, 1))


module('parseArray')

test('wrong input type', ->
    throws(-> kidomi.parseArray({}))
    throws(-> kidomi.parseArray([])))

test('wrong tag token name', ->
    throws(-> kidomi.parseArray([''])))

test('wrong input length', ->
    throws(-> kidomi.parseArray([1, 2, 3, 4])))


test('node with no-id no-classes name', ->
    n = kidomi.parseArray(['div'])
    equals("DIV", n.tagName))

test('node with id, no-classes name', ->
    n = kidomi.parseArray(['div#content'])
    equals("content", n.id))

test('node with id and classes name', ->
    n = kidomi.parseArray(['div#content.class1.class2'])
    equals('class1 class2', n.className))

test('node is HTMLElement', ->
    n = kidomi.parseArray(['div'])
    ok(n instanceof HTMLElement))

test('Parse attributes, no children', ->
    data =
        ['form', {
            'class': ['class1', 'class2']
            'style':
                'color': '#aaa'
                'text-decoration': 'line-through'
            'action': 'getform.php'
            'method': 'get'
        }]

    n = kidomi.parseArray(data)
    equals("FORM", n.tagName)
    equals(' class1 class2', n.className)
    equals('rgb(170, 170, 170)', n.style.color)
    equals('line-through', n.style.textDecoration)
    equals('getform.php', n.getAttribute('action'))
    equals('get', n.getAttribute('method')))

test('Parse attributes, with children', ->
    data =
        ['form', {
            'class': ['class1', 'class2']
            'style':
                'color': '#aaa'
                'text-decoration': 'line-through'
            'action': 'getform.php'
            'method': 'get'
        }, 'innerString']
    n = kidomi.parseArray(data)
    equals('innerString', n.innerText))

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