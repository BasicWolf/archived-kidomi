kidoma
======

A JSON-to-DOM templating library.

Usage
=====

The `kidomi(data)` function returns a *HTMLNode* constructed from a *data*,
for example:

::

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

The generated HTML element is::

  <div id="main" class="content">
    <span style="color: blue;">Select file</span>
    <form name="inputName" action="getform.php" method="get">
      Username:
      <input type="text" name="user"></input>
      <input type="submit" value="Submit"></input>
    </form>
  </div>
