require 'selenium-webdriver'
require 'mechanize'
require 'csv'
require 'nokogiri'
require 'rubygems'
# set login information
usr = "kuzbassneftfb@yandex.ru"
pwd = "kuzbassneftfb7"
# setup selenium driver with scrapping profile with zenmate
driver = Selenium::WebDriver.for(:firefox, :profile => "default-1463889462883")
# Sleep for setting vpn
sleep 10

# go to login page
driver.get "https://www.linkedin.com/"
# enter log data
elem = driver.find_element(:id,"login-email")
elem.send_keys(usr)
elem = driver.find_element(:id,"login-password")
elem.send_keys(pwd)
elem.submit

# set array for links and ids
hrefs=[]
ids=[]
hrefsall=[]
links_size=[]
idsall=[]
# go through all the search results
for i in 1..100
	hrefs=[]
	# go to search page
	driver.get("https://www.linkedin.com/vsearch/c?f_CCR=ca%3A0&rsid=5015034591464698583986&openFacets=N,CCR,JO,I&orig=FCTD&f_I=57&page_num=#{i}&pt=companies")
	# find links to company pages
	links=driver.find_elements(:class,"main-headline")
	# check how many company links on page
	links_size[i]=links.size
	pp "#{i} page, links: "+links_size[i].to_s
		# open("./3time_oil_energy/search_pages/search_page#{i}.html", "w"){ |f| f.puts page }
	# delete extra symbols from links to make them pretty
	links.each_with_index do |link,i|
		hrefs[i]=link.attribute("href")
		splited=hrefs[i].scan(/\w+|\W+/).select {|x| x.match(/\S/)}
		ids[i]=splited[10]
	end
	# add links from current loop to hrefsall array
	if hrefsall!=nil&&idsall!=nil
		hrefsall+=hrefs
		idsall+=ids
	# save 10 links to file
	File.open("./3time_oil_energy/hrefsall.txt", "w+") do |f|
		hrefsall.each { |element| f.puts(element) }
	end
	# save 10 ids to file
	File.open("./3time_oil_energy/companies_id.txt", "w+") do |f|
		idsall.each { |element| f.puts(element) }
	end
	# add first links and ids
	else
		hrefsall=hrefs[0]
		idsall=ids[0]
	end
end

