require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Workflow
	# Identifier la structure du site
	# Scrapper les valeurs
	# Scrapper les prix
	# hasher les éléments

		doc = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))
			values = doc.css('a.currency-name-container').map do |keys|
				keys.text
	end

#puts values

		doc = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))
			prices = doc.css('a.price').map do |keys|
				keys.text
	end
#puts prices

final_hash = Hash[values.zip(prices)]

puts final_hash