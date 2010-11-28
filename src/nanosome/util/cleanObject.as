// @license@
package nanosome.util {
	
	/**
	 * Deletes all properties stored in a anonymous object.
	 * 
	 * <p>To reuse common objects (typically abused as maps) this util allows
	 * to clean objects of any contained values.</p>
	 * 
	 * @param object object to be cleaned
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see nanosome.util.IDisposable
	 */
	public function cleanObject( object: Object ): void {
		for( var property: String in object ) {
			delete object[ property ];
		}
	}
}
