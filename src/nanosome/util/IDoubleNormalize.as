package nanosome.util {
	/**
 * @author Martin Heidegger mh@leichtgewicht.at
 */
	public interface IDoubleNormalize {
		function from( number: Number ): Number;
		function to( normalized: Number ): Number;
	}
}
