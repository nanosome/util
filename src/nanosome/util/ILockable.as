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
	
	/**
	 * <code>ILockable</code> generalizes the case where instances have to update
	 * after each change. Doing many changes would result in a lot of events(code)
	 * that has to happen. Making a instance lockable might in certain cases reduce
	 * the operation time significantly.
	 * 
	 * <p>In a locked state the instance is adviced to not send out any updates
	 * and stock all the events in order to provide a constistant state.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public interface ILockable {
		
		/**
		 * Locks the instance, preventing it to send out events.
		 */
		function lock(): void;
		
		/**
		 * Unlocks the instance, letting it send all the yet to be sent out
		 * events.
		 */
		function unlock(): void;
		
		/**
		 * Tells whether or not the instances is currently locked.
		 * 
		 * @return <code>true</code> if the instance is locked, else <code>false</code>
		 */
		function get locked(): Boolean;
		
		/**
		 * Allows a different access to change the lock of a instance
		 * 
		 * @param <code>true</code> if no changes should be tracked.
		 */
		function set locked( locked: Boolean ): void;
	}
}
