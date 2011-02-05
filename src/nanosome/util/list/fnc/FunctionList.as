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
	import nanosome.util.list.List;
	import nanosome.util.list.ListNode;
	import nanosome.util.pool.poolFor;

	import flash.events.Event;
	
	
	/**
	 * List of functions to be executed in a row.
	 * 
	 * <p>This util allows to have a list of functions that can be executed in 
	 * a row.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public final class FunctionList extends List {
		
		// First node in the list to be executed
		private var _first: FunctionListNode;
		
		private var _onEmpty : Function;
		
		private var _next: FunctionListNode;
		
		/**
		 * Creates a new <code>FunctionList</code> instance
		 */
		public function FunctionList( onEmpty: Function = null ) {
			super( poolFor( FunctionListNode ) );
			_onEmpty = onEmpty;
		}
		
		/**
		 * Executes all functions in the list.
		 * 
		 * @param e Event that can be passed-in, will not be used
		 */
		public function executeStraight( ...args: Array ): void {
			startIterate();
			var current: FunctionListNode = _first;
			while( current ) {
				_next = current._next;
				
				var fnc: Function = current._strong;
				if( fnc != null ) {
					fnc();
				} else {
					fnc = current.weak;
					if( fnc != null ) {
						fnc();
					} else {
						removeNode( current );
					}
				}
				
				current = _next;
			}
			stopIterate();
			if( empty && _onEmpty != null ) {
				_onEmpty();
			}
		}
		
		public function execute( ...args: Array ): void {
			startIterate();
			var current: FunctionListNode = _first;
			while( current ) {
				_next = current._next;
				
				var fnc: Function = current._strong;
				if( fnc != null ) {
					fnc.apply( null, args );
				} else {
					fnc = current.weak;
					if( fnc != null ) {
						fnc.apply( null, args );
					} else {
						removeNode( current );
					}
				}
				current = _next;
			}
			stopIterate();
			if( empty && _onEmpty != null ) {
				_onEmpty();
			}
		}
		
		public function executeAndReturn( ...args: Array ): Array {
			startIterate();
			var current: FunctionListNode = _first;
			var result: Array = [];
			while( current ) {
				_next = current._next;
				
				var fnc: Function = current._strong;
				if( fnc != null ) {
					result.push( fnc.apply( null, args ) );
				} else {
					fnc = current.weak;
					if( fnc != null ) {
						result.push( fnc.apply( null, args ) );
					} else {
						removeNode( current );
					}
				}
				current = _next;
			}
			stopIterate();
			if( empty && _onEmpty != null ) {
				_onEmpty();
			}
			return result;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get first(): ListNode {
			return _first;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function set first( node: ListNode ): void {
			_first = FunctionListNode( node );
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get next(): ListNode {
			return _next;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function set next( node: ListNode ): void {
			_next = FunctionListNode( node );
		}
	}
}
