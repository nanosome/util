package nanosome.util.list {
	import nanosome.util.IUID;
	

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class ExampleUIDListNode extends UIDListNode {
		
		internal var _content: IUID;
		internal var _next: ExampleUIDListNode;
		
		override public function set strong( content: IUID ): void {
			_content = content;
		}
		
		override public function get strong() : IUID {
			return _content;
		}
		
		override public function set next( node: UIDListNode ): void {
			_next = ExampleUIDListNode( node );
			super.next = node;
		}
	}
}
