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
package nanosome.util.list.fnc {
	
	import nanosome.util.list.ListNode;
	
	/**
	 * Nodes for <code>FunctionList<code>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	internal final class FunctionListNode extends ListNode {
		
		// Holder for the function to be executed
		internal var _strong: Function;
		
		// Holder for the node succeeding this one
		internal var _next: FunctionListNode;
		
		public function FunctionListNode() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set strong( content: * ): void {
			_strong = content;
		}
		
		override public function get strong() : * {
			// "as" to prevent compiler warning.
			return _strong as Function;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set next( node: ListNode ): void {
			_next = FunctionListNode( node );
			super.next = node;
		}
	}
}
