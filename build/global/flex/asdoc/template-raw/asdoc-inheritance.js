var inherited = {
	types: $( ["Constant","ProtectedConstant","Property","ProtectedProperty","Method","ProtectedMethod","Event","Style","SkinPart","SkinState","Effect"] ),
	setVisible: function(show, cls) {
		$( document.body ).toggleClass( cls );
		$.cookie( cls, show ? "true" : "false", { expires: 3000, path: "/", domain: document.location.domain } );
	},
	writeStyleSheet: function() {
		var s = ".hideInherited { display: none; }\n";
		this.types.each( function() {
			s += 'body.showInherited'+this+' #summaryTable'+this+' .showInherited { display: none; }\n'
				+ 'body.showInherited'+this+' #summaryTable'+this+' span.hideInherited { display: inline; }\n'
				+ 'body.showInherited'+this+' #summaryTable'+this+' table.hideInherited { display: ' + ($.browser.msie ? 'block' : 'table' ) + '; }\n'
				+ 'body.showInherited'+this+' #summaryTable'+this+' tr.inherited { display: ' + ($.browser.msie ? 'block' : 'table-row' ) + '; }\n';
		});
		document.write( '<style type="text/css">' + s + '</style>' );
	},
	init: function() {
		var bodycls = document.body.className;
		this.types.each( function() {
			var cls = "showInherited"+this;
			if( $.cookie(cls) == "true" ) {
				bodycls += " "+cls;
			}
		});
		
		document.body.className = bodycls;
	}
};
jQuery.fn.addInheritedLinks = function( idPrefix, rowSelector, inheritedClass ) {
	this.each( function() {
		var id = this.parentNode.id.substr( idPrefix.length );
		var inheritedRows = $( rowSelector+'.'+inheritedClass, this );
		var rows = $( rowSelector, this );
		if( rows.length == inheritedRows.length ) {
			$( this ).addClass( "hideInherited" );
		}
		if( inheritedRows.length > 0 ) {
			$( '<span class="hideInherited">' + term("Hide"+id) + '</span>' ).insertBefore( this ).click( function() {
				inherited.setVisible( false, "showInherited"+id );
			});
			$( '<span class="showInherited">' + term("Show"+id) + '</span>' ).insertBefore( this ).click( function() {
				inherited.setVisible( true, "showInherited"+id );
			});
		}
	});
	return this;
};
inherited.writeStyleSheet();