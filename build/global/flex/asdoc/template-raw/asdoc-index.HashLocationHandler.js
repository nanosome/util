var HashLocationHandler = function( contentHandler, root, onChange, contentId ) {
	this.handler = contentHandler;
	this.hash = document.location.hash;
	this.root = root;
	this.onChange = onChange;
	this.contentId = contentId;
	contentHandler.request( this.getUrlFromHash( document.location.hash ), contentId );
	setInterval( $.proxy( this, 'check' ), 250 );
};

HashLocationHandler.prototype = {
	getUrlFromHash: function ( hash ) {
		var parts = /#([a-zA-Z0-9.\/-]*)(#(.*))?/.exec(hash);
		var url;
		if( parts ) {
			url = parts[1];
			if( parts[3] ) {
				url += "#" + parts[3];
			}
		} else {
			url = this.root;
		}
		return url;
	},
	check: function () {
		var hash = document.location.hash;
		if( hash != this.hash ) {
			this.hash = hash;
			this.handler.request( this.getUrlFromHash( hash ), this.contentId );
		}
	},
	update: function() {
		var hash = "#" + this.handler.location();
		if( hash != this.hash ) {
			document.location.href = loc+hash;
			this.hash = "#" + hash;
			this.onChange && this.onChange();
		}
	}
};