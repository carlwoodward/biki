
# XXX the name of this file is probably wrong.

# XXX each page will have a list of tags too.

class Page

  attr_reader :pagename

  def initialize pgnm
    # XXX need sanity checking on the name of the page.
    @pagename = pgnm
    load pgnm if self.exists? pgnm
  end

  def pagename
    @pagename
  end

  def load pgn
  end

  # Obvious
  def self.exists? pgnm
  end

  # Save the page back to disk.
  def save
  end

  # Return the contents of the page.
  def dump
  end

end

