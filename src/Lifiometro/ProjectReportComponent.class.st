"
| app |
app := WAAdmin register: ProjectReportComponent asApplicationAt: 'project-profile'.
app
        addLibrary: TBSDeploymentLibrary
"
Class {
	#name : #ProjectReportComponent,
	#superclass : #ProfileReportComponent,
	#instVars : [
		'void'
	],
	#category : #'Lifiometro-Reports'
}

{ #category : #urls }
ProjectReportComponent class >> relativeUrl [
	^ 'project-profile'
]

{ #category : #urls }
ProjectReportComponent class >> relativeUrlFor: aProject [
	^ 'project-profile?vid=' , aProject voyageId printString
]

{ #category : #'as yet unclassified' }
ProjectReportComponent >> buildJsonLDDictionary [
	^ JsonLDWriter new projectReportAsDictionary: report
]

{ #category : #hooks }
ProjectReportComponent >> fetchReport [
	| project |
	void := self requestContext request at: 'vid'.
	void ifNil: [ ^ nil ].
	project := LifiometroRepository singleton projectWithVoyageId: void.
	project ifNil: [ ^ nil ].
	^ LifiometroRepository singleton reportForProject: project
]

{ #category : #hooks }
ProjectReportComponent >> renderProjectsOn: html [
	^ self
]

{ #category : #rendering }
ProjectReportComponent >> renderPropertiesOn: html [
	html heading level2 with: 'Ficha técnica'.
	html
		table: [ html
				tableRow: [ html
						tableData: 'Título:';
						tableData: report project title ].
			html
				tableRow: [ html
						tableData: 'Código:';
						tableData: report project code ].
			html
				tableRow: [ html
						tableData: 'Duración:';
						tableData:
							report project startDate asDate printString , ' - '
								, report project endDate asDate printString ].
			html
				tableRow: [ html
						tableData: 'Dirección:';
						tableData: report project director ].
			html
				tableRow: [ html
						tableData: 'Co-Dirección:';
						tableData: report project coDirector ].
			html
				tableRow: [ html
						tableData: 'Grupo responsable:';
						tableData: report project responsibleGroup ].
			html
				tableRow: [ html
						tableData: 'Financiador:';
						tableData: report project fundingAgency ].
			html
				tableRow: [ html
						tableData: 'Monto:';
						tableData: report project amount ].
			html
				tableRow: [ html
						tableData: 'Participantes (del LIFIA)';
						tableData: [ report researchers
								do: [ :each | 
									html anchor
										target: '_blank';
										url: '/' , (ResearcherReportComponent relativeUrlFor: each);
										with: each fullName ]
								separatedBy: [ html text: ', ' ] ] ] ].
	html heading level2 with: 'Resúmen'.
	html paragraph: report project summary
]

{ #category : #hooks }
ProjectReportComponent >> renderTitleOn: html [
	html heading level1 with: report project title
]
