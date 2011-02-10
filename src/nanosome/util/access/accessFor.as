// @license@ 
package nanosome.util.access {
	
	/**
	 * @copy Accessor#forObject()
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see Accessor
	 */
	public function accessFor( object: * ): Accessor {
		return Accessor.forObject( object );
	}
}
