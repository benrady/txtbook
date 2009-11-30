require 'fileutils'

module TxtBook
  class Factory
    def self.create(cmd_line_args)
      textbook_root = cmd_line_args[0]

      # DEBT Move to member var
      template = File.join(File.dirname(__FILE__), 'txtbook', 'new_book_template')
      FileUtils.cp_r(template, textbook_root) 
    end
  end
  
  class KeynoteBuilder
    attr_accessor :snippets, :keynote_content, :work_dir

    def initialize(book_dir)
      @textbook = File.expand_path(book_dir)
      @work_dir = File.join(@textbook, "work")
    end

    def unbind
      FileUtils.mkdir_p @work_dir
      Dir[File.join(@textbook, "slides/*.key")].each do |preso|
        copy_to_working_dir(preso)
        
        gunzip(File.join(@work_dir, File.basename(preso), "index.apxl.gz"))

        content_file = File.join(@work_dir, File.basename(preso), "index.apxl")
        @keynote_content = IO.read(content_file)
      end
    end
    
    def press
      @keynote_content.scan(/\$\{(.+?)\}/).each do |template|
        @keynote_content.gsub!("${#{template}}", IO.read("snippets/#{template}"))
      end
    end
    
    def rebind
      Dir[File.join(@work_dir, "*.key")].each do |preso|
        File.open(File.join(@work_dir, File.basename(preso), "index.apxl"), "w+") do |file|
          file.write @keynote_content
        end
      end
    end

    def gunzip(filename)
      Kernel.system("gunzip --force #{filename}")
    end

    private

      def copy_to_working_dir(preso)
        FileUtils.cp_r(preso, @work_dir)
      end
  end
end
