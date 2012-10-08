require_dependency 'apod_web'

class Gopher
  # Getting a list of missing idents (AP-Dates)
  #
  # @returns [Array] list of ident strings
  def self.missing_pictures
    # get index listing from ApodWeb (make http req)
    parser = ApodWeb.index

    # get last ident in DB; default to empty string since its always less than
    last = Picture.last.try(:date)

    [].tap do |missing|
      parser.css('a').each do |link|
        match = link[:href].to_s.match %r[(ap\d+)\.html$]

        if match
          date = Date.parse(link.previous.text)

          if last.nil? || last < date
            missing << { id: match[1], date: date }
          end
        end
      end
    end
  end

  # Fetch the page and create a new Picture record
  #
  # @params [Hash] opts options hash with id and date properties
  # @returns [Picture] newly created Picture object
  def self.fetch_and_create_picture(opts)
    parser = ApodWeb.view(opts[:id])
    bold_els = parser.css('b')

    Picture.new(date: opts[:date]).tap do |picture|
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


      # enumerate all of the P tags, looking for that starts with 'explanation'.
      exp_node = parser.css('p').find { |p| p.text =~ /^\s+Explanation/ }

      # collect striped html of all of the p element's children ignoring certian nodes
      exp_fragments = exp_node.children.map { |node| node.to_html.strip unless node.text.blank? || node.text =~ /^\s+Explanation/ }
      exp_fragments.compact!

      picture.explanation = exp_fragments.join


      # look for media; start with img element
      imgs = parser.css('img')

      if !imgs.empty?
        img = imgs.first

        img.attributes.keys.select { |k| k != 'src' }.each { |a| img.remove_attribute(a) }

        picture.media = img.to_html
        picture.media_link = img.parent[:href]
      end


      # Lastly, we save the picture
      picture.save
    end
  end
end
