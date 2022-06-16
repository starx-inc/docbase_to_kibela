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
require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
