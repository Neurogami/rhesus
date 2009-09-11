module Neurogami
  module Rhesus
    class Rhezamar

      def initialize text
        @text = text
      end

      def result variables_hash
        t = @text.dup
        variables_hash.each do |k, v|
          t.gsub!(  /<\|=\s*#{k}\s*\|>/m, v  )
        end
        t
      end
    end
  end
end
