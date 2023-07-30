# frozen_string_literal: true

require 'json'
require 'pg'

DB_NAME = 'memosdata'

def read_all_memos
  sql = <<~SQL
    SELECT *
    FROM memos
    ORDER BY id;
  SQL
  all_memos = PG.connect(dbname: DB_NAME) { |connection| connection.exec(sql) }
  all_memos.map { |memo| memo.transform_keys(&:to_sym) }
end

def find_memo(id)
  sql = <<~SQL
    SELECT *
    FROM memos
    WHERE id = $1;
  SQL
  memos = PG.connect(dbname: DB_NAME) { |connection| connection.exec_params(sql, [id]) }
  memos[0].transform_keys(&:to_sym)
end

def delete_memo(id)
  sql = <<~SQL
    DELETE FROM memos
    WHERE id = $1;
  SQL
  PG.connect(dbname: DB_NAME) { |connection| connection.exec_params(sql, [id]) }
end

def edit_memo(params)
  sql = <<~SQL
    UPDATE memos
    SET name = $1::VARCHAR, text = $2::VARCHAR
    WHERE id =  $3::int;
  SQL
  symbolized_params = params.transform_keys(&:to_sym)
  name = symbolized_params[:name]
  text = symbolized_params[:text]
  id = symbolized_params[:id]
  PG.connect(dbname: DB_NAME) { |connection| connection.exec_params(sql, [name, text, id]) }
end

def add_memo(params)
  sql = <<~SQL
    INSERT INTO memos(name, text)
    VALUES ($1::VARCHAR, $2::VARCHAR);
  SQL
  symbolized_params = params.transform_keys(&:to_sym)
  name = symbolized_params[:name]
  text = symbolized_params[:text]
  PG.connect(dbname: DB_NAME) { |connection| connection.exec_params(sql, [name, text]) }
end
