#!/usr/local/rvm/rubies/ruby-2.0.0-p247/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'couchrest_model'

# Setting for CouchDB
$COUCH = CouchRest.new ENV["COUCHDB_URL"]
$COUCH.default_database = ENV["COUCHDB_DEFAULT_DB"]
$COUCHDB = $COUCH.default_database

# Model for OBM Web
class Sticker < CouchRest::Model::Base
  use_database $COUCHDB

  property :id,             Integer
  property :name,            String
  property :tag,           [String], :default => []
  
  property :detail,          String, :default => "" 
  property :description,     String, :default => "" 
  property :thumbnail,       String, :default => "" 
  property :detailImg,       String, :default => "" 

  property :reserv1,         String, :default => "" 
  property :reserv2,         String, :default => "" 
  property :reserv3,         String, :default => "" 

  timestamps!

  design do
    view :by_id
  end
end

$COUCHDB.delete!
