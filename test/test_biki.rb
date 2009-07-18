require File.expand_path(File.dirname(__FILE__) + '/test_helper')

describe 'Testing page model' do
  it 'should create a new file' do 
    file_name = Page.data_store + 'testing'
    File.unlink(file_name)
    page = Page.load 'testing'
    page.content = 'more testing'
    page.save
    File.exists(file_name).should.be.true
    lines = Array.new
    File.open(file_name) do |file|
      lines = file.readlines
    end
    lines.size.should.be 1
    lines[0].chomp!
    lines[0].should.equal = "more testing"
  end
  it 'load the existing file' do
  end
  it 'save changes' do
  end
end

