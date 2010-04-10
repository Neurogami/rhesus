module Neurogami
  module Rhesus
    class Config
      FILE_TYPE_RENAMING_MAP = {
          /\.rb$/ => :to_snake_case,
          /\.xhtml$/ => :to_snake_case,
          /\.rhtml$/ => :to_snake_case
      }


      LANGUAGE_RENAMING_MAP = {
           'ruby' => :to_snake_case,
           'rb' => :to_snake_case
      }

    end
  end
end
