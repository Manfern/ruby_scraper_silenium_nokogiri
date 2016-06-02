
require 'selenium-webdriver'
require 'mechanize'
require 'nokogiri'

# log in data login:pass usr:pwd
usr = "laundryvend@yandex.ru"
pwd = "laundryvend7"
# all link array
hrefsall=[]
# initialize selenium web driver with firefox profile for using 
# with zenmate or torbrowser
driver = Selenium::WebDriver.for(:firefox, :profile => "scraping")
# sleep for activating zenmate and choosing vpn server
sleep 10
# go to login page
driver.navigate.to "https://www.linkedin.com/"
elem = driver.find_element(:id,"login-email")
elem.send_keys(usr)
elem = driver.find_element(:id,"login-password")
elem.send_keys(pwd)
elem.submit
# load links to companies from file
File.readlines('./3time_oil_energy/prettylinks.html').each_with_index do |link, i|
  hrefsall[i]=link
end

# Get through page and save every page in file.
for i in 0..500
	driver.get(hrefsall[i])
	driver.manage.timeouts.page_load = 30
	page = Nokogiri::HTML(driver.page_source)
	open("./3time_oil_energy/pages/page#{i}.html", "w"){ |f| f.puts page}
	puts "#{i} page is saved"

end
