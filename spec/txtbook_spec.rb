require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'ftools'
require 'fileutils'

module TxtBook
  describe Factory do    
    it "can create a new TextBook" do
      # DEBT It would be nice if we could mock out the file system module
      # but i'm not sure how to do that. 
      factory = Factory.new
      factory.create(['new-book'])
      File.directory?('new-book').should be_true
      File.directory?('new-book/answers').should be_true
      File.directory?('new-book/exercises').should be_true
      File.directory?('new-book/slides').should be_true
    end
    
    after(:each) do
      FileUtils.rm_rf('new-book')
    end
  end
end