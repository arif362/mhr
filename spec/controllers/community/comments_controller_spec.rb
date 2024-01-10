# == Schema Information
#
# Table name: community_comments
#
#  id           :integer          not null, primary key
#  content      :text(65535)
#  post_id      :integer
#  author_id    :integer
#  attachment   :string(255)
#  is_published :boolean          default(TRUE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Community::CommentsController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, role: Employee::ROLE[:admin], department_id: @department.id)
    @comment = FactoryGirl.create(:comment, author_id: @employee.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end

  describe 'post#create' do
    it 'should request to create action of CommentsController' do
      xhr :post, :create, format: :js, community_comment: {content: Faker::Lorem.sentence}
      expect(response).to be_success
    end
  end

end
