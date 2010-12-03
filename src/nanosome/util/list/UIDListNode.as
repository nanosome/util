// @license@
package nanosome.util.list {
	import nanosome.util.IDisposable;
	import nanosome.util.IUID;
	import nanosome.util.pool.WeakDictionary;
	
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
		
		/**
		 * @copy nanosome.util.list.ListNode#prev()
		 */
		public var prev: UIDListNode;
		
		/**
		 * <code>ID</code> of the content node
		 * 
		 * @see nanosome.util.IUID
		 */
		public var contentUID: uint;
		
		// Next node to be stored in the common format
		private var _next: UIDListNode;
		
		// Container for if the content was added weak
		private var _weak: WeakDictionary;
		
		// Content if added non-weak
		private var _strong: IUID;
		
		// Boolean to tell whether the content was added weak or not
		private var _isWeak: Boolean;
		
		/**
		 * Construcst a new <code>UIDListNode</code> instance.
		 */
		public function UIDListNode() {
			super();
		}
		
		/**
		 * @copy nanosme.util.list.ListNode#next()
		 */
		public function get next(): UIDListNode {
			return _next;
		}
		
		public function set next( node: UIDListNode ): void {
			_next = node;
		}
		
		
		/**
		 * @copy nanosme.util.list.ListNode#content()
		 */
		public function set content( content: IUID ): void {
			strong = content;
			_isWeak = false;
		}
		
		/**
		 * @copy nanosme.util.list.ListNode#strong()
		 */
		public function get strong(): IUID {
			return _strong;
		}
		
		public function set strong( content: IUID ): void {
			_strong = content;
		}
		
		/**
		 * @copy nanosme.util.list.ListNode#isWeak()
		 */
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
		
		/**
		 * @copy nanosme.util.list.ListNode#weak()
		 */
		public function get weak(): * {
			for( var content: * in _weak ) {
				return content;
			}
			clearWeak();
			return null;
		}
		
		public function set weak( content: * ): void {
			if( _weak ) {
				_weak.dispose();
			} else {
				_weak = WeakDictionary.POOL.getOrCreate();
			}
			_weak[ content ] = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose(): void {
			_weak = null;
			_isWeak = false;
			contentUID = 0;
			strong = null;
			next = null;
			prev = null;
		}
		
		private function clearWeak(): void {
			_weak = null;
			_isWeak = false;
		}
	}
}
