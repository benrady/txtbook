require 'fileutils'

module TxtBook
  class Factory
    def create(cmd_line_args)
      textbook_root = cmd_line_args[0]
      template = File.join(File.dirname(__FILE__), 'txtbook', 'new_book_template')
      FileUtils.cp_r(template, textbook_root) 
    end
  end
  
  class Tools
    
  end
end