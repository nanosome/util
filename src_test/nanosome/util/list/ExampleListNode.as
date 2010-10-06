package nanosome.util.list {

	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class ExampleListNode extends ListNode {
		
		internal var _content: *;
		internal var _next: ExampleListNode;
		
		override public function set strong( content: * ): void {
			_content = content;
		}
		
		override public function get strong() : * {
			return _content;
		}
		
		override public function set next( node: ListNode ): void {
			_next = ExampleListNode( node );
			super.next = node;
		}
	}
}
