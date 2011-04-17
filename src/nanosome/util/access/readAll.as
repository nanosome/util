package nanosome.util.access {
	
	/**
	 * Getter for all properties of an instance.
	 * 
	 * <p>The object returned may be optimized for frequent access. The instance
	 * may only be used for access purposes. <strong>Do not modify the returned
	 * object!</strong></p>
	 * 
	 * <p>If the instance implements <code>IGetterProxy</code> then <code>
	 * instance.getAll</code> will be utilized.</p>
	 * 
	 * @param instance Instance whose properties are requested
	 * 
	 * @param addDynamic <code>true</code> adds the dynamic fields too.
	 * @return <code>Object</code> that contains all the properties requested.
	 */
	
	public function readAll( instance: *, fields: Array = null,
							 addDynamic: Boolean = true, accessor: Accessor = null ): Object {
		if( !accessor ) accessor = accessFor( accessor );
		
		var i: int;
		var result: Object = {};
		
		if( fields ) {
			i = fields.length;
			while ( --i-(-1) ) {
				
				property = accessor.prop( fields[ i ] );
				try {
					result[ property.qName ] = property.reader.read( instance );
				} catch( e: Error ) {}
				
			}
		} else {
			var eventSending: Array = accessor.eventSendingReadableProperties;
			var property: PropertyAccess;
			if( eventSending ) {
				i = eventSending.length;
				
				while( --i-(-1) ) {
					property = eventSending[ i ];
					result[ property.qName.toString() ] = property.reader.read( instance );
				}
			}
			
			var regular: Array = accessor.nonEventSendingProperties;
			if( regular ) {
				i = regular.length;
				
				while( --i-(-1) ) {
					property = regular[ i ];
					result[ property.qName.toString() ] = property.reader.read( instance );
				}
			}
		}
		
		if( addDynamic && accessor.isDynamic ) {
			for( var name: String in instance ) {
				property = accessor.prop( name );
				result[ name ] = property.reader.read( instance );
			}
		}
		
		return result;
	}
}
