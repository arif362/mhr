ActiveAdmin.register Community::Post do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  show do

    attributes_table do
      row :id
      row :title
      row :community_category_id
      row :content
      row :attachment
      row :author do |post|
        post.author.full_name
      end
      row :is_published
    end

    panel "Comments(#{community_post.community_comments.count})" do
      table_for community_post.community_comments do

        column :id
        column :content
        column :author do |comment|
          comment.author.full_name
        end
        column :remove_comment do |comment|

          link_to "Remove", remove_comment_admin_community_posts_path(comment_id: comment.id), data: {confirm: 'Are you sure want to remove this comment?'}

        end
      end
    end
  end

  collection_action :remove_comment do
    comment = Community::Comment.find(params[:comment_id])

    comment.destroy

    redirect_to :back, :notice => "Comment deleted"
  end


end
