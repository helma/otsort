LIB_DIR = File.dirname(__FILE__)
ROOT_DIR = File.expand_path(File.join LIB_DIR, "..")
AUDIO_DIR = File.join ROOT_DIR, "audio"
ANALYSIS_DIR = File.join ROOT_DIR, "analysis"

Dir["#{LIB_DIR}/*.rb"].each{|f| require_relative f unless File.basename(f) == File.basename(__FILE__)}

@samples = Dir[File.join(ANALYSIS_DIR,"*analysis.json")].collect { |f| Sample.new f }.sort_by!{|s| [s.type, s.energy]}
