class Admin < User
	include Gravtastic

	gravtastic :email,
	  :secure => true,
	  :filetype => :png,
	  :size => 15
end