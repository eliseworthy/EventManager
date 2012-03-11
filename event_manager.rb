# Dependencies
require 'csv'
require 'sunlight'

# Class Definition

class EventManager
  INVALID_ZIP = "00000"
  INVALID_PHONE = "0"*10

  Sunlight::Base.api_key = "e179a6973728c4dd3fb1204283aaccb5"


  def initialize(filename)
    puts "EventManager Initialized!"

    # header converter is used because all keys were strings. This makes them symbols
    # and lowercases them all
    @file = CSV.open(filename, :headers => true, :header_converters => :symbol)
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
      INVALID_PHONE
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

  def clean_zip(zip)
    #read the zip
     #if five digits
       #print zip
     #else less than 5 digits
       #add zeros to the front until 5 digits
    if zip.nil?
      zip = INVALID_ZIP  
    else 
      while zip.length < 5
        zip = '0' + zip
      end 
    end     
    zip
  end  

  def print_zips
    puts "printing the zips"
    
    @file.each do |line|
      puts clean_zip(line[:zipcode])
    end  
  end 

  def output_data(filename)
    output = CSV.open(filename, "w")
    @file.each do |line|
     
     # I don't think adding headers works
      if @file.lineno == 2
        output << line.headers
      else  
      end  
    line[:homephone] = clean_phone_number(line[:homephone])
    line[:zipcode] = clean_zip(line[:zipcode])
    output << line  
    end
  end 
   
  # def rep_lookup
  #   20.times do
  #     line = @file.readline

  #     representatives = Sunlight::Legislator.all_in_zipcode(clean_zip(line[:zipcode]))
  #     #api lookup goes here
  #     rep_names = representatives.collect do |rep|
  #       title = rep.title
  #       first_name = rep.firstname
  #       first_initial = first_name[0]
  #       last_name = rep.lastname
  #       party = rep.party
  #       title + " " + first_initial + ". " + last_name + " (" + party + ")"
  #     end  
  #      puts "#{line[:last_name]}, #{line[:first_name]}, #{line[:zipcode]}, #{rep_names.join(", ")}"
  #   end
  # end  

  def create_form_letters
   letter = File.open("form_letter.html", "r").read
    20.times do
      line = @file.readline

      custom_letter = letter.gsub("#first_name", line[:first_name])
      custom_letter = custom_letter.gsub("#last_name", line[:last_name])
      custom_letter = custom_letter.gsub("#street", line[:street])
      custom_letter = custom_letter.gsub("#city", line[:city])
      custom_letter = custom_letter.gsub("#state", line[:state])
      custom_letter = custom_letter.gsub("#zipcode", clean_zip(line[:zipcode]))

      filename = "output/thanks_#{line[:last_name]}_#{line[:first_name]}.html"
      output = File.new(filename, "w")
      output.write(custom_letter)
    end
  end 
end

# Script
em = EventManager.new("event_attendees.csv")
#em.output_data("cleaned_attendees.csv")
em.create_form_letters