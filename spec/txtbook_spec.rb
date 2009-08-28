require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'ftools'
require 'fileutils'

#Inspiration: 
# http://github.com/skippy/s3_rake_tasks/tree/master
# http://github.com/smtlaissezfaire/smt_rake_tasks/blob/a8137b860a6fa113a8ffcdb827012aaca9b62087/git.rb

module TxtBook
  describe Factory do    
    it "can create a new TextBook" do
      # DEBT It would be nice if we could mock out the file system module
      # but i'm not sure how to do that. 
      Factory.create(['new-book'])
      File.directory?('new-book').should be_true
      File.directory?('new-book/answers').should be_true
      File.directory?('new-book/exercises').should be_true
      File.directory?('new-book/slides').should be_true
      File.exists?('new-book/Rakefile').should be_true
    end
    
    after(:each) do
      FileUtils.rm_rf('new-book')
    end
  end
  
  describe KeynoteBuilder do
    before(:each) do
      Factory.create(['temp-book'])
      @builder = KeynoteBuilder.new('temp-book')
    end
    
    it "should unpack keynote09 files"
    
    it "should unpack keynote08 files" do
      @builder.unpack
      File.directory?('temp-book/work/sample.key').should be_true
      File.exists?('temp-book/work/sample.key/index.apxl').should be_true
    end
    
    it "should insert code snippets into slides" do
      @builder.unpack
      keynote_xml = IO.read('temp-book/work/sample.key/index.apxl')
      keynote_xml.include?("public class Sample").should be_true
    end
    
    it "should repack the new keynote content" do
      full_file_path_to_prez = File.expand_path(File.dirname(__FILE__) + "/../temp-book/work/sample.key/index.apxl")
      
      file = mock(File)
      file.should_receive(:write).with("My Fake Java")
      File.should_receive(:open).with(full_file_path_to_prez, "w+").and_yield(file)
      
      builder = KeynoteBuilder.new("temp-book")
      builder.snippet = "My Fake Java"
      builder.keynote_content = "${java/Sample.java}"
      builder.pack
      
    end
    
    after(:each) do
      FileUtils.rm_rf('temp-book')
    end
  end
end