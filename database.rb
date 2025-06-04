# frozen_string_literal: true

require 'pg'
require 'dotenv/load'

PG.connect(dbname: ENV['DB_NAME'], user: ENV['DB_USER'], password: ENV['DB_PASSWORD']) do |conn|
  conn.exec(
    "CREATE TABLE memos (
       id SERIAL PRIMARY KEY,
       title VARCHAR(255),
       description TEXT
    )"
  )
end
