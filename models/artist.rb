require_relative('../db/sql_runner.rb')

class Artist

  attr_reader :id
  attr_accessor :name

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save()
    sql = "INSERT INTO artists (name) VALUES ($1) RETURNING *"
    values = [@name]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update()
    sql = "UPDATE artists SET name = $1 WHERE id = $2"
    values = [@name, @id]
    SqlRunner.run(sql, values)
  end

  def albums()
    sql = "SELECT * FROM albums WHERE artist_id = $1"
    values = [@id]
    albums = SqlRunner.run(sql, values)
    return albums.map{|album| Album.new(album)}
  end

  def delete()
    sql = "DELETE FROM artists WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end


  # SELF METHODS

  def self.all()
    sql = "SELECT * FROM artists"
    artists = SqlRunner.run(sql)
    return artists.map{|artist| Artist.new(artist)}
  end

  def self.all_order_by(field)
    sql = "SELECT * FROM artists ORDER BY #{field}"
    artists = SqlRunner.run(sql)
    return artists.map{|artist| Artist.new(artist)}
  end

  def self.delete_all()
    sql = "DELETE FROM artists"
    SqlRunner.run(sql)
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    artist = result.map{|artist| Artist.new(artist)}
    if artist.length() > 0
      return artist[0]
    else
      # returning Nil stops Errors when no Artist found
      # allowing other functions to act accordingly.
      # see artist_controller > post '/albums' method
      return nil
    end
  end

  # Note:- could adjust to handle up/down case
  def self.find_by_name(name)
    sql = "SELECT * FROM artists WHERE name = $1"
    values = [name]
    result = SqlRunner.run(sql, values)
    artist = result.map{|artist| Artist.new(artist)}
    if artist.length() > 0
      return artist[0]
    else
      # returning Nil stops Errors when no Artist found
      # allowing other functions to act accordingly.
      # see artist_controller > post '/albums' method
      return nil
    end
  end

  # def self.search(term)
  #   # set up comparisons for searching in SQL results.
  #   # Note:- search is too broad, will pick up any character chain in any word
  #   term_start_lc = term.downcase + '%'
  #   term_end_lc = '%' + term.downcase
  #   term_mid_lc = '%' + term.downcase + '%'
  #   term_start_cap = term.capitalize + '%'
  #   term_end_cap = '%' + term.capitalize
  #   term_mid_cap = '%' + term.capitalize + '%'
  #   sql = "SELECT * FROM artists WHERE (name LIKE $1) OR (name LIKE $2)
  #          OR (name LIKE $3) OR (name LIKE $4) OR (name LIKE $5)
  #          OR (name LIKE $6)"
  #   values = [term_start_lc, term_start_cap,
  #             term_end_lc, term_end_cap, term_mid_lc, term_mid_cap]
  #   result = SqlRunner.run(sql, values)
  #   return result.map{|artist| Artist.new(artist)}
  # end

  def self.search(term)
    # set up comparisons for searching in SQL results.
    # Note:- search is too broad, will pick up any character chain in any word
    term_start = term + '%'
    term_end = '%' + term
    term_mid = '%' + term + '%'
    sql = "SELECT * FROM artists WHERE
          (LOWER (name) LIKE LOWER ($1)) OR (LOWER (name) LIKE LOWER ($2)) OR (LOWER (name) LIKE LOWER ($3))"
    values = [term_start, term_start, term_end]
    result = SqlRunner.run(sql, values)
    return result.map{|artist| Artist.new(artist)}
  end

end
