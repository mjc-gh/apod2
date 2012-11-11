require_dependency 'apod_web'

class Gopher
  # Get all AP-Dates from the index page
  #
  # @returns [Array] list of ident strings
  def self.apid_index
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

  # Getting a list of missing idents (AP-Dates)
  #
  # @returns [Array] list of ident strings
  def self.missing_pictures
    parser = ApodWeb.index
    last = Picture.last.try(:date)

    return apid_index unless last

    apid_index.tap { |idx|
      idx.reject! { |ap| ap[:date] <= last }
    }
  end

  # Fetch the page and create a new Picture record
  #
  # @params [Hash] opts options hash with id and date properties
  # @returns [Picture] newly created Picture object
  def self.fetch_and_create_picture(opts)
    base_uri = ApodWeb::base_uri
    parser = ApodWeb.view(opts[:id])

    bold_els = parser.css('b')
    exp_node = parser.css('p').find { |p| p.text =~ /^\s+Explanation/ }

    if bold_els.size < 2 || exp_node.nil?
      Rails.logger.warn "Invalid Page Structure for #{opts[:id]}"

      return nil
    end

    Picture.where(date: opts[:date]).first_or_initialize.tap do |picture|
      # get title from first B element within this center
      picture.title = bold_els.first.text
      picture.title.strip!


      # extract credit html; start at credit B element and join
      # the HTML of all the child nodes after this element
      credit_el = bold_els[1]
      credit_nodes = credit_el.parent.children
      credit_index = credit_nodes.index(credit_el) + 1

      picture.credit = credit_nodes.slice(credit_index..-1).map { |node| node.to_html }.join
      picture.credit.strip!


      # collect striped html of all of the explaination element's children ignoring certian nodes
      exp_fragments = exp_node.children.map { |node| node.to_html unless node.text.blank? || node.text =~ /^\s+Explanation/ }
      exp_fragments.compact!

      picture.explanation = exp_fragments.join.strip


      # look for media; start with img element
      imgs = parser.css('img')

      unless imgs.empty?
        img = imgs.first
        img[:src] = "#{base_uri}/#{img[:src]}"

        img.attributes.keys.select { |k| k != 'src' }.each { |a| img.remove_attribute(a) }

        href = img.parent[:href]

        picture.media = img.to_html
        picture.media_link = href =~ /^http/ ? href : "#{base_uri}/#{href}"
      end

      # TODO handle video or other media

      # Lastly, we save the picture
      picture.save
    end
  end
end
