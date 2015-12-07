#!/usr/bin/env ruby
require_relative "../lib/otsort.rb"

puts `mv -iv #{@unused_samples.collect{|f| File.join AUDIO_DIR, f}.join " "} #{File.join AUDIO_DIR, "bak"}/` unless @unused_samples.empty
