module Community
    module PostsHelper
        def latest_community_posts
            Community::Post.limit(3).order(created_at: :desc)
        end
    end
end