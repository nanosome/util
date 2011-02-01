// @license@
package nanosome.util.normalize {
	
	/**
	 * Transforms a normalized number (0-1) to a linear range
	 * (&lt;min&gt;-&lt;max&gt;).
	 * 
	 * @example <listing version="3">
	 *    var map: NormalizeRange = range( -2, 64 );
	 *    map.to( 0.0 ); //  -2.0
	 *    map.to( 1.0 ); //  64.0
	 *    map.to( 0.5 ); //  31.0
	 *    map.to( 0.25 ); // 14.5
	 *    map.to( 0.75 ); // 47.5
	 * </listing>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see nanosome.util.normalize#range()
	 */
	public final class NormalizeRange implements INormalizeRange {
		
		// value for 0.0 point
		private var _min: Number;
		
		// value for 1.0 point
		private var _max: Number;
		
		// value for the linear difference between <code>_min</code> and <code>_max</code> 
		private var _diff: Number;
		
		/**
		 * Creates a new <code>NormalizeRange</code> range that maps
		 * a normalized number from 0.0 to 1.0 to a number within the passed-in range.
		 * 
		 * @param min value representing the 0.0 point
		 * @param max value for the 1.0 point
		 */
		public function NormalizeRange( min: Number, max: Number ) {
			super();
			_min = min;
			_max = max;
			_diff = _max-_min;
		}
		
		/**
		 * @inheritDoc
		 */
		public function from( number: Number ): Number {
			return ( number - _min ) / _diff;
		}
		
		/**
		 * @inheritDoc
		 */
		public function to( normalized: Number ): Number {
			return normalized * _diff + _min;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get min(): Number {
			return _min; 
		}
		
		/**
		 * @inheritDoc
		 */
		public function get max(): Number {
			return _max; 
		}
	}
}
