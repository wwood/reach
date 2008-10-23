#   Copyright (c) 2008 Ben Woodcroft <donttrustben somewhere near gmail.com>
#
#   This program is free software.
#   You can distribute/modify this program under the terms of
#   the GNU Lesser General Public License version 3.


$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'reach'

class ReachTest < Test::Unit::TestCase
  def setup
    @one_level = %w(a b c)
    @two_level = [[1,2,3],[5]]
  end
  
  def test_normality
    # Test arrays seem normal - this is kinda pointless I would say
    index = 0
    @one_level.each { |n|
      assert_equal @one_level[index], n
      index += 1
    }
  end
  
  def test_simple_method
    out = @one_level.reach.succ!
    assert_kind_of ReachingArray, out
    assert_equal ReachingArray.new(%w(b c d)), out
  end
  
  def test_scoping_one
    assert_equal ReachingArray.new(%w(c d e)), @one_level.reach.succ!.succ!
  end
  
  def test_collect
    assert_equal %w(b c d), @one_level.reach.collect{|c| c.succ}
  end

  # Catches if the array elements are not modified within the reach
  def test_double_scope
    # make sure my assumptions are correct about the
    # classes being tested
    assert 1.respond_to?(:zero?)
    assert_equal false, '1'.respond_to?(:zero?)
    
    # make sure that the array elements are being reversed
    str = ['0','2','3']
    assert_equal [0,2,3], str.reach.to_i.retract
    assert_equal [true, false, false], str.reach.to_i.zero?.retract
  end
  
  def test_block_accepted
    assert_equal %w(d e f), @one_level.reach.succ.collect{|c| c.succ.succ}
  end
  
  def test_to_s
    assert_equal [1,2].to_s, [1,2].reach.to_s
  end
end

class SlapTest < Test::Unit::TestCase
  def setup
    @one_level = %w(a b c)
    @two_level = [[1,2,3],[5]]
  end
  
  def test_simple
    assert_kind_of SlappingArray, @two_level.slap
    
    assert_equal [3,1], @two_level.slap.length.retract
  end
end
