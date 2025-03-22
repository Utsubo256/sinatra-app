require 'pg'

conn = PG.connect(dbname: 'utsubo') do |conn|
  conn.exec(
    "CREATE TABLE memos (
       id SERIAL PRIMARY KEY,
       title VARCHAR(255),
       description TEXT
    )"
  )
end
