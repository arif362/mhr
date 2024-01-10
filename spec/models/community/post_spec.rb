# == Schema Information
#
# Table name: community_posts
#
#  id                    :integer          not null, primary key
#  title                 :string(255)
#  community_category_id :integer
#  content               :text(65535)
#  attachment            :string(255)
#  author_id             :integer
#  is_published          :boolean          default(TRUE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  slug                  :string(255)
#

require 'rails_helper'

RSpec.describe Community::Post, type: :model do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, department_id: @department.id)
    @category = FactoryGirl.create(:category)
    @post = FactoryGirl.create(:post, author_id: @employee.id, community_category_id: @category.id)
  end

  describe 'instance method#post_slug' do
    it 'should return community post title with slug' do
      expect(@post.post_slug).to eq(@post.title + '_' + Community::Post.count.to_s)
    end
  end

end
