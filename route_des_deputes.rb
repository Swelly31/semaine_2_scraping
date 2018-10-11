require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Workflow
# identifier le site à scrapper = https://www.nosdeputes.fr/deputes
# scrapper les noms et prénoms des députés dans une liste de noms
# passer noms et prénoms en minuscules
# retirer les 6 caractères avant noms et prénoms


# on scrappe la liste brute des députés

doc = Nokogiri::HTML(open("https://www.nosdeputes.fr/deputes"))
			rough_deputes = doc.css('span.list_nom').map do |keys|
				keys.text
	end

#puts rough_deputes

# on met cette liste en minuscule

def downcase_deputes(array)
	array.map do |n|
		n.downcase
	end
end

downcased_deputes = downcase_deputes(rough_deputes)

#puts downcased_deputes

# on enlève les espaces dans cette string de députés

def liste_sans_espaces(array)
	array.each do |n|
		n.lstrip!
		n.rstrip!
	end
end

liste_propre_avec_carac_spéciaux = liste_sans_espaces(downcased_deputes)

#puts liste_propre_avec_carac_spéciaux


# on enlève les caractèqes spéciaux
def caracteres(array)
	array.each do |n|
		n.gsub!(/é/,'e')
		n.gsub!(/è/,'e')
		n.gsub!(/ç/,'c')
		n.gsub!(/ï/,'i')
		n.gsub!(/ë/,'e')
		n.gsub!(/ /,'-')
		n.gsub!(/ö/,'oe')
		n.gsub!(/'/,'-')

	end
end

liste_propre_sans_éèçi = caracteres(liste_propre_avec_carac_spéciaux)

#puts liste_propre_sans_éèçi[0]

# ---------------------------------------------------------
# on split les noms et prénoms dans 2 arrays

def prenoms(array)
	array.map do |n|
		n.partition(",-").last
	end
end

liste_prenoms = prenoms(liste_propre_sans_éèçi)

#print liste_prenoms

def noms(array)
	array.map do |n|
		n.partition(",").first
	end
end

liste_noms = noms(liste_propre_sans_éèçi)

#puts liste_noms
# ---------------------------------------------------------

# génération des urls

urls = liste_noms.zip(liste_prenoms).map { |noms, prenoms| "https://www.nosdeputes.fr/#{prenoms}-#{noms}"}

#puts urls

# scrapping des adresse emails

=begin
def emails_scrap(array)
    array.map do |emails|
doc = Nokogiri::HTML(open(emails))
emails_deputes = doc.css('#b1 > ul:nth-child(4) > li:nth-child(1) > ul > li:nth-child(1) > a').text
    end
end

emails = puts emails_scrap(urls)
=end


# !!!! Enlever le commentaire au dessus si besoin de rescrapper les mails. Sinon ils sont stockés dans un fichier 
# "emails.txt" !!!!

emails = File.readlines("emails.txt")

def emails_remove_n(array)
    array.map do |n|
        n.delete("/\n/")
    end
end

emails_final = emails_remove_n(emails)

def capitalize(array)
    array.map do |n|
        n.capitalize
    end
end

noms_capital = capitalize(liste_noms)
prenoms_capital = capitalize(liste_prenoms)

array_final = []
x = 0

while x < prenoms_capital.size
    array_final << { "Prénoms" => prenoms_capital[x], "Noms" => noms_capital[x], "email" => emails_final[x] }
      puts "\n***************************************************************************************************************************"
      puts array_final[x]
      puts "***************************************************************************************************************************\n"
    x += 1
end


