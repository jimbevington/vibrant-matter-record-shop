require('minitest/autorun')
require('minitest/rg')

require_relative('../models/album.rb')
require_relative('../models/artist.rb')

class TestAlbum < MiniTest::Test

  def setup
    @artist = Artist.new({
      'id' => 1,
      'name' => 'The Fall'
    })
    @album = Album.new({
      'title' => 'This Nations Saving Grace',
      'artist_id' => @artist.id,
      'quantity' => 25,
      'buy_price' => 3,
      'sell_price' => 9
    })
  end

  def test_album_parameters
    assert_equal('This Nations Saving Grace', @album.title)
    assert_equal(1, @album.artist_id)
    assert_equal(25, @album.quantity)
  end

  def test_stock_level__high
    assert_equal('high', @album.stock_level())
  end

  def test_stock_level__medium
    album = Album.new({'quantity' => 12})
    assert_equal('medium', album.stock_level())
  end

  def test_stock_level__low
    album = Album.new({'quantity' => 5})
    assert_equal('low', album.stock_level())
  end

  def test_markup
    assert_equal('200%', @album.markup())
  end

end
