require 'json'

class Sample

  attr_accessor :type, :energy, :key, :file, :mode
  def initialize file
    @file = File.basename(file).sub(/_analysis.json/,".wav").sub(/^.\//,'')
    track = JSON.parse(File.read(file))["response"]["track"]
    @file = "! " + @file if track["song_id"]
    (@file.match(/drums/) or @file.match(/^D/)) ? @type = "drums" : @type = "bass"
    exclude = ["analysis_url","tempo","time_signature","danceability","duration"]
    (track["audio_summary"].keys - exclude).each { |k| instance_variable_set(:"@#{k}", track["audio_summary"][k]) }
  end

  def property_names
    instance_variables.collect{|v| v.to_s}
  end

  def properties
    instance_variables.collect{|v| instance_variable_get v}
  end

  def interval k
    diff = k.key - @key
    [diff, diff - 12, diff + 12].sort{|a,b| a.abs <=> b.abs}.first
  end

  def same? k
    @mode == k.mode and @key == k.key and @file != k.file
  end

  def energy_boost? k
    @mode == k.mode and [1,2].include? interval k
  end

  def relative? k
    @mode == 1 and k.mode == 0 and interval(k).abs == 3
  end

  def fifth? k
    @mode == k.mode and interval(k).abs == 5 
  end

  def harmonic? k
    same? k or relative? k or fifth? k
  end

  def transition k
    return "same" if same? k
    return "energy" if energy_boost? k
    return "relative" if relative? k
    return "fifth" if fifth? k
  end

  def scale
    notes = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
    modes = ["maj","min"]
    "#{notes[@key]}#{modes[@mode]}"
  end

  def to_s
    @file
  end

  def path
    File.join AUDIO_DIR, @file
  end

  def play
    `mplayer #{path}`
  end

  def mix s
    `gst-launch-1.0 filesrc #{path} ! adder name=mix ! audioconvert ! alsasink filesrc #{s.path} ! mix.`
  end
end
