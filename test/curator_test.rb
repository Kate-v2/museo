require_relative 'test_helper'

require_relative '../lib/curator'
require_relative '../lib/artist'
require_relative '../lib/photograph'



class CuratorTest < Minitest::Test

  def setup
    @curator = Curator.new

    # ==== Photos ====
    photo_1 = {
      id: "1",
      name: "Rue Mouffetard, Paris (Boy with Bottles)",
      artist_id: "1",
      year: "1954"
    }
    @photo_1 = Photograph.new(photo_1)
    photo_2 = {
      id: "2",
      name: "Moonrise, Hernandez",
      artist_id: "2",
      year: "1941"
    }
    @photo_2 = Photograph.new(photo_2)

    # ==== Artists ====
    artist_1 = {
     id: "1",
     name: "Henri Cartier-Bresson",
     born: "1908",
     died: "2004",
     country: "France"
    }
    @artist_1 = Artist.new(artist_1)
    artist_2 = {
      id: "2",
      name: "Ansel Adams",
      born: "1902",
      died: "1984",
      country: "United States"
    }
    @artist_2 = Artist.new(artist_2)


  end

  def test_it_exists
    assert_instance_of Curator, @curator
  end

  def test_it_gets_defaults_and_attributes
    # -- defaults --
    assert_equal [], @curator.artists
    assert_equal [], @curator.photographs
  end

  def test_it_adds_photosgraphs
    # -- before --
    assert_equal [], @curator.photographs
    # -- after 1 --
    @curator.add_photograph(@photo_1)
    assert_equal [@photo_1], @curator.photographs
    # -- after 2 --
    @curator.add_photograph(@photo_2)
    assert_equal [@photo_1, @photo_2], @curator.photographs
    assert_equal @photo_1, @curator.photographs.first
  end

  def test_it_adds_artists
    # -- before --
    assert_equal [], @curator.artists
    # -- after 1 --
    @curator.add_artist(@artist_1)
    assert_equal [@artist_1], @curator.artists
    # -- after 2 --
    @curator.add_artist(@artist_2)
    assert_equal [@artist_1, @artist_2], @curator.artists
    assert_equal @artist_1, @curator.artists.first
  end

  def test_it_finds_artist_by_id
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    assert_equal @artist_1, @curator.find_artist_by_id("1")
    assert_equal @artist_2, @curator.find_artist_by_id("2")
  end

  def test_it_finds_photograph_by_id
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    assert_equal @photo_1, @curator.find_photograph_by_id("1")
    assert_equal @photo_2, @curator.find_photograph_by_id("2")
  end

end
