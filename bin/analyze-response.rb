#!/usr/bin/env ruby
require 'json'
require 'yaml'
key = "UAUUYRPQSLQHAMFGV"
Dir["*_response.json"].each do |f|
  puts f
  out = f.sub(/response/,'analysis')
  unless File.exists? out
  begin
    response = JSON.parse File.read(f).split("\n").last
    puts response.to_yaml
    status = response["response"]["status"]["code"]
    if status == 0
      puts "=="
      id = response["response"]["track"]["id"]
      puts id
      status = 1
      json = ""
      while status != 0
        sleep 1
        analysis = `curl "http://developer.echonest.com/api/v4/track/profile?api_key=#{key}&format=json&id=#{id}&bucket=audio_summary"`
        status = JSON.parse(analysis)["response"]["status"]["code"]
      end
      puts analysis
      #puts e.track.analysis(f).json
      File.open(out,"w+"){|of| of.puts analysis }
    end
  end
  end
end
=begin
  file = f.sub(/\.wav$/,'_response.json')
  File.open(file,"w+"){|out| out.puts response }
  puts id
  puts json
  rescue
  end
end
=end
