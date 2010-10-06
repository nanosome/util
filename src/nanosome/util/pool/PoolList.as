// @license@
package nanosome.util.pool {
	import nanosome.util.EveryNowAndThen;

	import flash.utils.Dictionary;

	/**
	 * <code>PoolList</code> is a util to work with object pools for any kind 
	 * of instances. The only instance used is <code>pool</code>.
	 * 
	 * <p>Object pools are used to keep instances in memory even if not used
	 * anymore.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see nanosome.util.pool.pool
	 */
	public class PoolList {
		
		// Max amount of objects cleaned per run, used to not affect
		// The framerate by too many objects cleaned which would seriously trigger
		// the garbage collection.
		private const _objectsCleanedPerRun: int = 100;
		
		// Pools that need to be cleaned on next run
		private var _pools: Array /* IInstancePool */;
		
		// Map of entries to speed up the lookup.
		private var _poolMap: Object /* UID -> Boolean */;
		
		// Pools for classe-instance-pools that are created.
		private var _classPoolMap: Dictionary /* Class -> InstancePool */ = new Dictionary();
		
		/**
		 * Creates the initial <code>PoolList</code> used in the <code>pool</code>
		 * instance.
		 * 
		 * @param objectsCleanedPerRun Amount of objects (max.) cleaned per run 
		 * @param runEach Time distance in milliseconds between each run
		 */
		public function PoolList() {}
		
		/**
		 * Adds a instance pool to be sequentially cleaned on the next runs.
		 * 
		 * @param pool Pool that should be cleaned. 
		 * @return <code>true</code> if the pool was successfully added.
		 */
		public function add( pool: IInstancePool ): Boolean {
			if( !_pools ) {
				// Create the pools list if not already created.
				_pools = [ pool ];
				_poolMap = {};
				_poolMap[ pool.uid ] = true;
				EveryNowAndThen.add( clean );
				return true;
			}
			if( !_poolMap[ pool.uid ] ) {
				_poolMap[ pool.uid ] = true;
				_pools[ _pools.length ] = pool;
				return true;
			}
			return false;
		}
		
		/**
		 * Removes a added pool from the list of to be added pools.
		 * 
		 * @param pool Pool that should be removed from beeing cleaned
		 * @return <code>true</code> if the pool was successfully removed
		 */
		public function remove( pool: IInstancePool ): Boolean {
			if( _pools && _poolMap[ pool.uid ] ) {
				// Use of .indexOf since the index of a pool might change often.
				_pools.splice( _pools.indexOf( pool ), 1 );
				if( _pools.length == 0 ) {
					_pools = null;
					_poolMap = null;
				} else {
					delete _poolMap[ pool.uid ];
				}
				return true;
			}
			return false;
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
		
		/**
		 * Cleans out the added pools.
		 */
		private function clean(): void {
			if( _pools ) {
				var i: int = _objectsCleanedPerRun;
				var j: int = _pools.length;
				
				// Iterate backwards ensure that .remove doesn't break the
				// iteration.
				while( --j-(-1) && i > 0  ) {
					i = IInstancePool( _pools[ j ] ).clean( i );
				}
				
				if( !_pools ) {
					EveryNowAndThen.remove( clean );
				}
			}
		}
	}
}
