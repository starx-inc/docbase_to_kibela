class User < ApplicationRecord
  include Docbase::BaseModule

  has_many :posts

  class << User
    def get_by_docbase
      responses = users
    end
    def sync_by_docbase
      responses = users
      user_objects = responses[:body][:users]
      user_objects.map do |o|
        user = User.find_or_initialize_by(id: o[:id])
        user.build_by_docbase(o)
        user.save!
      end.all?
    end
  end

  def build_by_docbase(obj)
    self.attributes = {
      docbase_id: obj[:id],
      docbase_name: obj[:name],
      docbase_email: obj
    }
  end
  
end
