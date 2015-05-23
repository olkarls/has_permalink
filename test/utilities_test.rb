# encoding: utf-8

require 'test_helper'
require 'utilities'

class NotNestedList < ActiveRecord::Base
  has_permalink
end

module Dummy
  class NestedInDummyList < ActiveRecord::Base
    has_permalink
  end
end

module Another
  module Dummy
    class NestedInAnotherDummyList < ActiveRecord::Base
      has_permalink
    end
  end
end

class UtilitiesTest < Minitest::Test
  def test_it_can_find_classes
    util = HasPermalink::Utilities.new('NotNestedList')
    assert_equal(util.klass, NotNestedList)
  end

  def test_it_can_find_classes_in_modules
    util = HasPermalink::Utilities.new('Dummy::NestedInDummyList')
    assert_equal(util.klass, Dummy::NestedInDummyList)
  end

  def test_it_can_find_classes_in_nested_modules
    util = HasPermalink::Utilities.new('Another::Dummy::NestedInAnotherDummyList')
    assert_equal(util.klass, Another::Dummy::NestedInAnotherDummyList)
  end

  def test_it_can_generate_permalinks
    tables = ['not_nested_lists', 'nested_in_dummy_lists', 'nested_in_another_dummy_lists']
    names = ['a list', 'another list', 'and a third one']

    conn = ActiveRecord::Base.connection

    tables.each do |table|
      names.each do |name|
        conn.insert_sql("INSERT INTO #{table} (title) VALUES('#{name}')")
      end
    end

    conn.close

    assert_equal(NotNestedList.first.permalink, nil)
    assert_equal(Dummy::NestedInDummyList.first.permalink, nil)
    assert_equal(Another::Dummy::NestedInAnotherDummyList.first.permalink, nil)

    util = HasPermalink::Utilities.new('NotNestedList')
    util.generate_permalinks

    util = HasPermalink::Utilities.new('Dummy::NestedInDummyList')
    util.generate_permalinks

    util = HasPermalink::Utilities.new('Another::Dummy::NestedInAnotherDummyList')
    util.generate_permalinks

    assert_equal(NotNestedList.first.permalink, 'a-list')
    assert_equal(Dummy::NestedInDummyList.first.permalink, 'a-list')
    assert_equal(Another::Dummy::NestedInAnotherDummyList.last.permalink, 'and-a-third-one')
  end
end