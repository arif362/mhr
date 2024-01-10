module Community
  class CommentsController < BaseController

    def create
      @comment = current_employee.community_comments.build(comment_params)
      @comment.save
      respond_to do  |format|
        format.html
        format.js
      end
    end

    private

    def comment_params
      params.require(:community_comment).permit!
    end
  end
end