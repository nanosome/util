// @license@
package nanosome.util.list {
	import nanosome.util.IDisposable;
	import nanosome.util.IUID;

	import flash.utils.Dictionary;

	/**
	 * <code>UIDListNode</code> is to <code>UIDList</code> the same as <code>ListNode</code>
	 * to <code>List</code>.
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see List
	 * @see ListNode
	 */
	public class UIDListNode implements IDisposable {
		
		private var _next: UIDListNode;
		private var _weak: Dictionary;
		private var _isWeak: Boolean;
		private var _strong: IUID;
		
		public var contentUID: uint;
		
		public function UIDListNode() {
			super();
		}
		
		public function set next( node: UIDListNode ): void {
			_next = node;
		}
		
		public function get next(): UIDListNode {
			return _next;
		}
		
		public function set content( content: IUID ): void {
			strong = content;
			_isWeak = false;
		}
		
		public function set strong( content: IUID ): void {
			_strong = content;
		}
		
		public function get strong(): IUID {
			return _strong;
		}
		
		public function get isWeak(): Boolean {
			return _isWeak;
		}
		
		public function set isWeak( isWeak: Boolean ): void {
			if( _isWeak != isWeak ) {
				_isWeak = isWeak;
				if( isWeak ) {
					weak = strong;
					strong = null;
				} else {
					strong = weak;
					clearWeak();
				}
			}
		}
		
		public function set weak( content: * ): void {
			_weak = new Dictionary();
			_weak[ content ] = true;
		}
		
		public function get weak(): * {
			for( var content: * in _weak ) {
				return content;
			}
			clearWeak();
			return null;
		}
		
		private function clearWeak(): void {
			_weak = null;
			_isWeak = false;
		}
		
		public function dispose(): void {
			_weak = null;
			_isWeak = false;
			contentUID = 0;
			strong = null;
			next = null;
			prev = null;
		}
		
		public var prev: UIDListNode;
	}
}
