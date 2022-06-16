# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  post_id    :bigint           not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  belongs_to :post

  def build_by_docbase(obj)
    self.attributes = {
      name: obj[:name]
    }
    self
  end
end
