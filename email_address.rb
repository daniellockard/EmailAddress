# This class is used to validate email 
# addresses. When you create an email address
# It will throw an "EmailAddressError" if the email is
# invalid
#
# Author:: Danny Lockard (mailto:danielhlockard@gmail.com)
# Copyright:: Copyright (c) 2011 Daniel Lockard
# License:: Distributes under the same terms as Ruby

class EmailAddress < String
	# Validation is done here, as well as spliting into parts
	def initialize(str)
		unless str =~  EmailAddressRegex
			raise EmailAddressError, "Invalid Email Address", caller
		else
			@email = str
			@unf = str.split('@')[0]
			@dmn = str.split('@')[1]
			if str.include? "+"
				filter_pre_strip = str.split('+')[1]
				@filter = filter_pre_strip.split('@')[0]
				@un = str.split('+')[0]
			else
				@un = @unf
			end
		end
	end

	# returns the email address
	def email
		return @email
	end

	# The username with any filter 
	# * blah+blah@blah.com will return blah+blah
	def username_with_filter
		return @unf
	end
	# Just returns the filter portion of the email
	# * blah+filter@blah.com returns filter
	def filter
		return @filter
	end

	# Returns the username portion of the address
	# * name+filter@blah.com will return name
	def username
		return @un
	end

	# Returns the domain portion of the email address
	# * name+filter@blah.com returns blah.com
	def domain
		return @dmn
	end

	# This regex is awesome, it actually does a lot of the
	# heavy lifting and validating for you
		EmailAddressRegex = begin
    qtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]'
    dtext = '[^\\x0d\\x5b-\\x5d\\x80-\\xff]'
    atom = '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-' +
      '\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+'
    quoted_pair = '\\x5c[\\x00-\\x7f]'
    domain_literal = "\\x5b(?:#{dtext}|#{quoted_pair})*\\x5d"
    quoted_string = "\\x22(?:#{qtext}|#{quoted_pair})*\\x22"
    domain_ref = atom
    sub_domain = "(?:#{domain_ref}|#{domain_literal})"
    word = "(?:#{atom}|#{quoted_string})"
    domain = "#{sub_domain}(?:\\x2e#{sub_domain})*"
    local_part = "#{word}(?:\\x2e#{word})*"
    addr_spec = "#{local_part}\\x40#{domain}"
    pattern = /\A#{addr_spec}\z/
  end


	# Custom Error Class
	# Doesn't do anything fancy, yet
	class EmailAddressError < ArgumentError
	end

end
