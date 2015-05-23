# encoding: utf-8

require 'test_helper'

class HasPermalinkTest < Minitest::Test
  load_schema

  class Post < ActiveRecord::Base
    has_permalink
  end

  class Page < ActiveRecord::Base
    has_permalink(:title, true)
  end

  class Category < ActiveRecord::Base
    has_permalink(:name)
  end

  class Tag < ActiveRecord::Base
    has_permalink(:name)
  end

  class User < ActiveRecord::Base
    has_permalink(:name, true)

    def name
      "#{first_name} #{last_name}"
    end
  end

  class Department < ActiveRecord::Base
    has_permalink(:name, true)

    def resolve_duplication(permalink, number)
      "#{permalink}-007"
    end
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

  def test_it_can_generate_permalink_form_method
    user = User.new(:first_name => 'Ola', :last_name => 'Karlsson')
    user.valid?
    assert_equal 'ola-karlsson', user.permalink
  end

  def test_throws_record_not_found_for_permalink_parameter
    assert_raises ActiveRecord::RecordNotFound do
      Post.find('some-permalink')
    end
  end

  def test_auto_fix_duplication
    u = User.new(:first_name => 'James', :last_name => 'Bond')
    u.save
    assert_equal 'james-bond', u.permalink

    u = User.new(:first_name => 'James', :last_name => 'Bond')
    u.save
    assert_equal 'james-bond-1', u.permalink

    u = User.new(:first_name => 'James', :last_name => 'Bond')
    u.save
    assert_equal 'james-bond-2', u.permalink

    u = User.new(:first_name => 'James', :last_name => 'Bond')
    u.save
    assert_equal 'james-bond-3', u.permalink

    u = User.new(:first_name => 'James', :last_name => 'Bond')
    u.save
    assert_equal 'james-bond-4', u.permalink

    u = User.new(:first_name => 'James', :last_name => 'Bond')
    u.save
    assert_equal 'james-bond-5', u.permalink

    u = User.new(:first_name => 'James', :last_name => 'Bond')
    u.save
    assert_equal 'james-bond-6', u.permalink

    u = User.new(:first_name => 'James', :last_name => 'Bond')
    u.save
    assert_equal 'james-bond-7', u.permalink

    u = User.new(:first_name => 'James', :last_name => 'Bond')
    u.save
    assert_equal 'james-bond-8', u.permalink

    u = User.new(:first_name => 'James', :last_name => 'Bond')
    u.save
    assert_equal 'james-bond-9', u.permalink

    u = User.new(:first_name => 'James', :last_name => 'Bond')
    u.save
    assert_equal 'james-bond-10', u.permalink

    u = User.new(:first_name => 'James', :last_name => 'Bond')
    u.save
    assert_equal 'james-bond-11', u.permalink

    u = User.new(:first_name => 'James', :last_name => 'Bond')
    u.save
    assert_equal 'james-bond-12', u.permalink
  end

  def test_dont_update_integer_for_self_when_updating
    p = Page.new(:title => 'Awesome Title')
    p.save
    assert_equal 'awesome-title', p.permalink

    same_page = Page.find(p.id)

    same_page.other_attribute = 'A new value'
    same_page.save

    assert_equal 'awesome-title', same_page.permalink
  end

  def test_auto_fix_duplication_with_integer
    d1 = Department.create!(:name => 'Development')
    assert_equal 'development', d1.permalink

    d2 = Department.create!(:name => 'Development-007')
    assert_equal 'development-007', d2.permalink
  end

  def test_fix_duplication_doesnt_add_integers_if_not_needed
    p = Page.new(:title => 'Ruby on Rails')
    p.save
    assert_equal 'ruby-on-rails', p.permalink

    p = Page.new(:title => 'Ruby')
    p.save
    assert_equal 'ruby', p.permalink
  end

  def test_duplication_is_smart
    u = User.new(:first_name => 'Maxwell', :last_name => 'Smart')
    u.save
    assert_equal 'maxwell-smart', u.permalink

    u = User.new(:first_name => 'Maxwell', :last_name => 'Smart')
    u.save
    assert_equal 'maxwell-smart-1', u.permalink

    u = User.new(:first_name => 'Maxwell', :last_name => 'Smart-1')
    u.save
    assert_equal 'maxwell-smart-1-1', u.permalink
  end

  def test_it_doesnt_override_find_with_conditions
    ["development", "ruby", "rails", "node.js", "jquery"].each do |name|
      Tag.create!(:name => name)
    end

    tags = Tag.all
    assert_equal 5, tags.length

    tag = Tag.first
    assert_equal 'development', tag.name

    tags = Tag.where('name LIKE ?', 'r%')
    assert_equal 2, tags.length
  end

  def test_dont_override_find_if_numeric_id
    p = Post.create!(:title => 'Super Awesome Title')
    post = Post.find(p.id)
    refute_nil post
  end

  def test_throws_record_not_found_for_id_parameter
    assert_raises ActiveRecord::RecordNotFound do
      Post.find(999)
    end
  end

  def test_it_finds_record_with_integer_as_permalink
    Post.create!(:title => '1')
    post = Post.find('1')

    refute_nil post
  end
end
