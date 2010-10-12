package nanosome.util {
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function invertObject( object: Object ): Object {
		var result: Object = {};
		for( var name: String in object ) {
			result[ object[ name ] ] = name;
		}
		return result;
	}
}
