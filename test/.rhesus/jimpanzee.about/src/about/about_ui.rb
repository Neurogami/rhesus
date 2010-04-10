require 'swingset'

include  Neurogami::SwingSet::Core

class AboutFrame < Frame   

  FRAME_WIDTH = 600
  FRAME_HEIGHT = 130

  LABEL_WIDTH = 400
  LABEL_HEIGHT = 60

  # Make sure our components are available!
  attr_accessor :default_button, :default_label, :menu_bar, :about_menu, :exit_menu

  def initialize *args
    super
    self.minimum_width  = FRAME_WIDTH
    self.minimum_height = FRAME_HEIGHT
    set_up_components
  end

  def set_up_components
    component_panel = Panel.new

    # If we were clever we would define a method that took a  single hex value, like CSS.
    component_panel.background_color(255, 255, 255)
    component_panel.size(FRAME_WIDTH, FRAME_HEIGHT)

    # This code uses the MiG layout manager.
    # To learn more about MiGLayout, see:
    #     http://www.miglayout.com/
    component_panel.layout = Java::net::miginfocom::swing::MigLayout.new("wrap 2")

    @default_label = Label.new do |l|
      # A nicer way to set fonts would be welcome
      l.font = java::awt.Font.new("Lucida Grande", 0, 18)
      l.minimum_dimensions(LABEL_WIDTH, LABEL_HEIGHT)
      l.text = "ABOUT: Jimpanzee rulez!"
    end

    # Add components to panel
    component_panel.add @default_label, "gap unrelated"
    add component_panel
  end

end

