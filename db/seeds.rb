unless Room.any?
	Room.create([
		{name: 'Sala 1'},
		{name: 'Sala 2'},
		{name: 'Sala 3'},
		{name: 'Sala 4'}
	])
end
