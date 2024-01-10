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

RSpec.describe Community::PostsController, type: :controller do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id: @company.id)
    @employee = FactoryGirl.create(:employee, department_id: @department.id)
    @community_category = FactoryGirl.create(:category, title: 'Attendance')
    @post =FactoryGirl.create(:post, author_id: @employee.id, community_category_id: @community_category.id)
    session[:department_id] = @department.id
    sign_in(@employee)
  end


  describe 'get#index' do
    context 'when params[:community_category] present' do
      it 'should request to index action of PostController' do
        get :index, community_category: 'Attendance'
        expect(response).to be_success
      end
      it 'should request to index action of PostsController as js format' do
        xhr :get, :index, format: :js, community_category: 'Attendance'
        expect(response).to be_success
      end
      it 'should assign all posts' do
        xhr :get, :index, format: :js, community_category: 'Attendance'
        expect(assigns(:posts)).to eq([@post])
      end
      it 'should assign all posts' do
        get :index, community_category: 'Attendance'
        expect(assigns(:posts)).to eq([@post])
      end
    end

    context 'when params[:community_category] not present' do
      it 'should request to index action of PostController' do
        get :index
        expect(response).to be_success
      end
      it 'should request to index action of PostController' do
        xhr :get, :index, format: :js
        expect(response).to be_success
      end
      it 'should assign all posts' do
        xhr :get, :index, format: :js
        expect(assigns(:posts)).to eq([@post])
      end
      it 'should assign all posts' do
        get :index
        expect(assigns(:posts)).to eq([@post])
      end
    end
  end

  describe 'get#new' do
    it 'should request to new action of PostsController' do
      xhr :get, :new, format: :js
      expect(response).to be_success
    end
  end

  describe 'post#create' do
    it 'should request to create action of PostsController' do
      xhr :post, :create, format: :js, community_post: {title: Faker::Lorem.sentence}
      expect(response).to be_success
    end
    it 'should assign the newly generated post' do
      xhr :post, :create, format: :js, community_post: {title: Faker::Lorem.sentence}
      expect(assigns(:post)).to be_persisted
    end
    it 'should increase by the created post' do
      count = Community::Post.count
      xhr :post, :create, format: :js, community_post: {title: Faker::Lorem.sentence}
      expect(Community::Post.count).to eq(count+1)
    end
  end

  describe 'get#show' do
    it 'should request to show action of PostsController' do
      get :show, id: @post.id
      expect(response).to be_success
    end
    it 'should request to show action of PostsController' do
     xhr :get, :show,format: :js, id: @post.id
      expect(response).to be_success
    end
  end

end
