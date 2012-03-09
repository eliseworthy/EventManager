# Dependencies
require 'csv'

# Class Definition

class EventManager
  def initialize
    puts "EventManager Initialized!"

    # header converter is used because all keys were strings. This makes them symbols
    # and lowercases them all
    @file = CSV.open('event_attendees.csv', :headers => true, :header_converters => :symbol)
    # @file.each do |line|
    #   puts line.inspect
    # end
  end  

  def print_names
    puts "Printing First and Last Names"
  # go through each line and...
    # get the first name 
    # get the last night
    # print them

    @file.each do |line|

      #prints every line
      #line.inspect
      
      puts [line[:first_name], line[:last_name]].join(" ")
    end  
  end

  def print_numbers
    puts "printing your numbers"

    #for each attendee
    # get the number
    #fix it
    # print it

    @file.each do |line|
      phone_number = line[:homephone]
    end  
  end 
   
end

# Script
em = EventManager.new
em.print_numbers