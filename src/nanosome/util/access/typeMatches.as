// @license@ 
package nanosome.util.access {
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function typeMatches( typeA: Class, typeB: Class ): Boolean {
		if( typeA == typeB ) {
			return true;
		} else {
			return (
				( typeA == int || typeA == String || typeA == uint || typeA == Number || typeA == Boolean )
				&&
				( typeB == int || typeB == String || typeB == uint || typeB == Number || typeB == Boolean )
			);
		}
	}
}
