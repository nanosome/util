package nanosome.util.normalize {
	
	import nanosome.util.normalize.NormalizeDoubleRange;
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function range( from: Number, to: Number ): NormalizeDoubleRange {
		return new NormalizeDoubleRange( from, to );
	}
	
}
