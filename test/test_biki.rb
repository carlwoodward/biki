require File.expand_path(File.dirname(__FILE__) + '/test_helper')

describe 'Testing page model' do
  it 'should create a the data store if it is missing' do
    File.exists?(Page.data_store).should.be.true
  end
  
  it 'should load a page' do
    page = Page.load 'test'
    page.content.should.not.be.nil
  end
  
  it 'should save content' do
    page = Page.load 'test'
    page.content = 'Hello world'
    page.save
    Page.load('test').content.should.equal 'Hello world'
  end
  
  it 'should save tags' do
    page = Page.load 'test'
    page.tags = %w(test one two)
    page.save
    Page.load('test').tags.should.equal %w(test one two)
  end
end

