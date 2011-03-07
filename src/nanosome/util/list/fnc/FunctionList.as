// @license@ 
package nanosome.util.list.fnc {
	
	import nanosome.util.pool.poolFor;
	import nanosome.util.list.List;
	import nanosome.util.list.ListNode;
	
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
		
		// Template of a function to be called when the list is empty
		private var _onEmpty : Function;
		
		// Next in the list
		private var _next: FunctionListNode;
		
		/**
		 * Creates a new <code>FunctionList</code> instance
		 * 
		 * @param onEmpty Function to be called if the list is empty after iteration
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
			var first: Boolean = _isIterating ? subIterate() : _isIterating = true;
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
			first ? stopIteration() : stopSubIteration();
			if( empty && _onEmpty != null ) {
				_onEmpty();
			}
		}
		
		public function execute( ...args: Array ): void {
			var first: Boolean = _isIterating ? subIterate() : _isIterating = true;
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
			first ? stopIteration() : stopSubIteration();
			if( empty && _onEmpty != null ) {
				_onEmpty();
			}
		}
		
		public function executeAndReturn( ...args: Array ): Array {
			var first: Boolean = _isIterating ? subIterate() : _isIterating = true;
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
			first ? stopIteration() : stopSubIteration();
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
