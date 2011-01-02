(function( $ ) {
	$.fn.zebra = function( selector ) {
		this.each(
			function() {
				var even = false;
				$( selector, this ).each( function() {
					$( this ).addClass( (even = !even) ? "row0" : "row1" );
				} );
			}
		);
		return this;
	}
})(jQuery);