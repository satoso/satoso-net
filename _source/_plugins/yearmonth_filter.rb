module YearMonthFilter
  def where_year_month(input, year, month)
    input.select { |object|
      object.data['date'].year == year && object.data['date'].month == month
    }
  end
end

Liquid::Template.register_filter(YearMonthFilter)
