def rename old, new
  old_ot = old.sub(/wav/,"ot")
  new_ot = new.sub(/wav/,"ot")
  puts `cd #{AUDIO_DIR}; mv -iv #{old} #{new}`
  puts `cd #{AUDIO_DIR}; mv -iv #{old_ot} #{new_ot}`
  puts `cd #{AUDIO_DIR}; sed -i 's/#{old}/#{new}/g' project.work`
end

@project_samples = []
sample = false
index = nil
File.new(File.join AUDIO_DIR, "project.work").each do |l|
  l.chomp!
  case l
  when '[SAMPLE]'
    sample = true
  when /TYPE/
    sample = false if l.match /STATIC/
  when /SLOT/
    index=l.split('=').last.to_i
  when /PATH/
    @project_samples[index-1]=l.split('=').last if sample and l.split('=').size == 2
    puts "external sample: #{l}" if l.match /\.\.\//
  when '[/SAMPLE]'
    sample = false
  end
end

@dir_samples = Dir[File.join(AUDIO_DIR,"*.wav")].collect{|f| File.basename f}

@unused_samples = (@dir_samples - @project_samples)
