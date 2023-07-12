# frozen_string_literal: true

require 'json'

def parse_all_data
  original_data = File.read('db.json')
  data = JSON.parse(original_data, symbolize_names: true)
  data || []
end

def find_memo_data(id)
  all_data = parse_all_data
  all_data.find { |memo| memo[:id] == id }
end

def delete_memo_data(id)
  old_data = parse_all_data
  new_data = old_data.reject { |memo| memo[:id] == id }
  File.open('db.json', 'w') do |file|
    file.write(JSON.pretty_generate(new_data))
  end
end

def edit_memo_data(params)
  symbolized_params = params.transform_keys(&:to_sym)
  all_data = parse_all_data
  memo = all_data.find { |memo| memo[:id] == symbolized_params[:id].to_i }
  memo[:name] = symbolized_params[:name]
  memo[:text] = symbolized_params[:text]
  File.open('db.json', 'w') { |file| file.write(JSON.pretty_generate(all_data)) }
end

def set_id
  all_data = parse_all_data
  last_id = all_data.empty? ? 0 : all_data[-1][:id]
  last_id + 1
end

def add_new_memo(params)
  symbolized_params = params.transform_keys(&:to_sym)
  id = set_id
  all_data = parse_all_data
  all_data.push(symbolized_params.slice(:name, :text).merge(id:))
  File.open('db.json', 'w') do |file|
    file.puts(JSON.pretty_generate(all_data))
  end
end
