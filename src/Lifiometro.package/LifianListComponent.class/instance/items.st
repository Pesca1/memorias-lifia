accessing
items
	^ LifiometroRepository singleton lifians
		asSortedCollection: [ :a :b | a lastName < b lastName ]