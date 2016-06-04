require 'capybara'
require 'capybara/poltergeist'
require 'phantomjs'

session = Capybara::Session.new(:poltergeist)
#session = Capybara::Session.new(:selenium)

if ARGV[0] == nil || ARGV[1] == nil
  puts "Usage: ruby polt_crawl.rb username password "
  exit(-1)
end

session.visit "https://mydom.dom.com/siteminderagent/forms/login.fcc"
session.fill_in 'USER', :with => ARGV[0]
session.fill_in 'PASSWORD', :with => ARGV[1]

#only the sign in button
session.all("button")[0].click

#this is the link for sign in, for some reason we need to sign in twice, not sure why.. but only way it works
session.all("a")[2].click

session.fill_in 'USER', :with => ARGV[0]
session.fill_in 'PASSWORD', :with => ARGV[1]

#sign in again
session.all("button")[0].click

## SIGNED IN NOW
# Bill information needed includes:
#
# usage (kWh),  - click anazlye energy usage  look at payementsTable 2nd tr, 3rd td
# bill amount ($),   - home page total ammout due   p span
# service start date =  click anazlye energy usage  look at payementsTable 2nd tr, 1st td
# service end date (also sometimes referred to as the meter read dates),  - find all ps and then pick the one thats meter end date...
# bill due date- home page p

#home page
bill_data = session.all("p")

puts "Bill due date: " + bill_data[0].text
puts "Bill amount: " + bill_data[1].text

#Click analyze energy usage link ( printed all links out to see what number it was, because the links have no ids)
page_links = session.all("a")
page_links[10].click

#analyze page
paymentTable = session.find_by_id("paymentsTable").all("td")

puts "Service start date: "+paymentTable[0].text
puts "Usage (kwh): "+paymentTable[2].text

#only one p element
puts "Next Meter Read date: " + session.all("p")[0].text















