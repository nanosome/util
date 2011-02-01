// @license@
package nanosome.util.pool {
	import nanosome.util.IUID;
	
	
	/**
	 * A <code>IInstancePool</code> is a factory for objects and a container for
	 * unused objects.
	 * 
	 * <p><code>IInstancePool</code> instances can be used together with the <code>PoolList</code>
	 * stored in the public <code>pool</code> variable.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see PoolStorage
	 * @see PoolCleaner
	 * @see nanosome.util.pool#poolInstance()
	 * @see nanosome.util.pool#poolFor()
	 * @see http://en.wikipedia.org/wiki/Object_pool_pattern
	 */
	public interface IInstancePool extends IUID {
		
		/**
		 * Creates a instance or takes it from the list of unused instances.
		 * 
		 * <p>The instance created by the pool will not be destructed or stored
		 * by the pool. If not returned, nothing will happen to it.</p>
		 * 
		 * @param instance created by the pool.
		 */
		function getOrCreate(): *;
		
		/**
		 * Cleans the passed-in instance from all instance specific data and 
		 * marks it as beeing able to be used again as fresh one.
		 * 
		 * @param instance instance to be returned.
		 */
		function returnInstance( instance: * ): void;
		
		/**
		 * Cleans out a defined amount of instances stored in this pool.
		 * 
		 * @param amount Amount of instances to be cleaned max
		 * @return Amount of instances that still can be cleaned 
		 */
		function clean( amount: int ): int;
	}
}
