require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Actions successives :
	# Identifier la structure des pages dept - communes
	# Attraper les villes
	# Passer les noms des villes en minuscules
	# Remplacer les espaces par des -
	# 


doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))   
villes = doc.css('a.lientxt').map do |keys|
	keys.text
end

#puts villes
# J'ai mes villes

def villes_downcase(array)
	array.map do |n|
		n.downcase
	end
end

villes_downcased = villes_downcase(villes)

#puts villes_downcased
# Je les passe en minuscules

def villes_sans_espaces(array)
	array.each do |n|
		n.gsub!(/ /,'-')
	end
end
# Methode qui remplace tous les espaces par des - dans un array

villes_sites = villes_sans_espaces(villes_downcased)

#puts villes_sites

# Application de la méthode sur mon array des villes


site_web = villes_sites.map { |e| "http://annuaire-des-mairies.com/95/#{e}.html" } 

#puts site_web

# Créé un array avec chaque site web de chaque ville

def emails_scrap(array)
	array.map do |mails|
		doc = Nokogiri::HTML(open(mails))
			doc.css('body > div.page > main > section:nth-child(2) > div > table > tbody > tr:nth-child(4) > td:nth-child(2)').text
	end
end

# Loop sur chaque site de mon array dans nokogiri pour aller chercher les mails de ces villes

emails = emails_scrap(site_web)

#puts emails

final_hash = Hash[villes.zip(emails)]

puts final_hash[0]





