# coding: utf-8

require 'test_helper'

class HasPermalinkTest < Test::Unit::TestCase
  load_schema
  
  class Post < ActiveRecord::Base
    has_permalink
  end
  
  class Category < ActiveRecord::Base
    has_permalink(:name)
  end
  
  def test_should_generate_permalink
    post = Post.new(:title => "En annorlunda titel med åäö")
    post.valid?
    assert_equal "en-annorlunda-titel-med-aao", post.permalink
  end
  
  def test_should_not_edit_attribute_if_permalink_is_supplied
    post = Post.new(:title => "En annorlunda titel med åäö", :permalink => "first-post")
    post.valid?
    assert_equal "first-post", post.permalink
  end
  
  def test_should_generate_permalink_from_other_attribute_then_title
    category = Category.new(:name => "some really cool category")
    category.valid?
    assert_equal "some-really-cool-category", category.permalink
  end
  
  def test_should_not_generate_more_than_one_dash
    post = Post.new(:title => "Home - some cool site - some slogan")
    post.valid?
    assert_equal "home-some-cool-site-some-slogan", post.permalink
  end
  
  def test_should_generate_without_callback
    post = Post.new(:title => "Really teasing title")
    post.generate_permalink
    assert_equal "really-teasing-title", post.permalink
  end
  
  def test_force_regeneration
    post = Post.new(:title => "Really teasing title")
    post.valid?
    assert_equal "really-teasing-title", post.permalink
    post.title = "Another title"
    post.valid?
    assert_equal "really-teasing-title", post.permalink
    post.generate_permalink
    assert_equal "really-teasing-title", post.permalink
    post.generate_permalink!
    assert_equal "another-title", post.permalink
  end
end
