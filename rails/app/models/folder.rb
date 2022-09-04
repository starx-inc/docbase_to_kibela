# == Schema Information
#
# Table name: folders
#  id         :bigint           not null, primary key
#  name       :string(1024)
#  group_id   :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

belongs_to :group

class Folder < ApplicationRecord
end
