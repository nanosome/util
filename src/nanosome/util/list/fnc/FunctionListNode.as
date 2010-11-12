// @license@
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
