package nanosome.util.normalize {
	import nanosome.util.IDoubleNormalize;
	/**
 * @author Martin Heidegger mh@leichtgewicht.at
 */
	public final class NormalizeCosinus implements IDoubleNormalize {
		
		public function NormalizeCosinus() {
			super();
		}
		
		public function from( number: Number ): Number {
			return Math.acos( number );
		}
		
		public function to( normalized: Number ): Number {
			return Math.cos( normalized );
		}
	}
}
