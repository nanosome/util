// @license@
package nanosome.util {
	
	/**
	 * A  <code>IDisposable</code> can be reset in its initial state.
	 * 
	 * <p>In order to avoid memory leaks, open connections, outdated background
	 * operations or alike, this interface provides a method that clears all references
	 * resets what should be initial state and closes all connections.</p>
	 * 
	 * <p>Using this interface is important if you want to object pooling. It is
	 * also recommended to use it in general to avoid memory leaks.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see nanosome.util.pool.IInstancePool
	 */
	public interface IDisposable {
		
		/**
		 * Disposes the instance.
		 * 
		 * <p>Will reset the instance back to a clean state. Release all references
		 * (circular or not), closes all open tasks, removes itself from all possible
		 * even listening, etc.</p>
		 */
		function dispose(): void;
	}
}
