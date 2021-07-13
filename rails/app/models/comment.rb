class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, optional: true

  def build_by_docbase(obj)
    user = User.find_by(id: obj.dig(:user, :id))
    self.attributes = {
      id: obj[:id],
      body: obj[:body],
      user: user,
      created_at: obj[:created_at],
      updated_at: obj[:created_at]
    }
    self
  end
end
