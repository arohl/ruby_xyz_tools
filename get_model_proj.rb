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

#define rotation matrix

rotation =  Matrix.columns([[-0.60931, 0.35178, 0.71063], [0.16237, -0.82186, 0.54606], [0.77613, 0.44810, 0.44365]])

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
		coord = rotation * coord
		frame.push Atom.new(tokens[0], coord)
	end
  xyz_frames.push frame
end

# calculate the region 1 molecule vectors from the first frame

frame = xyz_frames[0]

# number of molecules want angles for - note each row has 2 (and we only want 1)
# and there are 4 rows (i.e. 8 mols) in region 2 and 3

n_mols = natoms/2 - 8
n_rows = n_mols/2


mol = Array.new

# loop over all frames 
xyz_frames.each do|f|
  # region 1 atoms are the first atoms in each frame
	for i in 0..n_rows-1 do
		mol[i] = (f[i*4].coord - f[i*4+2].coord)
#		mol[i] = (f[i*4].coord - f[i*4+2].coord).normalize
#		angle = Math.acos(mol[i].dot z_vector)*180/Math::PI - angle_orig[i]
		print "%8.4f %8.4f %8.4f" % [mol[i][0], mol[i][1], mol[i][2]]
	end
	print "\n"
end

