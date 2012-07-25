class Article < ActiveRecord::Base
  attr_accessible :title, :body, :tag_list, :image
  # scope :only, lambda { |number| limit(number) }

  has_many :comments
  has_many :taggings
  has_many :tags, :through => :taggings

  has_attached_file :image

  def tag_list
    return self.tags.join(", ")
  end

  def tag_list=(tags_string)
    self.taggings.destroy_all

    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq

    tag_names.each do |tag_name|
      tag = Tag.find_or_create_by_name(tag_name)
      tagging = self.taggings.new
      tagging.tag_id = tag.id
    end
  end
  
  def self.ordered_by(param)
    case param
    when 'title'      then Article.order('title')
    when 'created_at' then Article.order('created_at DESC')
    when 'word_count' then Article.order('word_count')
    else                   Article.order('created_at DESC')    
    end
  end
  
  def self.only(number)
     puts "only got called"
     limit number
   end
  
end
