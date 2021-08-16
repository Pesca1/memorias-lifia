Class {
	#name : #AdministrationComponent,
	#superclass : #WAComponent,
	#category : 'Lifiometro-Web'
}

{ #category : #rendering }
AdministrationComponent >> cleanupTitlesAndAuthors [
	self session references
		do: [ :each | 
			each cleanupWeirdLatexAccents.
			self session save: each ]
]

{ #category : #rendering }
AdministrationComponent >> clearPasswordFor: each [
	each
		clearPassword;
		save
]

{ #category : #rendering }
AdministrationComponent >> guessArticleAuthors [
	self call: GuessInvolvedResearchersComponent new
]

{ #category : #callbacks }
AdministrationComponent >> importFromDblp [
	self call: BibtexURLImporterComponent new
]

{ #category : #rendering }
AdministrationComponent >> renderBulkActionsOn: html [
	^ html tbsPanel
		beDefault;
		with: [ html tbsPanelHeading: [ html label: 'Bulk actions' ].
			html
				tbsPanelBody: [ html anchor
						callback: [ self importFromDblp ];
						with: 'Import from DBLP'.
					html break.
					html anchor
						callback: [ self cleanupTitlesAndAuthors ];
						with: 'Cleanup titles'.
					html break.
					html anchor
						callback: [ self sendTestEmail ];
						with: 'Send test email'.
					html break.
					html anchor
						callback: [ self guessArticleAuthors ];
						with: 'Guess article authors' ] ]
]

{ #category : #rendering }
AdministrationComponent >> renderContentOn: html [
	html
		tbsPanel: [ html tbsPanelBody:
				[ self renderUsersListOn: html.
				self renderBulkActionsOn: html ] ]
]

{ #category : #rendering }
AdministrationComponent >> renderUser: each on: html [
	html
		paragraph: [ html
				strong: each email;
				text: ' - Admin: '.
			html anchor
				callback: [ each toogleAdmin ];
				with: each isAdmin printString.
			html text: ' - Activado: '.
			html anchor
				callback: [ each toggleEnabled ];
				with: each enabled printString.
			each isPasswordSet
				ifTrue: [ html anchor
						callback: [ self clearPasswordFor: each ];
						with: ' - Limpiar password' ]
				ifFalse: [ html span
						style: 'color: red;';
						with: ' - Sin password' ] ]
]

{ #category : #rendering }
AdministrationComponent >> renderUsersListOn: html [
	^ html tbsPanel
		beDefault;
		with: [ html tbsPanelHeading: [ html label: 'Users' ].
			html
				tbsPanelBody: [ LifiometroRepository singleton users
						do: [ :each | self renderUser: each on: html ] ] ]
]

{ #category : #callbacks }
AdministrationComponent >> sendTestEmail [
	| message |
	message := WAEmailMessage
		from: 'casco@lifia.info.unlp.edu.ar'
		to: 'casco@lifia.info.unlp.edu.ar'
		subject: 'Este es un correo de pruebas'.
	message
		body: 'Si te llega este correo es porque funciona la configuración'.
	message send
]