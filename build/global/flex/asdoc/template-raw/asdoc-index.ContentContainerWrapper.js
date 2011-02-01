var ContentContainerWrapper = function( loc ) {
	var that = this;
	this.noFramesLink			= $( '<a>'+term( 'NoFrames' )+'</a>' );
	this.verticalSlice			= $( "#vertical-slice" ).draggable( { containment: "#frameConstraint", axis: "x", drag: $.proxy( this, 'sliceVertical' ) } );
	this.horizontalSlice		= $( "#horizontal-slice" ).draggable( { containment: "#frameConstraint", axis: "y", drag: $.proxy( this, 'sliceHorizontal' ) } );
	
	this.contentFrame			= $( "#contentFrame" );
	this.contentFrameHandler	= new RequestHandler( loc, this.contentFrame );
	this.contentFrameHandler.prepareContent = $.proxy( this, 'modify' );
	
	this.indexFrame				= $( "#indexFrame" );
	this.indexFrameHandler		= new RequestHandler( loc, this.indexFrame, this.contentFrameHandler );
	
	this.packageFrame			= $( "#packagesFrame" );
	this.packageFrameHandler	= new RequestHandler( loc, this.packageFrame, this.contentFrameHandler );
	
	this.hashHandler			= new HashLocationHandler( this.contentFrameHandler, "package-summary.html", $.proxy( this, "updateNoFramesLink" ), "#body" );
	this.contentFrameHandler.onLoadStart = $.proxy( this.hashHandler, 'update' );
	this.packageFrameHandler.request( "package-list.html", "#body" );
}
ContentContainerWrapper.prototype = {
	updateNoFramesLink: function () {
		this.noFramesLink.attr( "href", this.contentFrameHandler.location() );
	},
	modify: function() {
		this.contentFrame.asdocify();
		
		$( "#titleNav", this.contentFrame ).append( this.noFramesLink );
		
		this.updateNoFramesLink();
		this.sliceVertical();
		this.sliceHorizontal();
		
		var href = $( "#fileInformation", this.contentFrame ).attr("href");
		if( href ) {
			this.indexFrameHandler.request( href, "#body" );
		}
		document.title = this.contentFrameHandler.currentTitle;
	},
	sliceVertical: function( e, ui ) {
		var left = ui ? ui.position.left : this.verticalSlice.offset().left;
		this.contentFrame.css( "left", left+5 );
		this.packageFrame.css( "width", left );
		this.horizontalSlice.css( "width", left );
		this.indexFrame.css( "width", left );
	},
	sliceHorizontal: function( e, ui ) {
		var top = ui ? ui.position.top : this.horizontalSlice[0].offsetTop;
		this.packageFrame.css("height", top-80 );
		this.indexFrame.css("top", top+5 );
	}
};