module ApplicationHelper
	def hilite?(column)
		column == sort_column ? "hilite" : nil		
	end
end
