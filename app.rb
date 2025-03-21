# frozen_string_literal: true

require 'sinatra'

MEMO_PATH = './data/memos.json'

def load_memo_data
  JSON.parse(File.read(MEMO_PATH), symbolize_names: true)
end

def sanitize(text)
  Rack::Utils.escape_html(text)
end

def find_memo(memos, target_id)
  memos.find { |memo| memo[:id] == target_id }
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  json = load_memo_data
  @memos = json[:memos]
  erb :'books/index'
end

get '/memos/new' do
  erb :'books/new'
end

get '/memos/:memo_id' do
  json = load_memo_data
  @memo = find_memo(json[:memos], params[:memo_id].to_i)
  erb :'books/show'
end

post '/memos' do
  json = load_memo_data
  adding_memo = { id: json[:id_counter] + 1, title: sanitize(params[:title]), description: sanitize(params[:description]) }
  result_json = { id_counter: json[:id_counter] + 1, memos: [*json[:memos], adding_memo] }
  File.write(MEMO_PATH, JSON.dump(result_json))
  redirect "/memos/#{adding_memo[:id]}"
end

get '/memos/:memo_id/edit' do
  json = load_memo_data
  @memo = find_memo(json[:memos], params[:memo_id].to_i)
  erb :'books/edit'
end

patch '/memos/:memo_id' do
  json = load_memo_data
  result_json = json
  target_index = result_json[:memos].find_index { |memo| memo[:id] == params[:memo_id].to_i }
  updating_memo = { id: result_json[:memos][target_index][:id], title: sanitize(params[:title]), description: sanitize(params[:description]) }
  result_json[:memos][target_index] = updating_memo
  File.write(MEMO_PATH, JSON.dump(result_json))
  redirect "/memos/#{updating_memo[:id]}"
end

delete '/memos/:memo_id' do
  json = load_memo_data
  remaining_memos = json[:memos].reject { |memo| memo[:id] == params[:memo_id].to_i }
  result_json = { id_counter: json[:id_counter] + 1, memos: remaining_memos }
  File.write(MEMO_PATH, JSON.dump(result_json))
  redirect '/memos'
end

not_found do
  erb :not_found
end
