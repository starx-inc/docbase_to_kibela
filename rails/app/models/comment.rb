# == Schema Information
#
# Table name: comments
#
#  id                :bigint           not null, primary key
#  post_id           :bigint           not null
#  user_id           :bigint
#  body              :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  kibela_id         :string
#  kibela_updated_at :datetime
#
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
