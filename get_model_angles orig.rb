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

# calculate the region 1 molecule vectors from the first frame

frame = xyz_frames[0]
mol_1_orig = (frame[0].coord - frame[2].coord).normalize
mol_2_orig = (frame[4].coord - frame[6].coord).normalize
mol_3_orig = (frame[8].coord - frame[10].coord).normalize
mol_4_orig = (frame[12].coord - frame[14].coord).normalize
# loop over all frames calculating dot product with first frame

xyz_frames.each do|f|
	mol_1 = (f[0].coord - f[2].coord).normalize
	mol_2 = (f[4].coord - f[6].coord).normalize
	mol_3 = (f[8].coord - f[10].coord).normalize
	mol_4 = (f[12].coord - f[14].coord).normalize
	angle_1 = Math.acos(mol_1.dot mol_1_orig)*180/Math::PI
	angle_2 = Math.acos(mol_2.dot mol_2_orig)*180/Math::PI
	angle_3 = Math.acos(mol_3.dot mol_3_orig)*180/Math::PI
	angle_4 = Math.acos(mol_4.dot mol_4_orig)*180/Math::PI
	puts "%8.2f %8.2f %8.2f %8.2f" % [angle_1, angle_2, angle_3, angle_4]
end

