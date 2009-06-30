rhesus
=======

    by James Britt 
    http://code.neurogami.com

DESCRIPTION
-----------

Rhesus is a script for copying over pre-built templates with optional embedded Erb stuff.

It started as a way to make jump-starting [Jipmanzee](http://neurogami.github.com/Jimpanzee/) apps easier, but the user-defined templates need not have anything to do with any special library.

Basically, you create a skeleton of the files you want as templates in some well-named subdirectory of ~/.rhesus.

If any of those files contain Erb variables, they will be used to prompt the use for values.

The same value gets applied in all cases where that variable is used. Some magic is used to handle proper casing for class and file names.

The results are copied out to some dir realtive to where you invoked the 'rhesus' script.



FEATURES/PROBLEMS
-----------------


Generates files for you to jump-start projects that have common code.

Makes asorted assumptions and needs more testing with a variety of template sources

SYNOPSIS
-----------

Make sure you have GitHub added as  a gem server source. See FIXME

    $ sudo gem install Neurogami-rhesus

cd to an existing project, or wherever you want to splat out the generated code:

   $ jimpanzee cool-app
   $ cd cool-app

Run `rhesus list` to see the available templates

   $ rhesus list


Run `rhesus gen` to generate code from a template.  You may optionally pass the name
of a template, but if you leave that out you'll get a list to pick from.


    $ rhesus gen
    1: jimpanzee.about
    2: jimpanzee.basic
    3: jimpanzee.midi

    Enter the number of the template to use: 



The code assumes you have a directory `.rhesus` in your home directory (+~/.rhesus+)

That directory holds the template sets.

Each set is just a top-level directory containing the skeleton files and directories to use:


    james@james06:~/.rhesus$ tree
    .
    |-- jimpanzee.about
    |   `-- src
    |       `-- about
    |           |-- about_controller.rb
    |           |-- about_model.rb
    |           |-- about_ui.rb
    |           `-- about_view.rb
    |-- jimpanzee.basic
    |   `-- src
    |       `-- klassname
    |           |-- klassname_controller.rb
    |           |-- klassname_model.rb
    |           |-- klassname_ui.rb
    |           `-- klassname_view.rb
    `-- jimpanzee.midi
        |-- com
        |   `-- neurogami
        |       `-- ResourceLoader.java
        |-- lib
        |   |-- java
        |   |   |-- libWiiuseJ.so
        |   |   |-- libwiiuse.so
        |   |   |-- miglayout-3.6.jar
        |   |   `-- wiiusej.jar
        |   `-- ruby
        |       |-- README.txt
        |       |-- wii_api_manager.rb
        |       |-- wiimotable.rb
        |       `-- wiimote_event_listener.rb
        `-- src
            |-- mainclass
            |   |-- mainclass_controller.rb
            |   |-- mainclass_model.rb
            |   |-- mainclass_ui.rb
            |   `-- mainclass_view.rb
            |-- midi.rb
            |-- resolver.rb
            |-- resource_loader.rb
            `-- spinner_dialog.rb


What you call these directories is up to you; there is no code in place to do anything clever with the names (such
as grouping projects and templates).  But something like that may be added if managing growing numbers of templates
becomes an issue.  So, the suggested format is `project_type.template_name`

Rhesus starts with some assumptions about what files might be using Erb.  You can add your own file extensions by placing a `haz_vars.txt` file in your `.rhesus` folder.

By default, the extensions are: `rb txt rhtml ini yml yaml`.

When you select a template set, Rhesus scans these files for Erb variables.  It then prompts
you to provide values.  If you use any of these variable names in file or path names then Rhesus
will apply those values to the names and paths when applying the template.  

You need to be sure, then, to only use the same variable name across files when you want them to all 
have the same value.  That is, if `foo.rb` and `baz.ini` both use `<%= my_var  %>`, then the resulting text
will have the same value used in both.

If a file in a template set is not among the file types that may have Erb  (e.g., jar, dll, gif)
then it will be copied over as-is.


For example:


`jimpanze.basic` has this structure:


    jimpanzee.basic
    |   `-- src
    |       `-- klassname
    |           |-- klassname_controller.rb
    |           |-- klassname_model.rb
    |           |-- klassname_ui.rb
    |           `-- klassname_view.rb


The file `klassname_controller.rb` has Erb to define the name of the class:

    class <%= klassname  %>Controller < ApplicationController
      set_model '<%= klassname  %>Model'
      set_view  '<%= klassname  %>View'


When `jimpanze.basic` is selected for code generation, Rhesus scans the template files and picks out variable names used inside Erb brackets (i.e., `<%= this_is_the_variable  %>` )

When the list of all such variables in all the files is assembled, rhesus prompts for a value for each one.


    Using template jimpanzee.basic
    Value for klassname: 

The value entered will than be used for *all* instances of `klassname` in Erb.  It will also be used to alter any file or
folder names that contain that as well.


Assume you gave the value of `Goober`

Since the template directory has `src/klassname`, and several files with that string, the generated code will look like this

    |   `-- src
    |       `-- goober
    |           |-- goober_controller.rb
    |           |-- goober_model.rb
    |           |-- goober_ui.rb
    |           `-- goober_view.rb


Inside the files, the code will also have this value:


    class GooberController < ApplicationController
      set_model 'GooberModel'
      set_view  'GooberView'


Some assumptions are made in writing out the code.  Variables inside files are replaces as-is.

That is, if you want `Goober` in your text, use `Goober`.  If instead you want `goober`, use that.

However, for file and folder names, variable values are snake-cased.  That's why you end up with
`src/goober/goober_controller.rb`.

A value of `FooBar`, for example,  would create `src/foo_bar/foo_bar.rb`. But the string `FooBar` would be used inside the generated files.




REQUIREMENTS
-------------

Ruby.


INSTALL
------

   sudo gem install Neurogaim-rhesus


LICENSE
-------

(The MIT License)

Copyright (c) 2009 James Britt

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
