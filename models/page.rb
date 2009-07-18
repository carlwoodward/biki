class Page

  @@data_store = "/Users/brucewoodward/code/biki/biki_files/"

  class << self
    def load(name)
      [ @@data_store + name, @@data_store + "#{name}_tags" ].each do |filename|
        File.new(filename, "a").close
      end
      new name
    end
  end
  
  attr_reader :name
  attr_accessor :content

  def initialize(name)
    @content, @tags = [], []
    @name = name
    File.open(@@data_store + name) do |file|
      @content = file.readlines
    end
    File.open(@@data_store + name + '_tags') do |file|
      file.each_line do |line|
        @tags << line.chomp
      end
    end
  end

  def save
    File.open(@@data_store + @name, "w") do |file|
      @content.each do |line|
        file.write line
      end
    end
  end

  def content
    @content
  end
  
  def tags
    @tags
  end

end

