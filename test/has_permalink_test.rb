# encoding: utf-8

require 'test_helper'

class HasPermalinkTest < Test::Unit::TestCase
  load_schema

  class Post < ActiveRecord::Base
    has_permalink
  end

  class Category < ActiveRecord::Base
    has_permalink(:name)
  end

  class User < ActiveRecord::Base
    has_permalink(:name)
  end

  class Department < ActiveRecord::Base
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

  def test_it_generates_useful_permalink_from_nonsense
    post = Post.new(:title => '< /\|/\ > - SÖme REÄLLY CrÅzÛ stÖffzzz!!!! <<<<=======, CÖöL!')
    post.valid?
    assert_equal 'some-really-crazu-stoffzzz-cool', post.permalink
  end

  def test_it_does_not_start_with_a_dash
    post = Post.new(:title => '- Some Title!')
    post.valid?
    assert_equal 'some-title', post.permalink
  end

  def test_it_does_not_end_with_a_dash
    post = Post.new(:title => "äö'äö'ö'å¨¨¨¨ --- ")
    post.valid?
    assert_equal 'aoaooa', post.permalink
  end
end
