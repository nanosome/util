//  
// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License. 
// 
package nanosome.util.pool {
	
	import nanosome.util.EveryNowAndThen;
	
	/**
	 * <code>PoolCleaner</code> is a util which <code>InstancePool</code> uses
	 * to clean itself.
	 * 
	 * <p>In order to prevent that too many instances get cleared at a time, all
	 * pools are cleared together, which allows a instance exceeding check for
	 * whether too many have been cleared or not.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public class PoolCleaner {
		
		// Max amount of objects cleaned per run, used to not affect
		// The framerate by too many objects cleaned which would seriously trigger
		// the garbage collection.
		private const _objectsCleanedPerRun: int = 100;
		
		// Pools that need to be cleaned on next run
		private var _pools: Array /* IInstancePool */;
		
		// Map of entries to speed up the lookup.
		private var _poolMap: Object /* UID -> Boolean */;
		
		/**
		 * Creates the initial <code>PoolList</code> used in the <code>pool</code>
		 * instance.
		 */
		public function PoolCleaner() {
			super();
		}
		
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
