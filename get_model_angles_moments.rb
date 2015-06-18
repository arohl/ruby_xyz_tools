#!/opt/local/bin/ruby -w

require "matrix.rb"

class Eigen
	def initialize(mol, coord)
		@mol   = mol
		@coord = coord
	end
	
	attr_reader :mol, :coord
	
	def to_s
		"Atom: #{@mol} - #{@coord}"
	end
end


#open xyz file
ine_filename = ARGV.pop
ine_file = File.new(ine_filename, "r")

# Hash to store frames
ine_frames = Array.new

# array to store eigenvectors
frame = Array.new
mol_no = 0
while ine_line = ine_file.gets
	
	# skip comments	
	if ine_line.start_with?("#")
	  next
	end
	
	# read first eigenvector
	tokens = ine_line.split
	new_mol = tokens[0].to_i
	if new_mol > mol_no
		mol_no = new_mol
	  eigen = Vector[tokens[2].to_f, tokens[3].to_f, tokens[4].to_f]
	  frame.push Eigen.new(mol_no, eigen)
	else
		ine_frames.push frame
		mol_no = new_mol
		frame = Array.new
		eigen = Vector[tokens[2].to_f, tokens[3].to_f, tokens[4].to_f]
	  frame.push Eigen.new(mol_no, eigen)
	end
	# skip next two
		ine_file.gets
		ine_file.gets

end

# calculate the eigenvector angles for first frame
z_vector = Vector[0, 0, 1]

frame = ine_frames[0]
angle_first = Array.new

frame.each do |f_first|
	angle_first.push Math.acos((f_first.coord.dot z_vector).abs)*180/Math::PI
end

# loop over all frames calculating dot product with [0 0 1]
ine_frames.each do|f|
  i=0;
	while (i < f.length)
		angle = Math.acos((f[i].coord.dot z_vector).abs)*180/Math::PI - angle_first[i]
		print "%8.2f " % [angle]
		i = i + 2
	end
	print "\n"
end

