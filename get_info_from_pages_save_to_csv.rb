# gem for scraping css
require 'nokogiri'
require 'rubygems'
require 'active_record'  
require "csv"


company={}
# used if some pages save incorrectly or in russian
# pages=[0,1,9,10,20,21]
# pages.each do |i|

# READ FROM FILES page1.html-page500.html
for i in 0..500
	
	doc = Nokogiri::HTML(open("./3time_oil_energy/pages/page#{i}.html", "r"))
	puts "parsing page #{i}"
	puts "Russian! page #{i}" if doc.css('li#nav-home a').first.text.strip=="Главная"

	# companies[:id]=doc.at('[@name="currenturl"]').to_s.split("%3Ftrk%3Dvsrp_companies")[0].split("company%2F")[1]
	
	company[:name]=doc.css('h1.name span').text
	company[:website]=doc.css('li.website a').text
	company[:industry]=industry=doc.css('li.industry p').text
	company[:type]=doc.css('li.type p').text
	company[:headquarters]=doc.css('li.vcard p').text
	company[:company_size]=doc.css('li.company-size p').text
	company[:specialties]=doc.css('div.specialties p').text

	# create csv file and save to it
	CSV.open("./3time_oil_energy/linked_companies_oil_energy_02_06.csv", "a+") do |csv|
		csv << ["name", "website", "industry","company_type","headquarters","company_size","specialties"] if i==0
		csv << [company[:name], company[:website], company[:industry],company[:type], company[:headquarters], company[:company_size], company[:specialties]]
	end
end
