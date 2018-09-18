require 'pry'






class Artist

  attr_reader :id, :name, :born, :died, :country

  def initialize(hash)
    @id      = hash[:id]
    @name    = hash[:name]
    @born    = hash[:born]
    @died    = hash[:died]
    @country = hash[:country]
  end

  



end
