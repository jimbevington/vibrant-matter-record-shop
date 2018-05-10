# maybe dont' need these
require('sinatra')
require('sinatra/contrib/all')

require_relative('../models/album.rb')
require_relative('../models/artist.rb')


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
