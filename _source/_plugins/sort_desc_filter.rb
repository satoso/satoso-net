module DescendingSortFilter
  def sort_desc(input, property)
    input.sort { |obj1, obj2|
      obj2.data[property] <=> obj1.data[property]
    }
  end
end

Liquid::Template.register_filter(DescendingSortFilter)
