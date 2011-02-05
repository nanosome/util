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
	
	/**
	 * <code>ISetterProxy</code> is a definition for classes that allow the
	 * setting of its properties by using methods. This interface is respected by
	 * <code>Accessor</code> and subsequently by the <code>connect</code>
	 * functionality.
	 * 
	 * <p>This ist the counterpart to <code>IGetterProxy</code>.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see IGetterProxy
	 * @see Accessor
	 */
	public interface ISetterProxy {
		
		/**
		 * Sets one property of the instance.
		 * 
		 * @param name Name of the property.
		 * @param value Value that the property should get
		 * @return <code>true</code> if the property was accepted properly
		 */
		function write( name: String, value: * ): Boolean;

		function remove( property: String ): Boolean;
	}
}
