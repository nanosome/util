var anchor = document.location.hash.substr(1);
var loc = document.location.href;
if( anchor ) {
	loc = loc.substr(0,loc.length-anchor.length-1);
}
function removeBackRefs( href ) {
	href = href.split("/");
	for( var i = 0; i<href.length;++i ) {
		if( href[i] == ".." ) {
			href.splice(i-1,2);
			i-=2;
		};
	}
	return href.join('/');
}
function configPage() {
	
	$( "#subNav a:gt(0)" ).before("<span>|</span>");
	
	$( ".framesLink" ).click( function() {
		if( document.location.hash ) {
			document.location.href = this.href + "**" + document.location.hash.substr(1)
		} else {
			document.location.href = this.href;
		}
		return false;
	});
	
	$( ".summarySection>table" ).each( function() {
		var id = this.parentNode.id.substr( 12 );
		var inheritedRows = $( 'tbody>tr.inherited', this );
		var rows = $( 'tbody>tr', this );
		if( rows.length == inheritedRows.length ) {
			$( this ).addClass( "hideInherited" );
		}
		if( inheritedRows.length > 0 ) {
			$( '<span class="hideInherited">' + terms["Hide"+id] + '</span>' ).insertBefore( this ).click( function() {
				setInheritedVisible( false, "showInherited"+id );
			});
			$( '<span class="showInherited">' + terms["Show"+id] + '</span>' ).insertBefore( this ).click( function() {
				setInheritedVisible( true, "showInherited"+id );
			});
		}
	});
	
	// ZEBRA Effect for tables
	$( "div.summarySection>table" ).each( function( no, selectorText) {
		var even = false;
		$( "tbody>tr", this ).each( function() {
			$(this).addClass( (even = !even) ? "row0" : "row1" );
		} );
	} );
	
	SyntaxHighlighter.highlight();
}
function setMXMLOnly() {
    if( $.cookie("showMXML") == "false" ) toggleMXMLOnly();
}
function toggleMXMLOnly() {
    var mxmlDiv = $("#mxmlSyntax")[0];
    var mxmlShowLink = $("#showMxmlLink")[0];
    var mxmlHideLink = $("#hideMxmlLink")[0];
    
    if( mxmlDiv && mxmlShowLink && mxmlHideLink ) {
        if (mxmlDiv.style.display == "none")
        {
            mxmlDiv.style.display = "block";
            mxmlShowLink.style.display = "none";
            mxmlHideLink.style.display = "inline";
        }
        else
        {
            mxmlDiv.style.display = "none";
            mxmlShowLink.style.display = "inline";
            mxmlHideLink.style.display = "none";
        }
        $.cookie( "showMXML", mxmlDiv.style.display == "none" ? "true" : "false", { expires: 3000, path: "/", domain: document.location.domain } );
    }
}

function setInheritedVisible(show, cls) {
	$( document.body ).toggleClass( cls );
	$.cookie( cls, show ? "true" : "false", { expires: 3000, path: "/", domain: document.location.domain } );
}

var inheritedTypes = ["Constant","ProtectedConstant","Property","ProtectedProperty","Method","ProtectedMethod","Event","Style","SkinPart","SkinState","Effect"];

$(document).ready( function(){
	configPage();
	$( "body" ).addClass( "jsEnabled" );
	$( "table#titleTable td.titleTableTopNav" ).each(function() {
		var link = document.createElement("a");
		link.innerHTML = terms.Frames;
		var l = loc.split('/');
		l.pop();
		l = removeBackRefs( l.join('/') + '/' + baseRef );
		l = loc.substr( l.length );
		link.href = baseRef + "index.html#" + l;
		if( document.location.hash ) {
			link.href += document.location.hash;
		}
		link.onclick = function() {
			this.href = baseRef + "index.html#" + l;
			if( document.location.hash ) {
				this.href += document.location.hash;
			}
		}
		this.appendChild( link );
	});
	
	var bodycls = document.body.className;
	$( inheritedTypes ).each( function() {
		var cls = "showInherited"+this;
		if( $.cookie(cls) == "true" ) {
			bodycls += " "+cls;
		}
	});
	
	document.body.className = bodycls;
});

var s = ".hideInherited { display: none; }\n";
$( inheritedTypes ).each( function() {
	s += 'body.showInherited'+this+' #summaryTable'+this+' .showInherited { display: none; }\n'
		+ 'body.showInherited'+this+' #summaryTable'+this+' span.hideInherited { display: inline; }\n'
		+ 'body.showInherited'+this+' #summaryTable'+this+' table.hideInherited { display: ' + ($.browser.msie ? 'block' : 'table' ) + '; }\n'
		+ 'body.showInherited'+this+' #summaryTable'+this+' tr.inherited { display: ' + ($.browser.msie ? 'block' : 'table-row' ) + '; }\n';
});

document.write( '<style type="text/css">' + s + '</style>' );