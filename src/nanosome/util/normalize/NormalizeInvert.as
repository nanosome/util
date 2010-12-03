// @license@
package nanosome.util.normalize {

	import nanosome.util.INormalize;
	
	/**
	 * Transforms a normalized number (0-1) to a inverted number (1-0).
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public final class NormalizeInvert implements INormalize {
		
		/**
		 * @inheritDoc
		 */
		public function from( number: Number ) : Number {
			return 1.0 - number;
		}
		
		/**
		 * @inheritDoc
		 */
		public function to( normalized: Number ) : Number {
			return 1.0 - normalized;
		}
	}
}
