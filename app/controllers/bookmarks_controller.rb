class BookmarksController < ApplicationController
  def create
    @bookmark = Bookmark.create(user_id: current_user.id, comment_id: params[:comment_id])
  end

  def destroy
    @bookmark = Bookmark.find_by(user_id: current_user.id, comment_id: params[:comment_id])
    @bookmark.destroy
  end
end
