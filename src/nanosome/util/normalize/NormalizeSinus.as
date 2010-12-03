// @license@
package nanosome.util.normalize {

	
	/**
	 * Transforms a normalized number (0-1) to a number on a sinus function.
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public final class NormalizeSinus implements INormalizeMap {
		
		public function NormalizeSinus() {}
		
		// Local const for cos, for faster access
		private const asin: Function = Math.asin;
		
		// Local const for cos, for faster access
		private const sin: Function = Math.sin;
		
		/**
		 * @inheritDoc
		 */
		public function from( number: Number ): Number {
			return asin( number );
		}
		
		/**
		 * @inheritDoc
		 */
		public function to( normalized: Number): Number {
			return sin( normalized );
		}
	}
}
