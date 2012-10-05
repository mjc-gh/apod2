require_dependency 'apod_web'

class Gopher
  # Getting a list of missing idents (AP-Dates)
  #
  # @returns Array list of ident strings
  def self.missing_idents
    # get index listing from ApodWeb (make http req)
    parser = ApodWeb.index

    # get last ident in DB; default to empty string since its always less than
    last = Picture.last.try(:ident) || ''

    [].tap do |missing|
      parser.css('a').each do |link|
        match = link[:href].to_s.match %r[(ap\d+)\.html$]

        missing << match[1] if match && match[1] > last
      end
    end
  end
end
