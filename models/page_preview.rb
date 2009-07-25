require 'fileutils'
require 'active_support'

require 'models/page'

class PagePreview
  
  class << self
    def summary
      summaries = []
      Page.all_page_files_in_data_store.each do |file|
        summaries << new(file)
      end
      summaries.sort.reverse
    end

  end
  
  include Enumerable
  
  attr_reader :name, :raw_modification_time, :tags
  
  def initialize(page_name)
    @name = page_name
    @raw_modification_time, @summary, @tags = File.mtime(Page.path(@name)), page_summary(), Page.new(@name).tags
  end
  
  def summary
    BlueCloth::new(@summary.join("\n")).to_html
  end
  
  def modification_time
    time_now = Time.new
    difference = time_now - @raw_modification_time # in seconds
    if difference < 60
      "now"
    elsif difference < 60 * 60
      "#{(difference.to_i) / 60 } minutes ago"
    elsif difference < 60 * 60 * 24
      "#{(difference.to_i) / (60*60)} hours ago"
    else
      "#{(difference.to_i) / (60*60*24)} days ago"
    end
  end
  
  # protected
  
  def <=> (a)
    @raw_modification_time <=> a.raw_modification_time
  end

  def page_summary
    summary = []
    read_max_first_ten_lines(File.open(Page.path(@name))).each do |line|
      line.chomp!
      break if line =~ /^\s*$/
      summary << line
    end
    summary
  end
  
  def read_max_first_ten_lines(file)
    lines = []
    File.open(Page.path(@name)) do |file|
      begin
        0.upto(10) do |i|
          lines << file.readline.chomp
        end
      rescue
        EOFError
      end
    end
    lines
  end
  
end