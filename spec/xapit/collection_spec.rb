require File.dirname(__FILE__) + '/../spec_helper'

describe Xapit::Collection do
  describe "with database" do
    before(:each) do
      XapitMember.delete_all
      XapitMember.xapit do |index|
        index.text :name
        index.field :name
      end
      path = File.dirname(__FILE__) + '/../tmp/xapiandb'
      FileUtils.rm_rf(path) if File.exist? path
      @db = Xapian::WritableDatabase.new(path, Xapian::DB_CREATE_OR_OVERWRITE)
    end
    
    describe "indexed" do
      before(:each) do
        @hello = XapitMember.new(:name => "hello world")
        @foo = XapitMember.new(:name => "foo bar world")
        Xapit::IndexBlueprint.index_all(@db)
      end
      
      it "should find all xapit members in database given empty string" do
        Xapit::Collection.new(XapitMember, "", :database => @db).should == [@hello, @foo]
      end
      
      it "should matching xapit member given a word" do
        Xapit::Collection.new(XapitMember, "foo", :database => @db).should == [@foo]
      end
    end
  end
end