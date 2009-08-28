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
    attr_accessor :snippet, :keynote_content

    def initialize(book_dir)
      @textbook = File.expand_path(book_dir)
      @work_dir = File.join(@textbook, "work")
    end
    
    def pack
      new_content = @keynote_content.gsub('${java/Sample.java}', @snippet)
      prez = "sample.key"
      File.open(File.join(@work_dir, prez, "index.apxl"), "w+") do |file|
        file.write new_content
      end
    end

    def unpack
      FileUtils.mkdir_p @work_dir
      Dir[File.join(@textbook, "slides/*.key")].each do |prez|
        FileUtils.cp_r(prez, @work_dir)
        gunzip(File.join(@work_dir, File.basename(prez), "index.apxl.gz"))
        @keynote_content = IO.read(File.join(@work_dir, File.basename(prez), "index.apxl"))
        
        @keynote_content.gsub!('${java/Sample.java}', IO.read(File.join(@textbook, "snippets", 'java/Sample.java')))
        File.open(File.join(@work_dir, File.basename(prez), "index.apxl"), "w+") do |file|
          file.write @keynote_content
        end
      end
    end

    def gunzip(filename)
      system("gunzip --force #{filename}")
    end
  end
end