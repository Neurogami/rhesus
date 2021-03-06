rhesus
=======

[James Britt / Neurogami](http://www.neurogami.com)

james@neurogami.com


DESCRIPTION
-----------

Rhesus is a tool for copying over pre-built templates with optional embedded string interpolation.

It started as a way to make jump-starting [Jimpanzee](http://neurogami.github.com/Jimpanzee/)  (and now 
[Monkeybars](http://www.monkeybars.org) apps easier, but the user-defined templates need not have 
anything to do with any special library or programming language.

Basically, you create a skeleton of the directories and files you want for a template in some suitably-named 
subdirectory of ~/.rhesus.

If any of those files contain [Erb](http://www.ruby-doc.org/stdlib/libdoc/erb/rdoc/classes/ERB.html) variables, 
they will be used to prompt the user for real values when that template is used to generate files and directories.

The same value gets applied in all cases where that variable is used. Some magic is used to handle proper casing 
for class and file names.

The results are copied out to a directory relative to where you invoked the 'rhesus' script.



FEATURES/PROBLEMS
-----------------

Generates files for you to jump-start projects that have common code.

Makes assorted assumptions and needs more testing with a variety of template sources.

Driven by the _Works for James_ criteria.  Feedback is welcome.

Bugs are being tracked on [Pivotal Tracker](http://www.pivotaltracker.com/projects/72892)



SYNOPSIS
--------

### Installation

Make sure you have http://gems.neurogami.com added as a gem server source.

    $ sudo gem sources -a http://gems.neurogami.com

Then install the gem:

    $ sudo gem install rhesus

Or, pass the gem source as part of the command:

   $ sudo gem i rhesus ––source http://gems.neurogami.com

Then run the Rhesus setup option:

   $ rhesus --setup


This should create a `.rhesus` folder in your home directory.  This is where you store you templates, each in its own containing folder.

The default set-up includes a simple template example, `basic.class`, that defines a basic class. Really.


### Basic usage

To use templates, cd to an existing project, or wherever you want to splat out the generated code. For example, start a new monkeybars application:

   $ monkeybars cool-app
   $ cd cool-app

Run `rhesus list` to see the available templates

   $ rhesus list

NOTE: This behavior might vanish, since in actual use it ends up being pretty useless. See below.

Run `rhesus gen` to generate code from a template.  You may optionally pass the name
of a template, but if you leave that out you'll get a list to pick from.

    $ rhesus gen
    1: jimpanzee.about
    2: jimpanzee.basic
    3: jimpanzee.midi

    Enter the number of the template to use: 

If you pass a complete template name then that is automatically used:

    $ rhesus gen  jimpanzee.midi

Run `rhesus <whatever>` to have rhesus show a list of templates that match on `<whatever>`.

    $ rhesus midi
    1: jimpanzee.midi

    Enter the number of the template to use (1 is the only choice), or q to quit: 


or


    $ rhesus rama
    1: gae.ramaze
    2: ramaze.tuple
    3: ramaze.base
    Enter the number of the template to use (1 to 3), or q to quit: 
 

 Some comments on this:  First,  the `list` and `gen` commands are awkward onc eyou have more than 10 or 15 templates
 because they give you the complete list of all available templates.  There is no list paging or navigation.

 In practice you will find that, so long as you have given the templates reasoanbale names, you
 will get a list of template candidates by passing in a template name, or part of a name (see above).

 The `list` and `gen` commands are handy if you forgot what things are called.


#### Template structure

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
as grouping projects and templates).  

The suggested format is `project_type.template_name`. For example:

    processing.android
    ramaze.basic
    ramaze.user_auth
    haskell.main


Rhesus starts with some assumptions about what files might be using Erb.  You can add your own file patterns (sort of) 
by placing a `haz_vars.txt` file in your `.rhesus` folder.

By default, the file-end patterns are: `rb txt rhtml ini yml yaml Rakefile gemspec`.

### Note

A still-evolving feature is the use of a `.rhesus-options.yaml` file in the root of a template folder.

This is because you may have a large set files that do not need any template processing.  

Worse, some files may be themselves Erb templates (or contain Erb markup) that should be copied over as-is, but would otherwise get preprocessed by Rhesus.

a `.rhesus-options.yaml` file can contain a hash of file patterns, like this


        noparse: 
          -  /gems/gems/rack 
  

        ignore:
          - .git/

This tells `rhesus` that any file whose template path matches on any of the items listed in `noparse` 
should not be parsed for template variables, and simply copied over as-is.

The array under `ignore` means to ignore any files or directories that match on that substring. No parsing, no copying.
This is particularly helpful when you want to keep a template in a VCS but not include the VCS meta-files
when using the template.


### More Notes

Rhesus makes some assumptions about how to apply names to files and directories.  It is not always so smart.

If your options file includes a `language` entry then that will be used to drive how things get named.

(Basically, whether or not everything gets converted to snake_case.)

In fact, the only language it knows is `ruby`. 

What this means in practice is that if your template files define `class_name.rb`  with  `class  <%= class_name %> `
then Rhesus will know to snake_case the value substituted in for the file name.  This way, when you invoke the
template and get prompted for the value of `class_name` you can enter `FooBar` (or something) and get a
file named `foo_bar.rb` defining the class `FooBar`.

However, there is nothing in place that knows how to do the equivalent for, say, a Haskell or Closure file.

Until there's a way to cleanly add new processing rules for additional languages the best approach for non-Ruby
files is to use distinct variable names for any value that needs a specific format or casing.

(Note: in practice this tends to not be a big deal.  Haskell files, for example tend to follow CamelCase, as do
Java and some other language.  If you are creating Processing or Arduino projects the file name as well as the root folder
are the same CamelCase name. )

The next section explains general variable handling.

### Template variables

When you select a template set, Rhesus scans these files for Erb (or some alternate) variables.  It 
then prompts you to provide values.  If you use any of these variable names in file or path names 
then Rhesus will apply those values to the names and paths when applying the template.  

You need to be sure, then, to only use the same variable name across files when you want them to all have the same value.  

That is, if `foo.rb` and `baz.ini` both use `<%= my_var  %>`, then the resulting text will have the same value used in both.

If a file in a template set is not among the file types that may have Erb  (e.g., jar, dll, gif) then it will be copied over as-is.


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


When `jimpanze.basic` is selected for code generation, Rhesus scans the template files and picks out variable names 
used inside Erb brackets (i.e., `<%= this_is_the_variable  %>` )

When the list of all such variables in all the files is assembled, Rhesus prompts for a value for each one.

  Rhesus
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

That is, if you want `Goober` in your text, use `Goober`.  If instead you want `goober`, use that.  If
you need  both then use two distinct variables.

However, for file and folder names, variable values are snake-cased.  That's why you end up with
`src/goober/goober_controller.rb`.

A value of `FooBar`, for example,  would create `src/foo_bar/foo_bar.rb`. But the string `FooBar` would be 
used inside the generated files.


### Note: poly-lingual templates

Some of the code for auto-mangling file and path names is changing.  Initially the code was specific to Ruby apps, 
but it's really very handy for all sorts of things, such as Haskell projects.

But these other things have different conventions; code to apply appropriate conventions is being added but
there's still no nice way to just plop in a new set of language rules.


### Note: "rhamaze" templating

Yet another evolving features is the use of "rhamaze" templating.   

Suppose you have a Ramaze project template set, with some `.xhtml` files that contain Erb markup.  
You do not want Rhesus to pre-process this as Erb (that is, the resulting project files need to have literal 
template code), but you *do* want to have *some* interpolated variables.

So, you need to add a leading line that contains the string `RHEMAZAR` and do your Rhesus variables using this syntax:

     <|= my_variable |>

That leading line will be skipped when processing the file.


Adding templates
----------------

You can add templates by just tossing them into the appropriate directory structure under `~/.rhesus`.

You can also install templates from a git repository.  For example:

    $ rhesus --install git@gitlandia.org:Neurogami/super.bad.template.git

or

    $ rhesus --install git://gitistan.org/Neurogami/super.badder.template.git


Rhesus will do a straight-up `git clone` to fetch the files.  If the repo name begins with `rhesus.` 
(e.g. `git://gitistan.org/Neurogami/rhesus.ramaze.basic`) then that leading string gets stripped from 
the destination folder (`ramaze.basic`).

This is so that repos names can have an identifiable name prefix without having the resulting template 
folder cluttered with that prefix.  Whether is actually useful or a needless "cool" feature is yet to be
determined.


REQUIREMENTS
-------------

Ruby, and a sense of adventure.


INSTALL
------

    $ sudo gem i rhesus ––source http://gems.neurogami.com


LICENSE
-------

(The MIT License)

Copyright (c) 2011 James Britt / Neurogami

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

Feed your head. Hack your world. Live curious.
