#class Comment < ActiveRecord::Base
class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :room
  belongs_to :user
  field :parsecomhash, type: String
  field :content, type: String

  def icon_url
    user ? user.icon : "https://ruffnote.com/attachments/24311"
  end

  def user_name
    ''
  end

  def save_with_parsecom!
    parse_comment = ParsecomComment.new(
      user: ParsecomUser.find(self.user.parsecomhash),
      body: self.content
    )
    if parse_comment.save
      self.parsecomhash = parse_comment.id
      save!
    else
      raise parse_comment.inspect
    end
  end
end
