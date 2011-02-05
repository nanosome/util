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
package nanosome.util {
	import nanosome.util.pool.IInstancePool;
	import nanosome.util.pool.poolFor;
	
	
	/**
	 * <code>ChangedPropertyNode</code> is value object for the mass-event sent
	 * out by <code>IPropertyObservable.onManyPropertiesChanged</code>.
	 * 
	 * <p><strong>Important note:</strong> For performance reasons all properties
	 * in this class are public. Any implementation is <strong>strongly required</strong>
	 * to change <strong>no field whatsoever</strong>!</p>
	 * 
	 * <p>In essence its a stripped down list containing just linked nodes that
	 * can be iterated with a simple while loop.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public final class ChangedPropertyNode implements IDisposable {
		
		/**
		 * Pool that can be accessed to create and temporarily store instances
		 */
		public static const POOL: IInstancePool = poolFor( ChangedPropertyNode );
		
		/**
		 * The name of the property that changed
		 */
		public var name: String;
		
		/**
		 * The old value of that property
		 */
		public var oldValue: *;
		
		/**
		 * The new(current) value of that property.
		 */
		public var newValue: *;
		
		/**
		 * The next node in the list to be iterated.
		 */
		public var next: ChangedPropertyNode;
		
		/**
		 * The previous node in that list, not required for iteration
		 */
		public var prev: ChangedPropertyNode;
		
		public function ChangedPropertyNode() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose(): void {
			next = prev = oldValue = newValue = name = null;
		}
		
		/**
		 * Small util to build primitive lists.
		 * 
		 * @param formerNode Node which should be used as former node in the list
		 */
		public function addTo( formerNode: ChangedPropertyNode ): ChangedPropertyNode {
			if( formerNode ) {
				formerNode.next = this;
				prev = formerNode;
			}
			return this;
		}
		
		/**
		 * Returns this node to the pool and tells the next node to return itself
		 * as well.
		 */
		public function returnAll(): void {
			if( next ) {
				next.returnAll();
			}
			POOL.returnInstance( this );
		}
	}
}
