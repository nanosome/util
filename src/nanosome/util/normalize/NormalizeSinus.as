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
package nanosome.util.normalize {

	
	/**
	 * Transforms a normalized number (0-1) to a number on a sinus function.
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public final class NormalizeSinus implements INormalizeMap {
		
		public function NormalizeSinus() {}
		
		// Local const for cos, for faster access
		private const asin: Function = Math.asin;
		
		// Local const for cos, for faster access
		private const sin: Function = Math.sin;
		
		/**
		 * @inheritDoc
		 */
		public function from( number: Number ): Number {
			return asin( number );
		}
		
		/**
		 * @inheritDoc
		 */
		public function to( normalized: Number): Number {
			return sin( normalized );
		}
	}
}
