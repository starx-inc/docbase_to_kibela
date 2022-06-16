# == Schema Information
#
# Table name: groups
#
#  id         :bigint           not null, primary key
#  post_id    :bigint           not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kibela_id  :string
#
class Group < ApplicationRecord
  belongs_to :post

  def build_by_docbase(obj)
    self.attributes = {
      name: obj[:name]
    }
    self
  end

end
