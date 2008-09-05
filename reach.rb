#   Copyright (c) 2008 Ben Woodcroft <donttrustben somewhere near gmail.com>
#
#   This program is free software.
#   You can distribute/modify this program under the terms of
#   the GNU Lesser General Public License version 3.

# The point of this is that the 
# Bookshelf.all.reach.books.each do {|book| puts book.name}
# instead of
# Bookshelf.all.each do |bookshelf|
# bookshelf.books.each do |book|
# puts book.name
# end
# end

# Bookshelf.all.reach is a ReachableArray
# the books is an array (bookshelves) of arrays (books)
class Array
  def reach
    ReachingArray.new(self)
  end
end

class ReachingArray
  # The array that this reaching array is extending. This might
  # be a real Array, or a ReachingArray
  attr_accessor :retract
  
  def initialize(retract)
    @retract = retract
  end
  
  # When a method is called on an array and that method
  # isn't defined for an array, then run 
  # 
  def method_missing(method, *args, &block)
    if @retract.respond_to?(method)
      # If this is an array method, just use that
      r = @retract.send(method, *args, &block)
      return r
    else
      # If this is an object-specific method, run an each on it.
      # A simple each won't work because that doesn't modify the
      # array elements in place as we want, so have to use collect
      # instead.
      @retract = @retract.collect do |o|
        o.send(method, *args, &block)
      end
      return self
    end
  end
  
  # Mainly for testing
  def ==(another)
    @retract <=> another.retract
  end
end
