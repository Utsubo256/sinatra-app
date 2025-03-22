# frozen_string_literal: true

require 'sinatra'
require 'pg'
require 'dotenv/load'

TARGET_COLUMNS = %w[title description]

def connect_db
  PG.connect(dbname: ENV['DB_NAME'], user: ENV['DB_USER']) do |conn|
    yield conn
  end
end

def load_memo_data
  connect_db do |conn|
    conn.exec("SELECT * FROM memos ORDER BY id DESC")
  end
end

def sanitize(text)
  Rack::Utils.escape_html(text)
end

def sanitize_params(params)
  TARGET_COLUMNS.each do |target_column|
    params[target_column] = sanitize(params[target_column])
  end
  params
end

def find_memo(params)
  connect_db do |conn|
    conn.exec_params("SELECT * FROM memos WHERE id = $1", [params["memo_id"].to_i])
  end.first
end

def create_memo(params)
  sanitized_params = sanitize_params(params)
  connect_db do |conn|
    conn.prepare("memo_creation", "INSERT INTO memos (title, description) VALUES ($1, $2) RETURNING id")
    conn.exec_prepared("memo_creation", [sanitized_params[:title], sanitized_params[:description]])
  end.first
end

def update_memo(params)
  sanitized_params = sanitize_params(params)
  connect_db do |conn|
    conn.prepare("memo_update", "UPDATE memos SET title = $1, description = $2 WHERE id = $3")
    conn.exec_prepared("memo_update", [sanitized_params["title"], sanitized_params["description"], params["memo_id"].to_i])
  end
end

def destroy_memo(params)
  connect_db do |conn|
    conn.exec_params("DELETE FROM memos WHERE id = $1", [params["memo_id"].to_i])
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = load_memo_data
  erb :'books/index'
end

get '/memos/new' do
  erb :'books/new'
end

get '/memos/:memo_id' do
  @memo = find_memo(params)
  erb :'books/show'
end

post '/memos' do
  created_memo = create_memo(params)
  redirect "/memos/#{created_memo["id"]}"
end

get '/memos/:memo_id/edit' do
  @memo = find_memo(params)
  erb :'books/edit'
end

patch '/memos/:memo_id' do
  update_memo(params)
  redirect "/memos/#{params[:memo_id]}"
end

delete '/memos/:memo_id' do
  destroy_memo(params)
  redirect '/memos'
end

not_found do
  erb :not_found
end
