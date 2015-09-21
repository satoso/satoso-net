module YearMonthIndexFilter
  def year_month_index(input)
    input.group_by { |object|
      [object.data['date'].year, object.data['date'].month]
    }
  end
end

Liquid::Template.register_filter(YearMonthIndexFilter)
