========
userutil
========

What's this
-----------
mikutter plugin to append utility functions working on user informations.

How to
------
::

 $ git clone https://github.com/osak/userutil.git ~/.mikutter/plugin/

or just use mikustore.

Functionality
-------------
.. code:: ruby

  Plugin.filtering(:usercomplete, "to", [])
  #=> ["to", ["toshi_a", "toshi_a_kanyou"]]
