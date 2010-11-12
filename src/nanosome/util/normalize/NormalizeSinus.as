package nanosome.util.normalize {

	import nanosome.util.IDoubleNormalize;
	/**
 * @author Martin Heidegger mh@leichtgewicht.at
 */
	public final class NormalizeSinus implements IDoubleNormalize {
		
		public function from( number: Number ): Number {
			return Math.asin( number );
		}
		
		public function to( normalized: Number): Number {
			return Math.sin( normalized );
		}
	}
}
