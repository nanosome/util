// @license@ 
package nanosome.util {
	
	import flash.utils.Dictionary;
	
	/**
	 * Merges all entries from two arrays into a new one, containing each
	 * entry just once.
	 * 
	 * <p>In case you want to make sure that the entries in one or two arrays
	 * contain you can use this method.</p>
	 * 
	 * <p>It will always return a new array, no matter what you pass-in. The
	 * array is not sorted, meaning that it can optimize about ordering for
	 * better performanc.</p>
	 * 
	 * @return Unsorted <code>Array</code> containing all entries contained in
	 *   arrayA and arrayB.
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public function mergeArrays( arrayA: Array, arrayB: Array = null ): Array {
		if( !arrayA && !arrayB ) {
			// Simplification for the case if both arrays don't exist.
			return [];
		}
		else
		if( !arrayA ) {
			// If arrayA doesn't exist, arrayB exist, given former rule!
			arrayA = arrayB;
			arrayB = null;
		}
		
		// Store all entries in a temporary list, faster than 
		var added: Dictionary = new Dictionary();
		var result: Array = [];
		var l: int = 0;
		var obj: *;
		var i: int = arrayA.length;
		
		// Add all in the first array
		while( --i > -1 ) {
			obj = arrayA[i];
			if( !added[ obj ] ) {
				result[ l ] = obj;
				added[ obj ] = true;
				l++;
			}
		}
		
		// Second array might be empty (see above)
		if( arrayB ) {
			i = arrayB.length;
			
			// Add all of second array
			while( --i > -1 ) {
				obj = arrayB[i];
				if( !added[ obj ] ) {
					result[ l ] = obj;
					added[ obj ] = true;
					l++;
				}
			}
		}
		return result;
	}
}
