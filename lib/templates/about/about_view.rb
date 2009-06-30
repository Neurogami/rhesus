require 'about_ui'

class AboutView < ApplicationView
  set_java_class AboutFrame

  def load
    set_frame_icon 'images/mb_default_icon_16x16.png'
    move_to_center
  end
end

