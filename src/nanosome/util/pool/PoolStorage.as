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
