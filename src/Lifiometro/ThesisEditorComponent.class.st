Class {
	#name : #ThesisEditorComponent,
	#superclass : #PluggableEditorComponent,
	#category : 'Lifiometro-Web'
}

{ #category : #'accept/cancel' }
ThesisEditorComponent >> accept [
	[ (newValues at: 'startDate') asDate ]
		on: Error
		do: [ errors add: 'La fecha de inicio deben válida en formato dd/mm/aa' ].
	(newValues at: 'title')
		ifEmpty: [ errors add: 'Debe espedíficar un título' ].
	(newValues at: 'student')
		ifEmpty: [ errors add: 'Debe especifica rel nombre del alumno' ].
	(newValues at: 'director')
		ifEmpty: [ errors add: 'Debe especificar el nombre del director' ].
	(newValues at: 'career')
		ifEmpty: [ errors add: 'Debe especificar la carrera' ].
	(newValues at: 'level')
		ifEmpty: [ errors add: 'Debe especificar el nivel' ].
	errors ifNotEmpty: [ ^ self ].
	super accept
]

{ #category : #'accept/cancel' }
ThesisEditorComponent >> renderLevelEditorOn: html [
	html
		tbsFormGroup: [ html label
				for: 'level';
				with: 'Nivel'.
			html break.
			html radioGroup
				callback: [ :value | newValues at: 'level' put: value ];
				selected: (newValues at: 'level');
				with: [ :group | 
					{'Undergraduate' . 'Specialization' . 'Masters' . 'PhD'}
						do: [ :each | 
							group radioButton value: each.
							html
								space;
								text: each;
								break ] ] ]
]

{ #category : #'accept/cancel' }
ThesisEditorComponent >> renderPropertyEditorsOn: html [
	self
		renderTextInputEditorFor: 'student'
		label: 'Alumno(s)'
		instructions: nil
		on: html.
	self
		renderTextInputEditorFor: 'title'
		label: 'Título de la tesis/tesina/trabajo'
		instructions: nil
		on: html.
	self renderLevelEditorOn: html.
	self
		renderTextInputEditorFor: 'career'
		label: 'Carrera'
		instructions: nil
		on: html.
	self
		renderDateInputEditorFor: 'startDate'
		label: 'Fecha de inicio'
		instructions: nil
		on: html.
	self
		renderDateInputEditorFor: 'endDate'
		label: 'Fecha de fin'
		instructions: nil
		on: html.
	self
		renderTextInputEditorFor: 'director'
		label: 'Director(es)'
		instructions: nil
		on: html.
	self
		renderTextInputEditorFor: 'coDirector'
		label: 'Co-Director(es)'
		instructions: nil
		on: html.
	self
		renderTextInputEditorFor: 'otherAdvisors'
		label: 'Asesores'
		instructions: nil
		on: html.
	self
		renderTextInputEditorFor: 'summary'
		label: 'Resumen'
		instructions: nil
		on: html.
	self renderRelatedLifiansEditorOn: html.
	self renderRelatedProjectsEditorOn: html
]