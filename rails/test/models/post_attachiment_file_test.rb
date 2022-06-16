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
require 'test_helper'

class PostAttachimentFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
