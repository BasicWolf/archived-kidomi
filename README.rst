kidomi
======

A JSON-to-DOM templating library.

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

But with the JavaScript arrays and objects, there is a way to create
something similar:

.. code-block:: javascript

  kidomi(['span',
           {'style':
             {'color': '#aaa',
              'text-decoration': 'line-through'}},
           "hello world!"])


**kidomi** is written in CoffeeScript. It is covered by unit tests via QUnit_
and can be used by a `Google Closure`_ compiler in a complex compilation or
separately (e.g. to produce a minified output).


Usage
=====

The `kidomi(data)` function returns a *HTMLNode* constructed from a *data*,
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


.. _dommy: https://github.com/Prismatic/dommy
.. _QUnit: http://qunitjs.com/
.. _Google Closure: https://developers.google.com/closure/compiler/
