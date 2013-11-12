module('kidomi')

test('wrong input type', ->
    throws(-> kidomi({}))
    throws(-> kidomi([])))

test('wrong tag token name', ->
    throws(-> kidomi([''])))

test('parse attributes, no children', ->
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
    equals('class1 class2', n.className)
    equals('rgb(170, 170, 170)', n.style.color)
    equals('line-through', n.style.textDecoration)
    equals('getform.php', n.getAttribute('action'))
    equals('get', n.getAttribute('method')))

test('parse attributes, with children', ->
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

test('parse attributes, node name with classes', ->
    data =
        ['div.class0', {
            'class': ['class1', 'class2']
        }]
    n = kidomi(data)
    equals('class0 class1 class2', n.className))

test('parse multiple sub-nodes', ->
    data = ['div', ['span#span1'], ['span#span2']]
    n = kidomi(data)
    equals(2, n.children.length)
    equals('SPAN', n.children[0].tagName)
    equals('SPAN', n.children[1].tagName)
    equals('span1', n.children[0].id)
    equals('span2', n.children[1].id))

test('parse multiple sub-nodes, text in the end', ->
    data = ['div', ['span#span1'], 'some text']
    n = kidomi(data)
    equals(1, n.children.length)
    equals('SPAN', n.children[0].tagName)
    equals('span1', n.children[0].id)
    equals('some text', n.innerText))

test('parse sub-node which is HTML element', ->
    n2 = kidomi(['span'])
    n = kidomi(['div', n2])
    equals('SPAN', n.children[0].tagName))

test('parse multiple sub-nodes with attributes', ->
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
    equals('class1 class2', fe.className)
    equals('rgb(170, 170, 170)', fe.style.color)
    equals('line-through', fe.style.textDecoration)
    equals('getform.php', fe.getAttribute('action'))
    equals('get', fe.getAttribute('method'))

    elem = kidomi(
        ['div#main.content',
            ['span', {'style': {'color': 'blue'}}, 'Select file'],
            ['form', {
                'name': 'inputName',
                'action': 'getform.php',
                'method': 'get'},
            'Username: ',
            ['input', {'type': 'text', 'name': 'user'}],
            ['input', {'type': 'submit', 'value': 'Submit'}]]])
    console.log(elem.outerHTML)

    )