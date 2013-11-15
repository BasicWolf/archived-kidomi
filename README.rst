kidomi
======

A JSON-to-DOM templating library.

Download
========

* `v0.1 https://github.com/BasicWolf/kidomi/archive/v0.1.zip`_


Rationale
=========

**kidomi** was written after I have had a chance to try the dommy_
ClojureScript library in production. Certainly, ClojureScript plays
a major role in why the templating syntax seems so natural and pleasant,
e.g.:

.. code-block:: clojure

  (node
    [:span
      {:style
        {:color "#aaa"
         :text-decoration "line-through"}}
      "hello world!"])

But with JavaScript arrays and objects, there is a way to create
something similar:

.. code-block:: javascript

  kidomi(['span',
           {'style':
             {'color': '#aaa',
              'text-decoration': 'line-through'}},
           "hello world!"])


**kidomi** is written in CoffeeScript. It is covered by unit tests
via QUnit_ and can be used by a `Google Closure`_ compiler in
an *ADVANCED_MOE* compilation or separately (e.g. to produce a
minified output).


Usage
=====

The ``kidomi(data)`` function returns a *HTMLNode* constructed from a *data*,
for example:

.. code-block:: javascript

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

The generated HTML element is:

.. code-block:: html

  <div id="main" class="content">
    <span style="color: blue;">Select file</span>
    <form name="inputName" action="getform.php" method="get">
      Username:
      <input type="text" name="user"></input>
      <input type="submit" value="Submit"></input>
    </form>
  </div>


Syntax
======

The general syntax of kidomi is:

.. code-block:: javascript

   node = kidomi(parsableObject)

Here, ``node`` is a HTMLElement_ or in a more generic case a `DOM node`_.

The ``parsableObject`` is:


* A string. The returned object is a `Text node`_.
* A node. The returned object is the same node.
* An array. This should be discussed a bit thoroughly:

The syntax of the ``parsableObject`` array is simple and very flexible.
It consists of at least one item, which is:

.. code-block:: javascript

   ['element#id.class1.class2.classN']

Here, ``id`` - is the ``id`` attribute of the node, ``class1.class2.classN`` -
CSS classes of the node, i.e. ``class="class1 class2 classN"``.

For example:

.. code-block:: javascript

    ['div']                 // <div></div>
    ['div#content']         // <div id="content"></div>
    ['span#user.username']  // <span id="user" class="username"></span>
    ['span.password']       // <span class="passwordd"></span>
    ['div.main.dialog']     // <div class="main dialog"></div>
    // etc.

The second item is either an attributes object, or a sub-``parsableObject``.
The attributes object has the following syntax:

.. code-block:: javascript

   {'class': ['class1', 'classN'],
    'style': {'prop1': 'val1', 'propN': 'valN'},
    'attribute1' : 'value1',
    'attributeN' : 'valueN'}

The ``class`` and ``style`` key-value pairs are optional.

* The ``class`` key-value pair is an array of CSS classes applied
  to the node. It is concatenated to the classes found in the first
  item of the ``parsableObject`` array.
* The ``style`` key-value pair is an object of CSS style properties
  of the node.

The ``attributeX`` key-value pairs are the attributes of the node.

For example:

.. code-block:: javascript

  ['a', {'class': ['biglink'],
         'style': {'color': 'red'},
         'href': 'http://github.com'}]

  // <a href="http://github.com" class="biglink" style="color:red;"></a>

The rest of the array items are nested ``parsableObjects``.



Building and testing
====================

You will need the following tools to build and test **kidomi**:

0. GNU Make. This is used to run the ``Makefile`` script.
1. CoffeeScript_ compiler. This is enough to build the library.
2. `Google Closure`_ compiler. This is used to build the optimized
   version of the library. The CoffeeScript code is written with the
   Closure restrictions in mind.
3. PhantomJS_ is used to run the unit tests from a shell. You can as
   well run them in a normal browser.


Advanced usage
==============

Referencing elements
--------------------

One of the patterns where **kidomi** might be especially handy is
when you have to create certain HTML elements before adding them in
a DOM structure. For example:

.. code-block:: javascript

   button = kidomi(['button']);
   button.addEventListener('click', function(){alert('Hello world');}, false);

   myDiv = kidomi(['div',
                    ['span', 'Click me:'],
                    button]);

   document.body.appendChild(myDiv);


.. _dommy: https://github.com/Prismatic/dommy
.. _QUnit: http://qunitjs.com/
.. _Google Closure: https://developers.google.com/closure/compiler/
.. _HTMLElement: https://developer.mozilla.org/en/docs/Web/API/HTMLElement
.. _DOM node: https://developer.mozilla.org/en-US/docs/Web/API/Node
.. _Text node: https://developer.mozilla.org/en-US/docs/Web/API/Text
.. _CoffeeScript: http://coffeescript.org/
.. _PhantomJS: http://phantomjs.org/
