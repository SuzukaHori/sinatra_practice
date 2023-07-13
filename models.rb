# frozen_string_literal: true

require 'json'

def read_all_memos
  original_data = File.read('db.json')
  memos = JSON.parse(original_data, symbolize_names: true)
  memos || []
end

def find_memo(id)
  memos = read_all_memos
  memos.find { |memo| memo[:id] == id }
end

def delete_memo(id)
  old_memos = read_all_memos
  new_memos = old_memos.reject { |memo| memo[:id] == id }
  File.open('db.json', 'w') do |file|
    file.write(JSON.pretty_generate(new_memos))
  end
end

def edit_memo(params)
  symbolized_params = params.transform_keys(&:to_sym)
  memos = read_all_memos
  memo = memos.find { |memo| memo[:id] == symbolized_params[:id].to_i }
  memo[:name] = symbolized_params[:name]
  memo[:text] = symbolized_params[:text]
  File.open('db.json', 'w') { |file| file.write(JSON.pretty_generate(memos)) }
end

def generate_id
  memos = read_all_memos
  last_id = memos.empty? ? 0 : memos[-1][:id]
  last_id + 1
end

def add_memo(params)
  symbolized_params = params.transform_keys(&:to_sym)
  id = generate_id
  memos = read_all_memos
  memos.push(symbolized_params.slice(:name, :text).merge(id:))
  File.open('db.json', 'w') do |file|
    file.puts(JSON.pretty_generate(memos))
  end
end
