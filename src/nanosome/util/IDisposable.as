// @license@
package nanosome.util {
	
	/**
	 * A instance of <code>IDisposable</code> signs that the instances is
	 * creating circular references that have to be resolved in order to have
	 * the instance properly removed from memory.
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public interface IDisposable {
		
		/**
		 * Disposes the instance, releases all eventually
		 * created circular references.
		 */
		function dispose(): void;
	}
}
