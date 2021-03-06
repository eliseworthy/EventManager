# Dependencies
$LOAD_PATH << './'
#load things in the current directory with ./
require 'csv'
require 'sunlight'
require 'attendee'

# Class Definition

class EventManager
  CSV_OPTIONS = {:headers => true, :header_converters => :symbol}
  INVALID_ZIP = "00000"
  INVALID_PHONE = "0"*10

  Sunlight::Base.api_key = "e179a6973728c4dd3fb1204283aaccb5"

  attr_accessor :attendees

  def initialize(filename, options = CSV_OPTIONS)
    puts "EventManager Initialized!"

    load_attendees(CSV.open(filename, options))
  end 

  def print_names
    puts "Printing First and Last Names"
 
    attendees.each do |attendee|
      puts attendee.full_name
    end
  end

  def print_numbers
    puts "printing your numbers"
    
    attendees.each do |attendee|
      puts attendee.phone_number
    end  
  end 

  def print_names_with_numbers
    attendees.each do |attendee|     
      puts [attendee.first_name, attendee.last_name, attendee.phone_number].join(" ")
    end  
  end 

  def print_zips
    puts "printing the zips"
    
    attendees.each do |attendee|
      puts attendee.zipcode
    end
  end 

  #methods below haven't been refactored

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

  def rank_times
    hours = Array.new(24){0}
    @file.each do |line|
      time = line[:regdate].split(" ")
      hour = time[1].split(":")
      hour = hour[0]
      # below does the same as hours[hour.to_i] = hours[hour.to_i] + 1
      hours[hour.to_i] += 1
    end
    hours.each_with_index{|counter,hour| puts "#{hour}\t#{counter}"}
  end 

  def state_stats
    state_data = {}
    @file.each do |line|
      state = line[:state]

      # below produces the same result as
      # if state_data[state].nil?
      #   state_data[state] = 1
      # else
      #   state_data[state] += 1 
      # end  
      state_data[state] ||= 0
      state_data[state] += 1
    end
    state_data
  end

  def state_stats_by_state
    state_data = state_stats
    puts state_data.inspect
    # I don't understand how this works. It came from SO 
    # because the code from the tutorial didn't work.
    state_data = state_data.sort_by{|state_abbr, counter| state_abbr.nil? ? "ZZ" :state_abbr }
    state_data.each do |state_abbr,counter|
      puts "#{state_abbr}: #{counter}"
    end
  end

  def state_stats_by_count
    # state_data = {}
    # @file.each do |line|
    #   state = line[:state]

    #   # below produces the same result as
    #   # if state_data[state].nil?
    #   #   state_data[state] = 1
    #   # else
    #   #   state_data[state] += 1 
    #   # end  
    #   state_data[state] ||= 0
    #   state_data[state] += 1
    # end

    state_data = state_stats

    state_data = state_data.sort_by{|state_abbr, counter| counter }.reverse
    state_data.each do |state_abbr,counter|
      puts "#{state_abbr}: #{counter}"
    end  
  end 

  def alpha_with_rank
    state_data = state_stats

    ranks = state_data.sort_by{|state_abbr, counter| counter}.collect{|state_abbr, counter| state_abbr}
    state_data = state_data.sort_by{|state_abbr, counter| state_abbr.nil? ? "ZZ" :state_abbr }

    state_data.each do |state_abbr, counter|
      puts "#{state_abbr}:\t#{counter}\t(#{ranks.index(state_abbr) + 1})"
    end
  end
end

private
#implementation methods below
  
def load_attendees(file)
  file.rewind
  # self represents the object we're inside 
  # we need to load attendees on an instance of event_manager
  self.attendees = file.collect { |line| Attendee.new(line) }
end

# Script
em = EventManager.new("cleaned_attendees.csv")
#em.output_data("cleaned_attendees.csv")
em.print_names_with_numbers