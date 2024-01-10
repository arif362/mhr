module Community
  class PostsController < BaseController
    before_action :set_post, only: [:show]

    def index

      if params[:community_category].present?
        category_id= Community::Category.find_by_title(params[:community_category]).id
        @posts = Community::Post.where("community_category_id = ?", category_id).order(id: :desc)
      else
        @posts= Community::Post.all.order(id: :desc)
      end

      @posts = params[:community_search].present? ? @posts.where('title LIKE ? Or content LIKE ?', "%#{params[:community_search]}%", "%#{params[:community_search]}%") : @posts
      respond_to do |format|
        format.js
        format.html
      end

    end

    def new
      respond_to do |format|
        format.js
        format.html
      end
    end

    def create
      @post = current_employee.community_posts.build(post_params)
      @post.save
      respond_to do |format|
        format.html
        format.js
      end
    end

    def show
      respond_to do |format|
        format.js
        format.html
      end
    end

    private

    def post_params
      params.require(:community_post).permit!
    end

    def set_post
      @post = Community::Post.friendly.find(params[:id])
    end
  end
end
