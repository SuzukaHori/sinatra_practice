# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require_relative 'models'

get '/' do
  redirect '/memos'
end

get '/memos' do
  @title = 'memos'
  @memos = parse_all_data
  erb :index
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

post '/memos' do
  add_new_memo(params)
  redirect '/memos'
end

get '/memos/:id/edit' do
  @title = 'edit'
  @memo = find_memo_data(params[:id].to_i)
  erb :edit
end

get '/memos/:id' do
  @title = 'detail'
  @memo = find_memo_data(params[:id].to_i)
  erb :detail
end

delete '/memos/:id' do
  delete_memo_data(params[:id].to_i)
  redirect '/memos'
end

patch '/memos/:id' do
  edit_memo_data(params)
  redirect '/memos'
end

not_found do
  'This is nowhere to be found.'
end

helpers do
  def escape(text)
    Rack::Utils.escape_html(text)
  end
end
