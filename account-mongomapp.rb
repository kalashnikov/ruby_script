#!/usr/local/rvm/rubies/ruby-2.0.0-p247/bin/ruby
# http://mongomapper.com/documentation/plugins/querying.html
# https://github.com/mongomapper/mongomapper
require 'bcrypt'
require 'mongo_mapper'

MongoMapper.setup({'production' => {'uri' => ENV['MONGODB_URI']}}, 'production')


# Model for OBM Web
class User 
    include MongoMapper::Document
    include BCrypt
    set_collection_name "user"

    timestamps!

    key :uid,            Integer
    key :name,            String
    key :passwd,          String
    key :email,           String
    key :comment,         String

    validates_presence_of :name
    before_save:crypt_password
 
    # Hash the password using BCrypt
    #
    # BCrypt is a lot more secure than a hash made for speed such as the SHA algorithm. BCrypt also
    # takes care of adding a salt before hashing.  The whole thing is encoded in a string 60 bytes long.
    def crypt_password
      self.passwd = BCrypt::Password.create(passwd) if passwd
    end
 
    # Prepare a BCrypt hash from the stored password and verify 
    def authenticate(pass)
        if BCrypt::Password.new(self.passwd) == pass
            true
        else
            false
        end
    end
end
