var anchor = document.location.hash.substr(1);
var loc = document.location.href;
if( anchor ) {
	loc = loc.substr(0,loc.length-anchor.length-1);
}
function term( termTitle ) {
	return terms[termTitle] || '{'+termTitle+'}';
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
function setMXMLOnly() {
    if( $.cookie("showMXML") == "false" ) toggleMXMLOnly();
}
function toggleMXMLOnly() {
	var mxmlDiv = $("#mxmlSyntax,#hideMxmlLink");
	var mxmlShowLink = $("#showMxmlLink");
	
	if( mxmlDiv.length > 1 ) {
		mxmlDiv.toggle();
		mxmlShowLink.toggle();
		
		$.cookie( "showMXML", mxmlDiv.is(":hidden"), { expires: 3000, path: "/", domain: document.location.domain } );
	}
}

$.fn.asdocify = function() {
	
	$( '#subNav a:gt(0)', this ).before( '<span>|</span>' );
	
	$( 'div.summarySection>table', this )
		.zebra( 'tbody>tr' )
		.addInheritedLinks( 'summaryTable', 'tbody>tr', 'inherited' );
	
	SyntaxHighlighter.highlight();
	return this;
}
$(document).ready( function(){
	
	$( "body" ).addClass( "jsEnabled" ).asdocify();
	$( "table#titleTable td.titleTableTopNav" ).append( function() {
		
		function updateFramesLink() {
			framesLink.attr( 'href', targetLoc + ( document.location.hash || '' ) );
		}
		
		var framesLink = $( '<a>' + term( 'Frames' ) + '</a>' ).click( updateFramesLink );
		var targetLoc = baseRef + "index.html#" + loc.substr( removeBackRefs( loc + '/../' + baseRef ).length );
		
		updateFramesLink();
		
		// for 'open in new tab'
		setInterval( updateFramesLink, 1000 );
		
		return framesLink;
	} );
	
	inherited.init();
});

function indexInit() {
	new ContentContainerWrapper( loc );
}