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
	 * <code>IUID</code> is a util to reduce memory in maps.
	 * 
	 * <p>Mapping objects in a dictionary takes almost twice as much memory than
	 * mapping objects with <code>int</code> or <code>uint</code> values.</p>
	 * 
	 * <p>The integer values of the object has to stay the same and intact even
	 * after possible <code>dispose</code> calls.</p>
	 * 
	 * <p>Another advantage of <code>uint</code> mapping is that all mappings are
	 * automatically weak.</p>
	 * 
	 * <p>Right now this allows that during a flash instance 4294967295 different
	 * <code>IUID</code> instances exists in parallel. Assuming every second 100
	 * instances are created it will still take 15 months until duplicates might
	 * exist. For many application cases this is a sufficient amount.</p>
	 * 
	 * <p>To ensure that two instances don't have the same id, the class <code>UID</code>
	 * serves a unique value.</p>
	 * 
	 * @example Example for the use of <code>UID</code>
	 * <listing version="3.0">
	 *   var obj: UID = new UID();
	 * 
	 *   var map: Object = {};
	 *   map[ obj.uid ] = "mapvalue";
	 * 
	 *   // this version more memory intense
	 *   var map2: Dictionary = new Dictionary();
	 *   map2[ obj ] = "mapvalue";
	 * </listing>
	 * 
	 * @see nanosome.util.UID
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public interface IUID {
		
		/**
		 * Unique Identifier that stays the same
		 */
		function get uid(): uint;
	}
}