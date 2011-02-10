// @license@ 
package nanosome.util.pool {
	
	import flash.utils.Dictionary;
	
	/**
	 * <code>PoolStorage</code> is a storage for <code>IInstancePools</code> that
	 * stores once created Pools.
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see nanosome.util.pool#poolFor()
	 * @see nanosome.util.pool#poolInstance()
	 * @see nanosome.util.pool#returnInstance()
	 */
	public class PoolStorage {
		
		// Pools for classe-instance-pools that are created.
		private var _classPoolMap: Dictionary /* Class -> InstancePool */ = new Dictionary();
		
		public function PoolStorage() {
			super();
		}
		
		/**
		 * Creates a class-instance pool or returns a already created one based
		 * on the passed-in class.
		 * 
		 * @param clazz Class to construct instances
		 * @return <code>Pool</code> that creates instances of the given class
		 * @see nanosome.pool.InstancePool
		 */
		public function getOrCreate( clazz: Class ): InstancePool {
			return _classPoolMap[ clazz ] || ( _classPoolMap[ clazz ] = new InstancePool( clazz ) );
		}
	}
}
