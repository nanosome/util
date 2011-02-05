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
