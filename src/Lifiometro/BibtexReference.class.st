"
https://nwalsh.com/tex/texhelp/bibtx-7.html
"
Class {
	#name : #BibtexReference,
	#superclass : #LifiaLogEntry,
	#instVars : [
		'bibtexEntry',
		'selfArchivingUrl'
	],
	#category : 'Lifiometro-Model'
}

{ #category : #'instance creation' }
BibtexReference class >> bibtexEntry: anObject [
	^ self new
		bibtexEntry: anObject;
		yourself
]

{ #category : #'instance creation' }
BibtexReference class >> isVoyageRoot [
	^ true 
]

{ #category : #accessing }
BibtexReference >> asReference [
	bibtexEntry type = 'article'
		ifTrue: [ ^ self authors , ', "' , self title , '," ' , self journal
				, ', vol. ' , self volume , ', pp. ' , self pages , ', '
				, self month , '. ' , self year , '.' ].
	bibtexEntry type = 'inproceedings'
		ifTrue: [ ^ self authors , ', "' , self title , '", in ' , self booktitle
				, ', ' , self month , ', ' , self year , ', ' , self editors
				, ', Eds., ' , self publisher , '. pp. ' , self pages ].
	bibtexEntry type = 'inbook'
		ifTrue: [ ^ self authors , ': ' , self title , '. In: ' , self booktitle
				, '. (' , self year , '), ' , self pages ].
	bibtexEntry type = 'book'
		ifTrue: [ ^ (self authors ifEmpty: [ self editors , ' (eds) ' ]) , ', '
				, self title , ', ' , self publisher , ', ' , self year ].
	^ self title ifEmpty: [ 'Something is not right' ]
]

{ #category : #accessing }
BibtexReference >> asSummary [
	^ self asReference
]

{ #category : #accessing }
BibtexReference >> at: aPropertyName [
	(self instanceVariableProperties includes: aPropertyName)
		ifTrue: [ ^ self perform: aPropertyName asValidSelector ].
	^ (bibtexEntry at: aPropertyName) ifNil: [ '' ]
]

{ #category : #accessing }
BibtexReference >> at: aPropertyName put: aValue [
	(self instanceVariableProperties includes: aPropertyName)
		ifTrue: [ ^ self perform: aPropertyName asValidSelector asMutator with: aValue ].
	bibtexEntry at: aPropertyName put: aValue
]

{ #category : #accessing }
BibtexReference >> authors [
	^ self withSimplifiedAnds: bibtexEntry author
]

{ #category : #accessing }
BibtexReference >> bibtexEntry [
	^ bibtexEntry
]

{ #category : #accessing }
BibtexReference >> bibtexEntry: anObject [
	bibtexEntry := anObject
]

{ #category : #accessing }
BibtexReference >> booktitle [
	^(bibtexEntry at: 'booktitle') ifNil: [ '' ]
]

{ #category : #utility }
BibtexReference >> cleanupWeirdLatexAccents [
	self title: self title copyWithoutWeirdLatexAccents.
	(self bibtexEntry at: 'author')
		ifNotNil: [ self bibtexEntry
				at: 'author'
				put: (self bibtexEntry at: 'author') copyWithoutWeirdLatexAccents ].
	(self bibtexEntry at: 'editor')
		ifNotNil: [ self bibtexEntry
				at: 'editor'
				put: (self bibtexEntry at: 'editor') copyWithoutWeirdLatexAccents ]
]

{ #category : #accessing }
BibtexReference >> editors [
	^ self withSimplifiedAnds: bibtexEntry editor
]

{ #category : #accessing }
BibtexReference >> instanceVariableProperties [
	^ {'selfArchivingUrl' . 'relatedLifians' . 'relatedProjects'}
]

{ #category : #accessing }
BibtexReference >> journal [
	^ (bibtexEntry at: 'journal') ifNil: [ '' ]
]

{ #category : #accessing }
BibtexReference >> month [
	^ self at: 'month'
]

{ #category : #accessing }
BibtexReference >> pages [
	^ (bibtexEntry at: 'pages') ifNil: [ '' ]
]

{ #category : #accessing }
BibtexReference >> propertyNames [
	| existing standardFields |
	existing := ((bibtexEntry tags
		select: [ :each | each value notEmpty ]) collect: #name) asSet.
	standardFields := Dictionary new.
	standardFields
		at: 'article'
			put:
			{'author' . 'title' . 'journal' . 'year' . 'volume' . 'number' . 'pages'.
			'month' . 'note'};
		at: 'inproceedings'
			put:
			{'author' . 'title' . 'booktitle' . 'year' . 'editor' . 'pages' . 'organization'.
			'publisher' . 'address' . 'month' . 'note'};
		at: 'inbook'
			put:
			{'author' . 'editor' . 'title' . 'chapter' . 'pages' . 'publisher'.
			'year' . 'volume' . 'series' . 'address' . 'edition' . 'month'.
			'note' . 'key'};
		at: 'book'
			put:
			{'author' . 'editor' . 'title' . 'publisher' . 'year' . 'volume'.
			'series' . 'address' . 'edition' . 'month' . 'note'}.
	existing addAll: (standardFields at: bibtexEntry type).
	existing
		add: 'selfArchivingUrl';
		add: 'relatedProjects';
		add: 'relatedLifians'.
	^ existing
]

{ #category : #accessing }
BibtexReference >> publisher [
	^ (bibtexEntry at: 'publisher') ifNil: [ '' ]
]

{ #category : #accessing }
BibtexReference >> selfArchivingUrl [
	^ selfArchivingUrl
]

{ #category : #accessing }
BibtexReference >> selfArchivingUrl: anObject [
	selfArchivingUrl := anObject
]

{ #category : #accessing }
BibtexReference >> title [
	^ bibtexEntry title
]

{ #category : #accessing }
BibtexReference >> title: aString [ 
	bibtexEntry at: 'title' put: aString
]

{ #category : #accessing }
BibtexReference >> type [
	^ bibtexEntry type
]

{ #category : #accessing }
BibtexReference >> type: aString [
	bibtexEntry type: aString
]

{ #category : #accessing }
BibtexReference >> volume [
	^ (bibtexEntry at: 'volume') ifNil: [ '' ]
]

{ #category : #accessing }
BibtexReference >> withSimplifiedAnds: aStringToClean [
	| parts stream |
	aStringToClean ifNil: [ ^ '' ].
	stream := String new writeStream.
	aStringToClean
		do: [ :each | 
			(each = Character lf or: [ each = Character cr ])
				ifTrue: [ stream nextPut: Character space ]
				ifFalse: [ stream nextPut: each ] ].
	parts := stream contents withBlanksCondensed splitOn: ' and '.
	parts size < 3
		ifTrue: [ ^ stream contents ].
	stream := String new writeStream.
	(parts copyFrom: 1 to: parts size - 1)
		do: [ :each | stream nextPutAll: each ]
		separatedBy: [ stream nextPutAll: ', ' ].
	stream
		nextPutAll: ' and ';
		nextPutAll: parts last.
	^ stream contents
]

{ #category : #accessing }
BibtexReference >> year [
	[ bibtexEntry year asNumber ]
		on: Error
		do: [ ^ '1980' ].
	^ bibtexEntry year
]

{ #category : #accessing }
BibtexReference >> yearsActive [
	^ {self year asNumber}
]