# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  docbase_id    :integer          not null
#  docbase_name  :string
#  docbase_email :string
#  kibela_id     :string
#  kibela_name   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
