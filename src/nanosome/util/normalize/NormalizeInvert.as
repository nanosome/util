package nanosome.util.normalize {

	import nanosome.util.IDoubleNormalize;
	/**
 * @author Martin Heidegger mh@leichtgewicht.at
 */
	public final class NormalizeInvert implements IDoubleNormalize {
		
		public function from( number: Number ) : Number {
			number = 1.0 - number;
			if( number < .0 ) {
				return .0;
			} else if( number > 1.0 ) {
				return 1.0;
			} else {
				return number;
			}
		}
		
		public function to( normalized: Number ) : Number {
			return 1.0 - normalized ;
		}
	}
}
