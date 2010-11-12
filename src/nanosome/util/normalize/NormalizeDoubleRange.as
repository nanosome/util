package nanosome.util.normalize {

	import nanosome.util.IDoubleNormalize;
	/**
 * @author Martin Heidegger mh@leichtgewicht.at
 */
	public final class NormalizeDoubleRange implements IDoubleNormalize {
		
		private var _from: Number;
		private var _to: Number;
		private var _diff: Number;
		
		public function NormalizeDoubleRange( from: Number, to: Number ) {
			super();
			_from = from;
			_to = to;
			_diff = _to-_from;
		}
		
		public function from( number: Number ): Number {
			number = ( number - _from ) / _diff;
			if( number < .0 ) {
				return .0;
			} else if( number > 1.0 ) {
				return 1.0;
			} else {
				return number;
			}
		}
		
		public function to( normalized: Number ): Number {
			return normalized * _diff + _from;
		}
	}
}
