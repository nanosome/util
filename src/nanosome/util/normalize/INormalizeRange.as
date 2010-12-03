package nanosome.util.normalize {
	import nanosome.util.INormalize;
	
	/**
	 * <code>INormalizeRange</code> defines an algorithm to transfer a normalized
	 * number (0-1) to number within a range.
	 * 
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public interface INormalizeRange extends INormalize {
		
		/**
		 * Minimum value for the range, return when passing 0.0 to <code>to()</code>
		 * 
		 * <p>The minimum value does not necessarily need to be smaller than the
		 * maximum value.</p>
		 * 
		 * @return minimum value of the range
		 */
		function get min(): Number;
		
		/**
		 * Maximum value for the range, return when passing 1.0 to <code>to()</code>
		 * 
		 * <p>The maximum value does not necessarily need to be bigger than the
		 * minimum value.</p>
		 * 
		 * @return maximum value of the range
		 */
		function get max(): Number;
	}
}
