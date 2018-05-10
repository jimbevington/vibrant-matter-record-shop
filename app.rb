require('sinatra')
require('sinatra/contrib/all')

require_relative('models/album.rb')
require_relative('models/artist.rb')
require_relative('controllers/album_controller.rb')
require_relative('controllers/artist_controller.rb')

class App < Sinatra::Base

  get '/' do
    @albums = Album.all()
    erb(:index)
  end

  post '/inventory' do
    @albums = Album.all_order_by(params['field'])
    @ordered_field = params['field']
    erb(:inventory)
  end

  get '/inventory' do
    @albums = Album.all()
    erb(:inventory)
  end

  get '/inventory/out_of_stock' do
    @albums = Album.all()
    erb(:out_of_stock)
  end

  post '/inventory/search' do
    # get albums with search term
    @albums = Album.search(params['term'])
    # get artists with search term
    artists = Artist.search(params['term'])
    # get the albums of found artists
    artist_albums = artists.map{|artist| artist.albums()}
    artist_albums.flatten! # flatten to single array
    artist_albums.uniq! # remove duplicates
    # add the albums by artist name to the @albums []
    artist_albums.each{|album| @albums.push(album)}
    erb(:search_results)
  end

  post '/inventory/filter' do
    @stock_level = params['stock_level']
    @albums = Album.all()
    erb(:filtered_results)
  end

  # ARTISTS CONTROLLER

  get '/artists/new' do
    erb(:"artists/new")
  end

  post '/artists' do
    artist = Artist.new(params)
    artist.save()
    # view Artist info page once created
    redirect to("/artists/#{artist.id}")
  end

  get '/artists/:id' do
    @artist = Artist.find_by_id(params['id'].to_i)
    # get all artists albums to display
    @albums = @artist.albums
    erb(:"artists/view")
  end

  get '/artists/:id/edit' do
    @artist = Artist.find_by_id(params['id'])
    erb(:"artists/edit")
  end

  post '/artists/:id/update' do
    artist = Artist.new(params)
    artist.update()
    redirect to("/artists/#{artist.id}")
  end

  get '/artists/:id/delete_are_you_sure' do
    @artist = Artist.find_by_id(params['id'])
    erb(:"artists/delete_are_you_sure")
  end

  post '/artists/:id/delete' do
    artist = Artist.find_by_id(params['id'])
    artist.delete()
    # go HOME
    redirect to('/inventory')
  end

  # ALBUMS CONTROLLER

  get '/albums/new' do
    erb(:"albums/new")
  end

  post '/albums' do
    # get Artist object as var
    artist = Artist.find_by_name(params['artist'])
    # if Artist is present, create album
    unless artist == nil
      params['artist_id'] = artist.id
      album = Album.new(params)
      album.save()
      redirect to("/albums/#{album.id}")
    # if no Artist present, redirect to 'No Artist'
    else
      @artist = params['artist']
      erb(:"albums/no_artist")
    end
  end

  get '/albums/:id' do
    @album = Album.find_by_id(params['id'])
    erb( :"albums/view" )
  end

  get '/albums/:id/edit' do
    @album = Album.find_by_id(params['id'])
    @artist = Artist.find_by_id(@album.artist_id)
    erb(:"albums/edit")
  end

  post '/albums/:id/update' do
    # form doesn't send Artist ID, so get it
    artist = Artist.find_by_name(params['artist'])
    params['artist_id'] = artist.id

    album = Album.new(params)
    album.update()
    redirect to("/albums/#{album.id}")
  end

  get '/albums/:id/delete_are_you_sure' do
    @album = Album.find_by_id(params['id'])
    erb(:"albums/delete_are_you_sure")
  end

  post '/albums/:id/delete' do
    album = Album.find_by_id(params['id'])
    album.delete()
    redirect to('/inventory')
  end



end
