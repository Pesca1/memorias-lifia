Class {
	#name : #DoiImportComponent,
	#superclass : #BibtexChunckImportComponent,
	#category : 'Lifiometro-Web'
}

{ #category : #accessing }
DoiImportComponent >> doi [
	^ doi
]

{ #category : #accessing }
DoiImportComponent >> doi: anObject [
	doi := anObject
]

{ #category : #callbacks }
DoiImportComponent >> fetch [
	bibtexEntry := DoiToBibAPI new get: doi.
	bibtexEntry ifNil: [ ^ error := 'No encontré nada.' ].

]

{ #category : #rendering }
DoiImportComponent >> renderFetchFormOn: html [
	html
		tbsForm: [ html
				tbsFormGroup: [ html label
						for: 'doi';
						with: 'DOI'.
					html textInput
						tbsFormControl;
						on: #doi of: self;
						id: 'doi';
						placeholder: '10.1430/8105 '.
					html break.
					html tbsButton
						beDefault;
						callback: [ self answer: nil ];
						with: 'Cancelar'.
					html space.
					html tbsButton
						bePrimary;
						callback: [ self fetch ];
						with: 'Obtener' ] ]
]
