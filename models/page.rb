class Page
  class << self
    def find_or_create_by_name(name)
      find_by_name(name) || new(name).save
    end
  end
  
  attr_reader :name
  attr_accessor :content

  def initialize(name)
  end

  def save
    self
  end

  def content
  end
  
  def tags
  end

end

