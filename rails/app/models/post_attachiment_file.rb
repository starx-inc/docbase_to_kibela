# == Schema Information
#
# Table name: post_attachiment_files
#
#  id                  :bigint           not null, primary key
#  post_id             :bigint           not null
#  attachiment_file_id :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class PostAttachimentFile < ApplicationRecord
  belongs_to :post
  belongs_to :attachiment_file

end
