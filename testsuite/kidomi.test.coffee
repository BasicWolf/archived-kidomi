test('QUnit smoketest', ->
    equal(1, 1))


test('parseArray: wrong input type', ->
    throws(-> kidomi.parseArray({}))
    throws(-> kidomi.parseArray([])))



test('parseArray: make single div node', ->
    n = kidomi.parseArray(['div'])
    ok(n instanceof HTMLElement)
    equal("DIV", n.tagName)
    equal(0, n.attributes.length))


test('parseTagToken: ID without classes', ->
    tagData = kidomi.parseTagToken('div#content')
    equal('content', tagData.id)
    equal('div', tagData.name)
    deepEqual([], tagData.classes))

test('parseTagToken: one class only', ->
    tagData = kidomi.parseTagToken('div.class1')
    equal('div', tagData.name)
    deepEqual(['class1'], tagData.classes)
    equal('', tagData.id))

test('parseTagToken: many classes', ->
    tagData = kidomi.parseTagToken('div.class1.class2.class3')
    equal('div', tagData.name)
    deepEqual(['class1', 'class2', 'class3'], tagData.classes)
    equal('', tagData.id))
