package nanosome.util.normalize {
	import nanosome.util.IDoubleNormalize;
	/**
 * @author Martin Heidegger mh@leichtgewicht.at
 */
	public final class NormalizeSteps implements IDoubleNormalize {
		
		private var _amountSteps: uint;
		
		public function NormalizeSteps( amountSteps: uint ) {
			super();
			_amountSteps = amountSteps;
		}
		
		public function from( number: Number ) : Number {
			return 0;
		}
		
		public function to( normalized: Number ) : Number {
			return 0;
		}
	}
}
