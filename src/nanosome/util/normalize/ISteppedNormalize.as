// @license@ 
package nanosome.util.normalize {
	
	/**
	 * <code>ISteppedNormalize</code> defines a mapping that is broken apart in
	 * steps.
	 * 
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public interface ISteppedNormalize extends INormalizeMap {
		
		/**
		 * Steps at which this map will stop;
		 * 
		 * @return list of steps at which this mapping will stop
		 */
		function get steps(): Array;
	}
}
