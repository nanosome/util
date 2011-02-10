// @license@ 
package nanosome.util {
	
	/**
	 * <code>INormalize</code> standardize different approaches to transform a
	 * normalized number (0-1) to a defined value and back.
	 * 
	 * <p>This interface is important when you want to build mechanisms that don`t
	 * bother about conversions. Like Wheel-UI controls, algorithms and alike. With
	 * standardized interchange parameters its easy to wire various generic mechanisms.
	 * </p>
	 * 
	 * <p>If you build some application that should store internally a
	 * value between 0 and 1 but work with a different number like -255 to +256
	 * you can create a implementation of this interface that automatically
	 * transforms the normalized value.</p>
	 * 
	 * @example <listing version="3">
	 * class Double8BitNormalize implements INormalize {
	 *   public function to( normalized: Number ): Number {
	 *     // No &lt; 0 or &gt; 1 required, defined by interface that this is given.
	 *     return normalized * 512 - 255:
	 *   }
	 *   public function from( number: Number ): Number {
	 *     // Same here, interface definition important
	 *     return ( number + 255 ) / 512;
	 *   }
	 * }
	 * </listing>
	 *  
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public interface INormalize {
		
		/**
		 * Converts a number to a value from <code>0.0</code> to <code>1.0</code>.
		 * 
		 * <p>Implementations do not need to care whether the import is valid or
		 * not. The user of this interface has to verify if the output is normalized.
		 * </p> 
		 * 
		 * @param number Regular number that should be normalized by this mechanism
		 * @return normalized number from <code>0.0</code> to <code>1.0</code>
		 */
		function from( number: Number ): Number;
		
		/**
		 * Converts a normalized number (<code>0.0</code> to <code>1.0</code>)
		 * to a number of choice that can be mapped back to a normalized version.
		 * 
		 * <p>Implementations can be sure that the input is a number from 0 to 1.
		 * It is not necessary to reconfirm.</p>
		 * 
		 * @param normalized Number from 0.0 to 1.0
		 * @return Any number that can be mapped with this implementation to a
		 *         normalized number.
		 */
		function to( normalized: Number ): Number;
	}
}
