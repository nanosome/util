// @license@
package nanosome.util.normalize {
	
	/**
	 * <code>NormalizeMappedRange</code> uses a normalized value (0-1) and transforms
	 * it to non-linear (based on passed-in mechanism) to a (&lt;min&gt;-&lt;max&gt;)
	 * range.
	 * 
	 * <p>Opposed to a regular <code>NormalizeRange</code> which just maps linear,
	 * this mapping allows to use a <code>INormalizeMap</code> to define the function
	 * used to map between <code>0.0</code> and <code>1.0</code>.</p>
	 * 
	 * @author Martin Heidegger
	 * @version 1.0
	 * @see NormalizeRange
	 */
	public final class NormalizeMappedRange implements INormalizeRange {
		
		private var _min: Number;
		private var _max: Number;
		private var _map: INormalizeMap;
		private var _diff: Number;
		
		/**
		 * Constructs a new <code>NormalizeMappedRange</code>
		 */
		public function NormalizeMappedRange( min: Number, max: Number, map: INormalizeMap ) {
			_min = min;
			_max = max;
			_map = map;
			_diff = _max-_min;
		}
		
		/**
		 * @inheritDoc
		 */
		public function from( number: Number ): Number {
			return _map.from( ( number - _min ) / _diff );
		}
		
		/**
		 * @inheritDoc
		 */
		public function to( normalized: Number ): Number {
			return _map.to( normalized ) * _diff + _min;
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
