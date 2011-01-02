var RequestHandler = function( loc, container, targetRequestHandler ) {
	var lI = loc.lastIndexOf("/");
	this.pkg = lI ? loc.substr( 0,  lI+1 ) : loc;
	this.container = container;
	this.targetRequestHandler = targetRequestHandler || this;
	this.href;
	this.anchor;
};
RequestHandler.prototype = {
	markPage: function() {
		this.brandLinks();
		if( this.prepareContent ) this.prepareContent();
		this.scrollToAnchor( true );
	},
	absolute: function( url ) {
		if( !/^(\w*:\/\/)/.test( url ) || url.charAt(0) == "#" ) {
			return removeBackRefs( this.pkg + this.href + "/../" + url );
		} else {
			return url;
		}
	},
	scrollToAnchor: function( reset ) {
		if( this.anchor ) {
			var a = ( this.names && this.names[this.anchor] ) || document.getElementById(this.anchor);
			if( a ) {
				var top = Math.round( a.offsetTop );
				$( a.offsetParent ).scrollTop( top );
			}
		} else if( reset ) {
			this.container.scrollTop( 0 );
		}
	},
	brandLinks: function() {
		var that = this;
		
		var names = this.names = {};
		$( "a", this.container ).each( function() {
			var name = this.getAttribute('name');
			if( name ) {
				names[name] = this;
			}
			var href =  this.getAttribute("href");
			if( href ) {
				href = that.changeHref( href );
				if( href ) {
					this.setAttribute( "href", href );
				}
				var target = this.getAttribute( "target" );
				if( !target || target == "_self" ) {
					$.event.add( this, "click", function() {
						try {
						return that.targetRequestHandler.request( this.href, that.id );
						} catch( e ) {
							console.info("error",e);
							return false;
						}
					});
				}
			}
		} );
		
		$( "img", this.container ).each( function() {
			var src = that.changeHref( this.getAttribute("src") );
			if( src ) {
				this.setAttribute( "src", src );
			}
		});
	},
	request: function( href, id ) {
		this.id = id;
		var i = href.indexOf("#");
		var newAnchor = null;
		if( i != -1 ) {
			newAnchor = href.substr(i+1);
			href = href.substr(0,i);
		}
		if( href.indexOf( loc ) == 0 ) {
			href = href.substr( loc.length );
		}
		if( href.indexOf( this.pkg ) == 0 ) {
			href = href.substr( this.pkg.length );
		}
		if( href != "" && !(/\w*:\/\//).test(href) ) {
			this.anchor = newAnchor;
			this.href = href;
			if( this.container ) {
				$( "a", this.container ).unbind( "click" );
				if( this.onLoadStart ) this.onLoadStart();
				if( this.swfRequest ) {
					try {
						this.swfRequest.abort();
					} catch(e){}
				}
				if( this.container ) {
					var that = this;
					if( window['SWFHttpRequest'] ) {
						this.swfRequest = new window['SWFHttpRequest']();
						this.swfRequest.open( 'GET', href );
						this.swfRequest.onreadystatechange = function(){
							if (this.readyState!=4) return;
							if (this == that.swfRequest ) {
								if (this.status==200) {
									that.wrap( this.responseText, id );
								} else {
									that.wrap( null, id );
								}
							}
						};
						this.swfRequest.send( '' );
					} else {
						$.ajax( {
							url: href,
							dataType: "html",
							complete: function( res, status ) {
								// If successful, inject the HTML into all the matched elements
								that.wrap( ( status === "success" || status === "notmodified" ) ? res.responseText : null, this.id );
							}
						} );
					}
				}
			}
		} else if( href == "" ) {
			if( this.anchor != newAnchor ) {
				this.anchor = newAnchor;
				if( this.onLoadStart ) this.onLoadStart();
				this.scrollToAnchor();
			}
		} else {
			return true;
		} 
		return false;
	},
	changeHref: function( href ) {
		if ( /^#/.test( href ) ) {
			return this.href + href;
		} else if( ! (/^\w*:\/\//).test( href ) ) {
			return removeBackRefs( this.href + "/../" + href );
		}
	},
	location: function() {
		return this.anchor ? this.href + '#' + this.anchor : this.href;
	},
	wrap: function( content ) {
		if( this.currentContent ) {
			this.currentContent.remove();
		}
		
		var rscript = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;
		
		if( content ) {
			var tempContent = $("<div/>").append( content.replace(rscript, "") );
			this.currentContent = tempContent.find( this.id ).appendTo( this.container );
			this.currentTitle = tempContent.find( "title" ).text();
		}
		this.markPage();
	}
};