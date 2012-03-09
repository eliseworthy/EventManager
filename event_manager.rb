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

  def clean_phone_number(phone_number)
    #phone_number = phone_number.delete(" ,().-")
    phone_number = phone_number.scan(/\d/).join

    if phone_number.length == 10
      phone_number
    elsif phone_number.length == 11 && phone_number.start_with?("1")
      phone_number[1..-1]
    else
      "0"*10
    end
  end  

  def print_numbers
    puts "printing your numbers"
    
    @file.each do |line|
      puts clean_phone_number(line[:homephone])
    end  
  end 

  def print_names_with_numbers
    @file.each do |line|     
      puts [line[:first_name], line[:last_name], clean_phone_number(line[:homephone])].join(" ")
    end  
  end   
end

# Script
em = EventManager.new
em.print_numbers