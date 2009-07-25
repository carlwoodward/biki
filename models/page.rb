require 'fileutils'
require 'active_support'

class Page
  class << self
    def load(name)
      new name
    end
    
    def page_name_preview_and_last_change_time
    end

    def recent_page_names
      newest(10, all_page_files_in_data_store)
    end

    def all_tag_names
      map_pages_to_tags().keys
    end

    def make_tags_table
      tags2pages = {}
      map_pages_to_tags().each do |h|
        h[1].each do |k| 
          tags2pages[k] = [] unless tags2pages.has_key?(k)
          tags2pages[k] << h[0]
        end
      end
      tags2pages
    end

    def map_pages_to_tags
      pages2tags = {}
      Page.all_tag_files_in_data_store.each {|tag|
        page_name = tag.sub(/_tags$/,'')
        File.open(path(tag)) do |file|
          file.readlines.each do |line|
            line.chomp!
            pages2tags[page_name] = [] unless pages2tags.has_key?(page_name)
            pages2tags[page_name] << line
          end
        end
      }
      pages2tags
    end

    # protected
    
    def all_tag_files_in_data_store
      files_in_data_store { |name| name =~ /_tags$/ }
    end
    
    def all_page_files_in_data_store
      files_in_data_store { |name| name !~ /_tags$/ }
    end

    def files_in_data_store
      Dir.entries(data_store).find_all do |filename|
        filename !~ /^\./ && yield(filename)
      end
    end

    def newest(count, names)
      sort_by_modification_time(find_file_modification_time(names))[0...count]
    end

    def find_file_modification_time(names)
      names.collect do |name| 
        { :name => name, :mtime => File.mtime(path(name)) } 
      end
    end
    
    def sort_by_modification_time(files_plus_modifcation_time)
      files_plus_modifcation_time.sort do |a, b| 
        b[:mtime] <=> a[:mtime] 
      end.collect { |h| h[:name] }
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
  
  def to_html
    BlueCloth::new(@content).to_html
  end
  
  def tags_as_string
    @tags.join(' ')
  end
  
  def tags_as_string=(tags_string)
    @tags = tags_string.split(' ')
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
    FileUtils.touch content_path unless File.exists? content_path
    File.open(content_path) do |file|
      @content = file.read
    end
  end
  
  def load_tags
    FileUtils.touch tags_path unless File.exists? tags_path
    File.open(tags_path) do |file|
      file.each_line do |line|
        @tags << line.chomp
      end
    end
  end

end

