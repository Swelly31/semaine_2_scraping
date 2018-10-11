require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Actions successives :
	# identifier la structure des pages dept - communes
	# attraper les villes
	# passer les noms des villes en minuscules
	# remplacer les espaces par des -
	# génération des url
	# scrapping des emails
	# assemblage final


#---------------------------------------------------------------------------
# Scrapper les villes

doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))   
villes = doc.css('a.lientxt').map do |keys|
	keys.text
end

#puts villes


#---------------------------------------------------------------------------
# passer en minuscules les villes

def villes_downcase(array)
	array.map do |n|
		n.downcase
	end
end

villes_downcased = villes_downcase(villes)

#puts villes_downcased


#---------------------------------------------------------------------------

# remplacer les espaces par des -

def villes_sans_espaces(array)
	array.each do |n|
		n.gsub!(/ /,'-')
	end
end

villes_sites = villes_sans_espaces(villes_downcased)

#puts villes_sites


#---------------------------------------------------------------------------

# génération des adresses url à partir des villes "propres"


site_web = villes_sites.map { |e| "http://annuaire-des-mairies.com/95/#{e}.html" } 
#puts site_web



#---------------------------------------------------------------------------

# scrapper les adresses emails

def emails_scrap(array)
	array.map do |mails|
		doc = Nokogiri::HTML(open(mails))
			doc.css('body > div.page > main > section:nth-child(2) > div > table > tbody > tr:nth-child(4) > td:nth-child(2)').text
	end
end


emails = emails_scrap(site_web)

#puts emails


#---------------------------------------------------------------------------

# assemblage du hash final avec villes et adresses emails

final_hash = Hash[villes.zip(emails)]

puts final_hash





