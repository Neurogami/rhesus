class __NAME__Controller < ApplicationController
  set_model '__NAME__Model'
  set_view  '__NAME__View'


  def default_button_action_performed
    transfer[:new_text] = "In-line Swing classes from Ruby rulez!"
    signal :set_new_text
  end


  def about_menu_action_performed
    AboutController.instance.show
  end


  def exit_menu_action_performed
   close 
  end

end
