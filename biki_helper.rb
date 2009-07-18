
# load in the models.

Dir.glob(File.expand_path(File.dirname(__FILE__)) + '/models/*.rb').each do |model|
  begin
    load "#{model}"
  rescue
    # XXX ignoring failure to load a model at the moment.
    warn "couldn't load model '#{model}'"
  end
end
