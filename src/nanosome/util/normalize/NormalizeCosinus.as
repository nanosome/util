// @license@ 
package nanosome.util.normalize {
	
	/**
	 * Transforms a normalized number (0-1) to a number on a cosinus function.
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public final class NormalizeCosinus implements INormalizeMap {
		
		public function NormalizeCosinus() {}
		
		// Local const for acos, for faster access
		private const acos: Function = Math.acos;
		
		// Local const for cos, for faster access
		private const cos: Function = Math.cos;
		
		/**
		 * @inheritDoc
		 */
		public function from( number: Number ): Number {
			return acos( number );
		}
		
		/**
		 * @inheritDoc
		 */
		public function to( normalized: Number ): Number {
			return cos( normalized );
		}
	}
}
