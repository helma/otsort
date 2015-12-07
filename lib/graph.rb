require 'graphviz'

class Graph < GraphViz

  def initialize samples
    super :G, :type => :digraph 
    @nodes = samples.collect{|s| add_nodes s.file + " " + s.scale + " " + s.energy.round(3).to_s}
    samples.each_with_index do |s1,i|
      samples.each_with_index do |s2,j|
        edge = add_edges @nodes[i], @nodes[j] if s1.harmonic? s2 or s1.energy_boost? s2
        edge[:label] = "same" if s1.same? s2
        edge[:label] = "energy" if s1.energy_boost? s2
        edge[:label] = "relative" if s1.relative? s2
        edge[:label] = "fifth" if s1.fifth? s2
      end
    end
  end

  def display
    output :xlib => nil
  end
  
end
