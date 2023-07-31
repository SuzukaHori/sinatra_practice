# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require_relative 'db'

connection = PG.connect(dbname: DB_NAME)

get '/' do
  redirect '/memos'
end

get '/memos' do
  @title = 'memos'
  @memos = read_all_memos(connection)
  erb :index
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

post '/memos' do
  add_memo(params, connection)
  redirect '/memos'
end

get '/memos/:id/edit' do
  @title = 'edit'
  @memo = find_memo(params[:id], connection)
  erb :edit
end

get '/memos/:id' do
  @title = 'detail'
  @memo = find_memo(params[:id], connection)
  erb :detail
end

delete '/memos/:id' do
  delete_memo(params[:id], connection)
  redirect '/memos'
end

patch '/memos/:id' do
  edit_memo(params, connection)
  redirect '/memos'
end

not_found do
  'This is nowhere to be found.'
end

helpers do
  def escape_html(text)
    Rack::Utils.escape_html(text)
  end
end
