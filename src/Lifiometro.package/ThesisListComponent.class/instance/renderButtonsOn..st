rendering
renderButtonsOn: html
	html div
		style: 'padding-top:10px;padding-bottom:10px';
		with: [ html anchor
				callback: [ self addThesis ];
				with: [ html tbsButton
						beDefault;
						beSmall;
						with: 'Agregar' ] ]