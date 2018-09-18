require_relative 'test_helper'

require_relative '../lib/curator'
require_relative '../lib/artist'
require_relative '../lib/photograph'



class CuratorTest < Minitest::Test

  def setup
    @curator = Curator.new

    # ==== Photos =========================
    photo_1 = {
      id: "1",
      name: "Rue Mouffetard, Paris (Boy with Bottles)",
      artist_id: "1",
      year: "1954"
    }; @photo_1 = Photograph.new(photo_1)

    photo_2 = {
      id: "2",
      name: "Moonrise, Hernandez",
      artist_id: "2",
      year: "1941"
    }; @photo_2 = Photograph.new(photo_2)

    photo_3 = {
      id: "3",
      name: "Identical Twins, Roselle, New Jersey",
      artist_id: "3",
      year: "1967"
    }; @photo_3 = Photograph.new(photo_3)

    photo_4 = {
      id: "4",
      name: "Child with Toy Hand Grenade in Central Park",
      artist_id: "3",
      year: "1962"
    }; @photo_4 = Photograph.new(photo_4)

    # ==== Artists =========================
    artist_1 = {
     id: "1",
     name: "Henri Cartier-Bresson",
     born: "1908",
     died: "2004",
     country: "France"
    }; @artist_1 = Artist.new(artist_1)

    artist_2 = {
      id: "2",
      name: "Ansel Adams",
      born: "1902",
      died: "1984",
      country: "United States"
    }; @artist_2 = Artist.new(artist_2)

    artist_3 = {
      id: "3",
      name: "Diane Arbus",
      born: "1923",
      died: "1971",
      country: "United States"
    }; @artist_3 = Artist.new(artist_3)

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

  def test_it_can_find_photos_by_artist
    # -- add artists --
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    # -- add photos --
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    # -- find --
    diane_arbus = @curator.find_artist_by_id("3")
    found = @curator.find_photographs_by_artist(diane_arbus)
    assert_equal [@photo_3, @photo_4], found
  end

  def test_it_can_find_artists_with_more_than_one_work
    # -- add artists --
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    # -- add photos --
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    # -- find --
    found = @curator.artists_with_multiple_photographs
    assert_equal [@artist_3], found
  end

  def test_it_can_find_photos_taken_by_artists_from_a_specific_country
    # -- add artists --
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    # -- add photos --
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    # -- find --
    found = @curator.photographs_taken_by_artists_from("United States")
    assert_equal [@photo_2, @photo_3, @photo_4], found
    not_found = @curator.photographs_taken_by_artists_from("Argentina")
    assert_equal [], not_found
  end

  def test_it_can_load_from_csv
    path = './data/photographs.csv'
    # id,name,artist_id,year
    # 1,"Rue Mouffetard, Paris (Boy with Bottles)",1,1954
    data = @curator.load_from_csv(path)
    keys = [:id, :name, :artist_id, :year]
    first = data.first
    assert_equal keys, first.keys
    assert_equal "1", first[:id]
    name = "Rue Mouffetard, Paris (Boy with Bottles)"
    assert_equal name, first[:name]
    assert_equal "1", first[:artist_id]
    assert_equal "1954", first[:year]
  end

  def test_it_can_make_a_hash
    headers = ["1", "2"]
    data = ["a", "b"]
    hash = { :"1" => "a", :"2" => "b"}
    assert_equal hash, @curator.make_hash(headers, data)
  end

  def test_it_can_load_photos_from_csv
    before = @curator.photographs
    assert_equal 0, before.count
    after = @curator.photographs
    path = './data/photographs.csv'
    @curator.load_photographs(path)
    assert_equal 4, after.count
  end

  def test_it_can_load_artists_from_csv
    before = @curator.artists
    assert_equal 0, before.count
    after = @curator.artists
    path = './data/artists.csv'
    @curator.load_artists(path)
    assert_equal 6, after.count
  end


end
