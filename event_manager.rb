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
      # first_name = line[2]
      # last_name = line[3]
      puts [line[:first_name], line[:last_name]].join(" ")
      
      #prints every line
      #line.inspect

    end  
  end  
end

# Script
em = EventManager.new
em.print_names