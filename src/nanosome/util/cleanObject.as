package nanosome.util {
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function cleanObject( object: Object ): void {
		for( var property: String in object ) {
			delete object[ property ];
		}
	}
}
