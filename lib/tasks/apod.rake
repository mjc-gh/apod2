namespace :apod do
  task env: :environment do
    require 'gopher'
  end

  desc "Count how many are missing"
  task missing: :env do
    missing = Gopher.missing_pictures

    puts "Missing #{missing.size} pictures from #{missing.first[:date]} to #{missing.last[:date]}\n"
  end

  desc "Fetch newest pictures"
  task fetch: :env do
    missing = Gopher.missing_pictures

    puts "Fetching #{missing.size} Pictures..."

    missing.each do |ap|
      print "Fetching #{ap[:id]}..."
      Gopher.fetch_and_create_picture(ap)
      print " done\n"
    end
  end

  desc "Fetch all pictures by querying DB for existence"
  task index: :env do
    index = Gopher.apid_index

    if ENV['START']
      date = Picture.date_from_apid(ENV['START'])
      index.reject! { |ap| ap[:date] < date } if date
    end

    puts "Will Fetch #{index.size} Pictures"
    puts "Press enter to continue..."
    $stdin.gets

    index.each do |ap|
      print "Fetching #{ap[:id]}..."
      Gopher.fetch_and_create_picture(ap)
      print " done\n"
    end
  end
end
