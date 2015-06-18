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

# number of molecules want angles for - note each row has 2 (and we only want 1)
# and there are 4 rows (i.e. 8 mols) in region 2 and 3

n_mols = natoms/2 - 8
n_rows = n_mols/2

z_vector = Vector[0, 0, 1]
mol_orig = Array.new
angle_orig = Array.new
mol = Array.new

# calculate the region 1 molecule angles from the first frame
frame = xyz_frames[0]
for i in 0..n_rows-1 do
	mol_orig[i] = (frame[i*4].coord - frame[i*4+2].coord).normalize
	angle_orig[i] = Math.acos(mol_orig[i].dot z_vector)*180/Math::PI
end
# loop over all frames calculating dot product with [0 0 1]
xyz_frames.each do|f|
  # region 1 atoms are the first atoms in each frame
	for i in 0..n_rows-1 do
		mol[i] = (f[i*4].coord - f[i*4+2].coord).normalize
		angle = Math.acos(mol[i].dot z_vector)*180/Math::PI - angle_orig[i]
		print "%8.2f " % [angle]
	end
	print "\n"
end

