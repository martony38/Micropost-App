module ApplicationHelper

	# Returns the full title on a per-page basis
	def full_title(page_title = "")
		if page_title.empty?
			website_title
		else
			page_title + " | " + website_title
		end
	end

	def website_title
		"Lolo Cool Website"
	end

end
