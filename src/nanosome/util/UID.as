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
	 * <code>UID</code> util to provide across a application a unique id.
	 * 
	 * <p>Its recommended to use this class for any implementation of <code>IUID</code>.
	 * You can eigther extend this class, or use the static <code>next()</code>
	 * method to retreive a new id.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see nanosome.util.IUID
	 */
	public class UID implements IUID {
		
		// Internal holder for a id
		private static var ID: uint = 0;
		
		/**
		 * Creates a new unique identifier.
		 * 
		 * @return new id to be used.
		 */
		public static function next(): uint {
			return ++ID;
		}
		
		// Id associated with this instance.
		private const _id: uint = UID.next();
		
		public function UID() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get uid(): uint {
			return _id;
		}
	}
}
