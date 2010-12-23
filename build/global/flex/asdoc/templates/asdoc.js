////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2006-2008 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
// 
//  Heavily modified by Martin Heidegger
//
////////////////////////////////////////////////////////////////////////////////
var anchor = document.location.hash.substr(1);
var loc = document.location.href;
if( anchor ) {
	loc = loc.substr(0,loc.length-anchor.length-1);
}
function configPage() {
	
	var subNav =  $('#subNav');
	
	if( window != window.top ) {
		$("body").addClass("framed");
	}
	
	$( "a:gt(0)", subNav ).before("<span>&nbsp;|&nbsp;</span>");
	$( "a:[href]" ).each( function() {
		
		var a = $(this);
		var href = a.attr("href");
		if( href.charAt(0) == "#" ) {
			a.attr("href", loc+href);
		}
	});
	
	$( ".framesLink" ).click( function() {
		if( document.location.hash ) {
			document.location.href = this.href + "**" + document.location.hash.substr(1)
		} else {
			document.location.href = this.href;
		}
		return false;
	});
	
	// ZEBRA Effect for tables
	$( ["Property","Method","ProtectedMethod","Event","Style","SkinPart","SkinState","Constant","ProtectedConstant"] ).each( function( no, selectorText) {
		var even = false;
		$( "#summaryTable" + selectorText + ">tbody>tr" ).each( function( no, elem ) {
			$(elem).addClass( even ? "row0" : "row1" );
			even = !even;
		} );
	} );
	
	$( ["Constant","ProtectedConstant","Property","ProtectedProperty","Method","ProtectedMethod","Event","Style","SkinPart","SkinState","Effect"] ).each( function( no, selectorText ) {
		setInheritedVisible( $.cookie("showInherited"+selectorText) == "true", selectorText );
	});
	
	SyntaxHighlighter.all();
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
function setInheritedVisible(show, selectorText)
{
    if (document.styleSheets[0].cssRules != undefined)
    {
        var rules = document.styleSheets[0].cssRules;
        for (var i = 0; i < rules.length; i++)
        {
            if (rules[i].selectorText == ".hideInherited" + selectorText)
                rules[i].style.display = show ? "" : "none";
                
            if (rules[i].selectorText == ".showInherited" + selectorText)
                rules[i].style.display = show ? "none" : "";
        }
    }
    else
    {
        document.styleSheets[0].addRule(".hideInherited" + selectorText, show ? "display:inline" : "display:none");
        document.styleSheets[0].addRule(".showInherited" + selectorText, show ? "display:none" : "display:inline");
    }
    $.cookie("showInherited" + selectorText, show ? "true" : "false", { expires: 3000, path: "/", domain: document.location.domain } );
	
	var even = false;
    var table = $("#summaryTable" + selectorText + ">tbody>tr").each( function( no, e ) {
		var elem = $(e);
		if( elem.hasClass("hideInherited") || show ) {
			elem.addClass( even ? "row0" : "row1" );
			even = !even;
		}
	});
}

$(document).ready(configPage);