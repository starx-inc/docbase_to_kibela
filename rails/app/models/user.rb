# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  docbase_id    :integer          not null
#  docbase_name  :string
#  docbase_email :string
#  kibela_id     :string
#  kibela_name   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
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
    
    def sync_by_kibela
      adapter = Kibela::Adapter.new
      responses = adapter.get_users
      responses.data.users.nodes.each do |node|
        if node.account == "dummy-user"
          user = User.find_or_create_by!(
            docbase_id: 0,
            docbase_name: "dummy-user",
            docbase_email: node.email,
            kibela_id:node.id,
            kibela_name: node.account
          )
        else
          user = User.find_by(docbase_email: node.email)
          user.update_attributes(kibela_id: node.id, kibela_name: node.account)
        end
      end

    end
  end

  def build_by_docbase(obj)
    self.attributes = {
      docbase_id: obj[:id],
      docbase_name: obj[:name],
      docbase_email: obj[:email]
    }
  end

  
  
end
