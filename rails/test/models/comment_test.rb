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
require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
