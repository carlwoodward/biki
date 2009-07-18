require 'fileutils'

class Page
  class << self
    def load(name)
      new name
    end
    
    def data_store
      data_store = File.dirname(__FILE__) + "/../../biki_files/"
      FileUtils.mkdir_p data_store unless File.exists? data_store
      data_store
    end
    
    def path(name)
      data_store + name
    end
  end
  
  attr_reader :name
  attr_accessor :content
  attr_accessor :tags

  def initialize(name)
    @content, @tags = '', []
    @name = name
    load_content
    load_tags
  end

  def save
    save_content
    save_tags
  end
  
  # protected
  
  def content_path
    Page.path(@name)
  end
  
  def tags_path
    Page.path(@name + '_tags')
  end
  
  def save_content
    File.open(content_path, "w") do |file|
      file.write @content
    end
  end
  
  def save_tags
    File.open(tags_path, "w") do |file|
      @tags.each do |tag|
        file.puts tag
      end
    end
  end
  
  def load_content
    FileUtils.touch content_path
    File.open(content_path) do |file|
      @content = file.read
    end
  end
  
  def load_tags
    FileUtils.touch tags_path
    File.open(tags_path) do |file|
      file.each_line do |line|
        @tags << line.chomp
      end
    end
  end

end

