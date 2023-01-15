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

  def upload_to_kibela!
    adapter = Kibela::Adapter.new
    commentable_id = post.kibela_id
    content = body
    # 退会済ユーザーはdummy_userとする
    author_id = user&.kibela_id || 'VXNlci82NjE'
    response = adapter.create_comment(commentable_id, content, author_id)
    self.kibela_id = response.data.create_comment.comment.id
    self.kibela_url = response.data.create_comment.comment.path
    self.kibela_updated_at = Time.now
    self.save!
  end
end
