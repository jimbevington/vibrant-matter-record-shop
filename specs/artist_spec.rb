require('minitest/autorun')
require('minitest/rg')

require_relative('../models/artist.rb')

class TestArtist < MiniTest::Test

  def setup
    @artist = Artist.new({
      'id' => 1,
      'name' => 'The Fall'
    })
  end

  def test_artist_has_parameters
    assert_equal(1, @artist.id)
    assert_equal('The Fall', @artist.name)
  end

end
