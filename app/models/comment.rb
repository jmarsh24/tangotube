# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  user_id          :bigint
#  commentable_type :string
#  commentable_id   :bigint
#  parent_id        :integer
#  body             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :commentable, polymorphic: true
  belongs_to :parent, optional: true, class_name: "Comment"

  def comments
    Comment.includes([:commentable]).where(commentable:, parent_id: id)
  end

  def parent_comments
    Comment.where(commentable:, id: parent_id)
  end

  def destroy
    update(user: nil, body: nil)
    parent_comments.each do |comment|
      if comment.deleted?
        comment.delete
      end
    end
    if parent_id.nil? || comments.empty?
      delete
    end
  end

  def deleted?
    user.nil?
  end
end
