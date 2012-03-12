require 'ostruct'

class Attendee < OpenStruct
  #OpenStruct allows us to do regular method calls (we can remove the hash keys)
  def initialize(attributes)
    super
  end

  def full_name
    [first_name, last_name].join(" ") 
  end  
end
