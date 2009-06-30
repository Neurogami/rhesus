require '__name___ui' 

# This is our Monkeybars View code
class __NAME__View < ApplicationView
  set_java_class __NAME__Frame  # Defined in __name___ui.rb

  # Signals are a way to have the controller pass requests to the view.
  # To understand Moneybars signals, see:
  #     http://www.jimpanzee.org/understanding-signals
  define_signal :name => :set_new_text , :handler => :handle_new_text

  # @load@ is called when the UI is opened.  You can think of it as a subsitute for 'initialize',
  # which, in the parent code, is already used for high-lelve preperations and should not
  # be replaced without a good understanding of how it works.
  #
  # To understand the Monkeybars View lifecycle, see:
  #    http://www.jimpanzee.org/understanding-views
  def load
    # Helper method defined in application_view ro all views can use it
    set_frame_icon 'images/mb_default_icon_16x16.png'
    move_to_center # Built in to each Monkeybars View class.
    # Set up some basics content for our UI ...
    default_label.text = "Monkeybars is the bomb!"
  end

  # This is the method invoked when the view receives the set_new_text signal
  # is received.  All such signal handlers need to accept model and transfer objects.
  #
  # To understand Moneybars signals, see:
  #     http://www.jimpanzee.org/understanding-signals
  def handle_new_text model, transfer
    default_label.text = transfer[:new_text]
  end

end
