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
package nanosome.util.access {
	
	import nanosome.util.IDisposable;
	import nanosome.util.cleanObject;
	import nanosome.util.pool.IInstancePool;
	import nanosome.util.pool.OBJECT_POOL;
	import nanosome.util.pool.poolFor;
	
	/**
	 * 
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public class Changes implements IDisposable {
		
		/**
		 * 
		 */
		public static const POOL: IInstancePool = poolFor( Changes );
		
		/**
		 * Map of old values before the change.
		 */
		public const oldValues: Object /* String -> Object */ = OBJECT_POOL.getOrCreate();
		
		
		/**
		 * Map of new values after the change.
		 */
		public const newValues: Object /* String -> Object */ = OBJECT_POOL.getOrCreate();
		
		public function Changes() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose(): void {
			cleanObject( oldValues );
			OBJECT_POOL.returnInstance( oldValues );
			cleanObject( newValues );
			OBJECT_POOL.returnInstance( newValues );
		}
	}
}