#!/opt/local/bin/ruby -w

require "matrix.rb"

class Atom
	def initialize(name, coord)
		@name   = name
		@coord = coord
	end
	
	attr_reader :name, :coord
	
	def to_s
		"Atom: #{@name} - #{@coord}"
	end
end


#open xyz file
xyz_filename = ARGV.pop
xyz_file = File.new(xyz_filename, "r")

# Hash to store frames
xyz_frames = Array.new

while xyz_line = xyz_file.gets
	
	# arrays to store atom coordinates
	frame = Array.new

	# read number of atoms
	natoms = xyz_line.to_i

	# skip comment line
	xyz_file.gets

	# read atoms
	1.upto(natoms) do
		xyz_line = xyz_file.gets
		tokens = xyz_line.split
		coord = Vector[tokens[1].to_f, tokens[2].to_f, tokens[3].to_f]
		frame.push Atom.new(tokens[0], coord)
	end
  xyz_frames.push frame
end

xyz_frames.each do|x|
  puts "new frame"
	x.each do|f|
		puts f
  end
end

