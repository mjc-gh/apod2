namespace :apod do
  task env: :environment do
    require 'gopher'
  end

  desc "Count how many are missing"
  task missing: :env do
    puts "Fetching Index Page..."

    missing = Gopher.missing_pictures

    puts "Missing #{missing.size} pictures from #{missing.last[:date]} to #{missing.first[:date]}\n"
  end

  desc "Fetch newest pictures"
  task fetch: :env do
    # TODO use optsparser here instead of ENV
    index = 0
    limit = ENV['LIMIT'].to_i

    missing = Gopher.missing_pictures
    missing.reverse! if ENV['NEWEST_FIRST']

    puts "Fetching #{missing.size} Pictures..."

    missing.each do |pic|
      break if !limit.zero? && index >= limit

      print "Fetching #{pic[:id]}..."
      Gopher.fetch_and_create_picture(pic)
      print " done\n"

      index += 1
    end
  end
end
