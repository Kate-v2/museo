require 'pry'







class Curator

  attr_reader :artists, :photographs

  def initialize
    @artists     = []
    @photographs = []
  end

  def add_photograph(photo)
    @photographs << photo
  end

  def add_artist(artist)
    @artists << artist
  end

  def find_artist_by_id(id)
    @artists.find { |artist| artist.id == id }
  end

  def find_photograph_by_id(id)
    @photographs.find { |photo| photo.id == id }
  end

  def find_photographs_by_artist(artist)
    @photographs.find_all { |photo| photo.artist_id == artist.id }
  end

  def artists_with_multiple_photographs
    groups = @photographs.group_by { |photo| photo.artist_id }
    ids = groups.find_all { |id, works| works.count > 1 }.to_h.keys
    list = @artists.find_all { |artist| ids.include?(artist.id) }
  end

  def photographs_taken_by_artists_from(country)
    photogs = @artists.find_all { |photog| photog.country == country }
    list = photogs.map { |photog| find_photographs_by_artist(photog) }.flatten
  end

end
