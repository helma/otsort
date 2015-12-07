#!/usr/bin/env ruby
require 'json'
key = "UAUUYRPQSLQHAMFGV"
Dir["*.wav"].each do |f|
  puts f
  begin
  response = `curl -iv -X POST -H "Content-Type:application/octet-stream" "http://developer.echonest.com/api/v4/track/upload?api_key=#{key}&filetype=wav" --data-binary "@#{f}"`
  puts response
  file = f.sub(/\.wav$/,'_response.json')
  File.open(file,"w+"){|out| out.puts response }
  id = JSON.parse(response)["track"]["id"]
  puts id
  status = 1
  json = ""
  while status != 0
    sleep 1
    json = `curl -iv http://developer.echonest.com/api/v4/track/profile?api_key=#{key}&format=json&id=#{id}&bucket=audio_summary`
    status = JSON.parse(json)["status"]["code"].to_i
  end
  out = f.sub(/wav$/,'json')
  #puts e.track.analysis(f).json
  File.open(out,"w+"){|of| of.puts json }
  puts json
  rescue
  end
end
