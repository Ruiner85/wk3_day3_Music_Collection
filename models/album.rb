require('pg')
require_relative('../db/sql_runner')

class Album

  attr_reader :id,:artist_id
  attr_accessor :album_name,:genre

def initialize(options)
  @album_name = options['album_name']
  @genre = options['genre']
  @id = options['id'].to_i() if options['id']
  @artist_id = options['artist_id'].to_i() if options['artist_id']
end

def save()
sql= "INSERT INTO albums(
      album_name,genre,artist_id
      )
      VALUES (
        $1,$2,$3
        ) RETURNING id"
  values= [@album_name,@genre,@artist_id]
  results= SqlRunner.run(sql,values)
  @id=results[0]['id'].to_i()
end

def update()
  sql = "UPDATE albums SET (
  album_name, genre, artist_id
  ) = ($1, $2, $3)
  WHERE id = $4"
  values = [@album_name, @genre, @artist_id, @id]
  SqlRunner.run(sql, values)
end

def delete
  sql="DELETE FROM albums WHERE id = $1"
  values=[@id]
  SqlRunner.run(sql, values)
end

def artist()
  sql="SELECT * FROM artists WHERE id = $1"
  values=[@artist_id]
  results = SqlRunner.run(sql, values)
  artist_data = results[0]
  artist = Artist.new(artist_data)
  return artist
end

def self.find(id)
  sql = "SELECT * FROM albums WHERE id = $1"
  values = [id]
  results = SqlRunner.run(sql, values)
  album_hash = results.first
  album = Artist.new(album_hash)
  return album
end

def self.delete_all()
  sql = "DELETE FROM albums"
  SqlRunner.run(sql)
end

def self.all()
  sql = "SELECT * FROM albums"
  albums = SqlRunner.run(sql)
  return albums.map {|album| Album.new(album)}
end

end
