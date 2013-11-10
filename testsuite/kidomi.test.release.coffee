module('kidomi')

test('wrong input type', ->
    throws(-> kidomi({}))
    throws(-> kidomi([])))

test('wrong tag token name', ->
    throws(-> kidomi([''])))

test('wrong input length', ->
    throws(-> kidomi([1, 2, 3, 4])))

test('node with no-id no-classes name', ->
    n = kidomi(['div'])
    equals("DIV", n.tagName))

test('node with id, no-classes name', ->
    n = kidomi(['div#content'])
    equals("content", n.id))

test('node with id and classes name', ->
    n = kidomi(['div#content.class1.class2'])
    equals('class1 class2', n.className))

test('node is HTMLElement', ->
    n = kidomi(['div'])
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

    n = kidomi(data)
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
    n = kidomi(data)
    equals('innerString', n.innerText))

test('Parse attributes, node name with classes', ->
    data =
        ['div.class0', {
            'class': ['class1', 'class2']
        }]
    n = kidomi(data)
    equals('class0 class1 class2', n.className))

test('Parse multiple sub-nodes', ->
    data = ['div', ['span#span1'], ['span#span2']]
    n = kidomi(data)
    equals(2, n.children.length)
    equals('SPAN', n.children[0].tagName)
    equals('SPAN', n.children[1].tagName)
    equals('span1', n.children[0].id)
    equals('span2', n.children[1].id))


test('Parse multiple sub-nodes, text in the end', ->
    data = ['div', ['span#span1'], 'some text']
    n = kidomi(data)
    equals(1, n.children.length)
    equals('SPAN', n.children[0].tagName)
    equals('span1', n.children[0].id)
    equals('some text', n.innerText))

test('Parse multiple sub-nodes with attributes', ->
    data =
        ['div.divclass',
            ['span#span1', {'class': ['class1', 'class2']}, ['span#span2']],
            ['form', {
                'class': ['class1', 'class2']
                'style':
                    'color': '#aaa'
                    'text-decoration': 'line-through'
                'action': 'getform.php'
                'method': 'get'
                }, 'formText']]
    n = kidomi(data)
    equals('divclass', n.className)
    equals(2, n.children.length)
    equals('SPAN', n.children[0].tagName)
    equals('span1', n.children[0].id)
    equals('SPAN', n.children[0].children[0].tagName)
    equals('span2', n.children[0].children[0].id)

    fe  = n.children[1]
    equals("FORM", fe.tagName)
    equals(' class1 class2', fe.className)
    equals('rgb(170, 170, 170)', fe.style.color)
    equals('line-through', fe.style.textDecoration)
    equals('getform.php', fe.getAttribute('action'))
    equals('get', fe.getAttribute('method')))