require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'ftools'
require 'fileutils'

#Inspiration: 
# http://github.com/skippy/s3_rake_tasks/tree/master
# http://github.com/smtlaissezfaire/smt_rake_tasks/blob/a8137b860a6fa113a8ffcdb827012aaca9b62087/git.rb

module TxtBook
  describe Factory do    
    it "can create a new TextBook" do
      template = './spec/../lib/txtbook/new_book_template'
      FileUtils.should_receive(:cp_r).with(template, 'new-book').ordered
      Factory.create(['new-book'])
    end
  end
  
  describe KeynoteBuilder do
    before(:each) do
      Factory.create(['temp-book'])
      @builder = KeynoteBuilder.new('temp-book')
    end
    
    it "should copy the keynote08 template to a working directory" do
      FileUtils.should_receive(:cp_r).with(full_path_to_textbook("slides/sample.key"),
                                      full_path_to_textbook("work")).ordered
      IO.should_receive(:read).ordered
      
      @builder.unbind
    end
    
    it "should unbind keynote09 files"
    
    it "should unbind keynote08 files" do
      IO.stub!(:read).with(full_path_to_keynote("index.apxl")).and_return("${java/Sample.java}")
      @builder.unbind
      @builder.keynote_content.should == "${java/Sample.java}"
    end
            
    it "should insert code snippets into keynote content" do
      @builder.keynote_content = "${java/JavaSample.java}"
      IO.stub!(:read).with("snippets/java/JavaSample.java").and_return("public class JavaSample")
      
      @builder.press
      
      @builder.keynote_content.should include("public class JavaSample")
    end
    
    it "should replace multiple code snippet templates in keynote content" do
      @builder.keynote_content = "${java/Snippet1.java} other stuff ${java/Snippet2.java}"
      IO.should_receive(:read).with("snippets/java/Snippet1.java").and_return("Snippet1")
      IO.should_receive(:read).with("snippets/java/Snippet2.java").and_return("Snippet2")
      
      @builder.press
      
      @builder.keynote_content.should include("Snippet1 other stuff Snippet2")
    end
    
    it "should repack the new keynote content" do      
      @builder.keynote_content = "My Fake Java"
      Dir.should_receive(:[]).with("#{@builder.work_dir}/*.key").and_return(['prez.key'])
      file = mock(File)
      file.should_receive(:write).with("My Fake Java")
      File.should_receive(:open).with(full_path_to_textbook("work/prez.key/index.apxl"), "w+").and_yield(file)
      
      @builder.rebind
    end
    
    def full_path_to_textbook(filepath)
      File.expand_path(File.dirname(__FILE__) + "/../temp-book/#{filepath}")
    end
    
    def full_path_to_keynote(filename)
      full_path_to_textbook("work/sample.key/#{filename}")
    end
    
    after(:each) do
      FileUtils.rm_rf('temp-book')
    end
  end
end