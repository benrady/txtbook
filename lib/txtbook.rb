require 'fileutils'

module TxtBook
  TEXTBOOK_DIRS = ['answers', 'exercises', 'slides']
  
  class Factory
    def create(cmd_line_args)
      textbook_root = cmd_line_args[0]
      TEXTBOOK_DIRS.each do |dir|
        FileUtils.mkdir_p File.join(textbook_root, dir)
      end
      
    end
  end
  
  class Tools
    
  end
end