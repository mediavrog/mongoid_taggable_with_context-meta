require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class MyModel
  include Mongoid::Document
  include Mongoid::TaggableWithContext
  include Mongoid::TaggableWithContext::Meta

  taggable :with_meta => true
  taggable :artists, :with_meta => true
end

describe Mongoid::TaggableWithContext::Meta do

  context "handling with_meta with tags" do
    before :each do
      @m = MyModel.new
    end

    it "should not interfere with tags retrieval" do
      @m.tags_array = %w[tag1 tag2]
      @m.add_tag_with_meta('tag_with_meta', {:key => 'meep', :key2 => 'meep2'})

      @m.tags_array.should == %w[tag1 tag2 tag_with_meta]
    end

    it "should provide method to retrieve only tags with with_meta information as array" do
      @m.tags_array = %w[tag1 tag2]
      @m.add_tag_with_meta('tag_with_meta', {:key => 'meep', :key2 => 'meep2'})
      @m.add_tag_with_meta('tag_with_meta_2', {:key => 'meep_t2', :key2 => 'meep2_t2'})

      @m.tags_having_meta.should == 'tag_with_meta tag_with_meta_2'
    end

    it "should provide method to retrieve only tags with with_meta information as string" do
      @m.tags_array = %w[tag1 tag2]
      @m.add_tag_with_meta('tag_with_meta', {:key => 'meep', :key2 => 'meep2'})
      @m.add_tag_with_meta('tag_with_meta_2', {:key => 'meep_t2', :key2 => 'meep2_t2'})

      @m.tags_having_meta_array.should == %w[tag_with_meta tag_with_meta_2]
    end

    it "should provide method to retrieve only tags with with_meta information as objects as array" do
      @m.tags_array = %w[tag1 tag2]
      @m.add_tag_with_meta('tag_with_meta', {:key => 'meep', :key2 => 'meep2'})
      @m.add_tag_with_meta('tag_with_meta_2', {:key => 'meep_t2', :key2 => 'meep2_t2'})

      @m.tags_having_and_including_meta.should == [
          ['tag_with_meta', {:key => 'meep', :key2 => 'meep2'}],
          ['tag_with_meta_2', {:key => 'meep_t2', :key2 => 'meep2_t2'}]
      ]
    end

    it "should provide method to retrieve all tags with with_meta information (if available) as objects as array" do
      @m.tags_array = %w[tag1 tag2]
      @m.add_tag_with_meta('tag_with_meta', {:key => 'meep', :key2 => 'meep2'})
      @m.add_tag_with_meta('tag_with_meta_2', {:key => 'meep_t2', :key2 => 'meep2_t2'})

      @m.tags_including_meta.sort.should == [
          ['tag1', {}],
          ['tag2', {}],
          ['tag_with_meta', {:key => 'meep', :key2 => 'meep2'}],
          ['tag_with_meta_2', {:key => 'meep_t2', :key2 => 'meep2_t2'}]
      ].sort
    end

    it "should set with_meta for an existing tag"
    it "should erase with_meta for deleted tag"
  end

  context "respecting context" do
    before :each do
      @m = MyModel.new
    end

    it "should show proper tags" do
      @m.tags_array = %w[tag1 tag2]
      @m.add_tag_with_meta('tag_with_meta', {:key => 'meep', :key2 => 'meep2'})

      @m.artists_array = %w[artist1 artist2]
      @m.add_artist_with_meta('artist_with_meta', {:key => 'meep', :key2 => 'meep2'})

      @m.tags_array.should == %w[tag1 tag2 tag_with_meta]
      @m.artists_array.should == %w[artist1 artist2 artist_with_meta]
    end

  end
end