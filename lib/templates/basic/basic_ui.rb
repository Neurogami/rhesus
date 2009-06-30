# Your View class will almost certainly need a Java Swing class to show to the user.
#
# To understand how Monkeybars views work, see:
#
#     http://wwww.jimpanzee.org/understanding-views
#
# Each View class has a class method, 'set_java_class', to which you pass
# the Swing class to use for the actual GUI.
#
# It accepts either a string or a class constant. 
# If you pass a string, the View class will look for a compiled Java file of that name  
# and use that:
#
#    set_java_class 'basic.ExampleFrame'
#    # assumes you are providing the Java Swing class ExampleFrame.class, in the package 'basic'
#    # and that it is on the $LOAD_PATH
#
# If passed a class constant, the View class assumes it already exists and uses it.
#
#    set_java_class ExampleFrame
#    # assumes you are have defined the Ruby class ExampleFrame and that it
#    # embodies a usable Swing class.
#
# If you are creating a complex application you would do best to use a WYSIWYG Swing editor
#  (such as provided for free in Netbeans) and compiling the resulting code to a .class file.
#
#  However, if you prefer to define your UI using Ruby you can do so by creating a class
#  that inherits, for example, from  javax::swing.JPanel
#
#  The generated code presented here defines some simple Ruby classes to wrap a few Swing components.
#  It is meant to give some idea on how this can be done; it is by no means a complete  Ruby/Swing UI tool.
#
#  Note that you don't have to place this code in the same file as your Monkeybars View class,
#  but it needs to be processed before your view code sets its Java class.


require 'mb_swing_wrappers'
include  Monkeybars::Swing


# This is the main class used by your view.
#
# Important: Make sure that all components are exposed as accessors so
# that the View code can use them.
class __NAME__Frame < Frame   

  FRAME_WIDTH = 600
  FRAME_HEIGHT = 130

  LABEL_WIDTH = 400
  LABEL_HEIGHT = 60

  # Make sure our components are available!
  attr_accessor :default_button, :default_label, :menu_bar, :about_menu, :exit_menu

  def about_menu
    @about_menu
  end

  def initialize args
    super
    self.minimum_width  = FRAME_WIDTH
    self.minimum_height = FRAME_HEIGHT
    set_up_components
  end

  def set_up_components
    component_panel = Panel.new

    # If we were clever we would define a method that took a  single hex value, like CSS.
    component_panel.background_color 255, 255, 255
    component_panel.size FRAME_WIDTH, FRAME_HEIGHT

    # This code uses the MiG layout manager.
    # To learn more about MiGLayout, see:
    #     http://www.miglayout.com/
    component_panel.layout = Java::net::miginfocom::swing::MigLayout.new("wrap 2")

    @menu_bar = MenuBar.new do |menu_bar|
      @file_menu = Menu.new do |m|

        @exit_menu  = MenuItem.new do |mi|
          mi.name = 'exit_menu'
          mi.mnemonic= Monkeybars::Key.symbol_to_code :VK_X
          mi.text ="Exit"
        end

        m.name = 'file_menu'
        m.text ="File"
        m.add exit_menu
      end

      @help_menu =  Menu.new do |m|
        @about_menu = MenuItem.new do |mi|
          mi.name = 'about_menu'
          mi.mnemonic= Monkeybars::Key.symbol_to_code :VK_A
          mi.text ="About"
        end

        m.name = 'help_menu'
        m.text = 'Help'
        m.add about_menu
      end
    # Worth noting: you can add the mnu item objects directly, which NetBeans doesn't seem to allow 
      menu_bar.add @file_menu
      menu_bar.add @help_menu
      set_jmenu_bar menu_bar
    end


    @default_label = Label.new do |l|
      # A nicer way to set fonts would be welcome
      l.font = java::awt.Font.new "Lucida Grande", 0, 18
      l.minimum_dimensions LABEL_WIDTH, LABEL_HEIGHT
      l.text = "Neurogami::SwingSet rulez!"
    end

    # We need to set a name so that the controller can catch events from this button
    @default_button = Button.new do |b| 
      b.name = "default_button"
      b.text = "Click me!"
    end

    # Add components to panel
    component_panel.add @default_button, 'grow x'
    component_panel.add @default_label, "gap unrelated"
    add component_panel
  end

end
 
