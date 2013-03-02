require_dependency 'apod_web'

class Gopher
  # Collect and return all APIDs from the index page
  #
  # @returns [Array] list of ident strings
  def self.picture_index
    parser = ApodWeb.index

    [].tap do |apids|
      parser.css('a').each do |link|
        match = link[:href].to_s.match %r[(ap\d+)\.html$]
        next unless match

        date = Date.parse(link.previous.text)
        apids.unshift id: match[1], date: date
      end
    end
  end

  # Gets a list of missing APIDs. This will
  # use +Picture.last+.
  #
  # @returns [Array] list of ident strings
  def self.missing_pictures
    parser = ApodWeb.index
    last = Picture.last.try(:date)

    return picture_index unless last

    picture_index.tap do |idx|
      idx.reject! { |ap| ap[:date] <= last }
    end
  end

  # Fetch the page and create a new Picture record
  #
  # Interally this method call +parse_view+.
  #
  # @params [Hash] opts options hash with id and date properties
  # @returns [Picture] newly created Picture object
  def self.create_picture(opts)
    return unless attributes = self.parse_view(opts[:id])

    Picture.where(date: opts[:date]).first_or_initialize.tap do |picture|
      picture.attributes = attributes
      picture.save
    end
  end

  # Parse the APOD page and return the extracted
  # data
  #
  # @param [Hash] opts options hash with id and date properties
  # @returns [Hash] hash of parsed data
  def self.parse_view(id)
    base_uri = ApodWeb::base_uri
    parser = ApodWeb.view(id)

    bold_els = parser.css('b')
    exp_node = parser.css('p').find { |p| p.text =~ /^\s+Explanation/ }

    {}.tap do |attrs|
      if bold_els.size < 2 || exp_node.nil?
        Rails.logger.warn "Invalid Page Structure for #{id}"

        return
      end

      # get title from first B element within this center
      attrs[:title] = bold_els.first.text

      # extract credit html; start at credit B element and join
      # the HTML of all the child nodes after this element
      credit_el = bold_els[1]
      credit_nodes = credit_el.parent.children
      credit_index = credit_nodes.index(credit_el) + 1

      attrs[:credit] = credit_nodes.slice(credit_index..-1).map { |node| node.to_html }.join

      # collect striped html of all of the explaination element's children ignoring certian nodes
      exp_fragments = exp_node.children.map { |node| node.to_html unless node.text.blank? || node.text =~ /^\s+Explanation/ }
      exp_fragments.compact!

      attrs[:explanation] = exp_fragments.join

      # look for media; start with img element
      imgs = parser.css('img')

      unless imgs.empty?
        img = imgs.first
        img[:src] = "#{base_uri}/#{img[:src]}"

        img.attributes.keys.select { |k| k != 'src' }.each { |a| img.remove_attribute(a) }

        href = img.parent[:href]

        attrs[:media] = img.to_html
        attrs[:media_link] = href =~ /^http/ ? href : "#{base_uri}/#{href}"
      end

      attrs.keys.each { |key| attrs[key].strip! }
    end
  end
end
