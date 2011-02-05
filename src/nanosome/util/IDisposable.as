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
