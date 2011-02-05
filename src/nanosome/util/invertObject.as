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
	 * Creates a copy of the passed-in object that uses all values as keys and all keys as values.
	 * 
	 * <p>If you use objects as a fast, small map for primitive types. You might
	 * need to switch the keys and values occasionally. This util serves just that.</p>
	 * 
	 * <p>Since the content of anonymous objects can be anything this util will
	 * fail silently if you pass in a object that contains not-primitives.</p>
	 * 
	 * <p>The keys in the object that is passed-in are certainly unique. As values
	 * you can use whatever you want. By default, it will assume that each value
	 * is unique. In case you know they are not unique you can use the parameter
	 * <code>groupDuplicates</code>. It will group the values in arrays if more
	 * than one occurred.</p>
	 * 
	 * @param object object to be inverted
	 * @param groupDuplicates if <code>true</code> it will create arrays where one
	 *                        value existed more than once
	 * @return copy of the object with keys and values switched
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function invertObject( object: Object,
									groupDuplicates: Boolean = false ): Object {
		var result: Object = {};
		var key: *;
		var value: *;
		if( groupDuplicates ) {
			var grouped: Object = {};
			var group: Array;
			for( key in object ) {
				value = object[ key ];
				if( result[ value ] ) {
					if( ( group = grouped[ value ] as Array) ) {
						group.push( key );
					} else {
						grouped[ value ] = result[ value ] = [ key ];
					}
				} else {
					result[ value ] = key;
				}
			}
		} else {
			for( key in object ) {
				result[ object[ key ] ] = key;
			}
		}
		return result;
	}
}
