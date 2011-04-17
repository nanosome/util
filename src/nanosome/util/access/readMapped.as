package nanosome.util.access {
	import flash.utils.Dictionary;
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function readMapped( source: *, propertyMap: Dictionary, accessor: Accessor = null ): Object {
		if( !accessor ) {
			accessor = accessFor( source );
		}
		var result: Object = {};
		for( var s: * in propertyMap ) {
			var prop: PropertyAccess = s;
			if( prop ) {
				result[ PropertyAccess( propertyMap[ prop ] ).qName.toString() ] = prop.reader.read( source );
			}
		}
		return result;
	}
}
