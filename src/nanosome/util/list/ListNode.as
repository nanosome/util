// @license@
package nanosome.util.list {
	import nanosome.util.IDisposable;
	import nanosome.util.UID;
	import nanosome.util.pool.WeakDictionary;
	
	/**
	 * <code>ListNode</code> is a abstract content node for any <code>List</code>
	 * implementation.
	 * 
	 * <p>In order to create your own custom lists, you have to extend this 
	 * ListNode.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see List
	 */
	public class ListNode extends UID implements IDisposable {
		
		/**
		 * Previous <code>node</code> in the list.
		 */
		public var prev: ListNode;
		
		// Next node to be stored in the common format
		private var _next: ListNode;
		
		// Container for if the content was added weak
		private var _weak: WeakDictionary;
		
		// Content if added non-weak
		private var _strong : *;
		
		// Boolean to tell whether its weak or not
		private var _isWeak: Boolean;
		
		/**
		 * Constructs a new <code>ListNode</code> instance.
		 */
		public function ListNode() {
			super();
		}
		
		/**
		 * Next <code>node</code> in the list.
		 */
		public function get next(): ListNode {
			return _next;
		}
		
		public function set next( node: ListNode ): void {
			_next = node;
		}		
		
		/**
		 * Content if the content has been added non-weak(strong).
		 */
		public function set content( content: * ): void {
			strong = content;
			_isWeak = false;
		}
		
		/**
		 * Content if the content has been added non-weak(strong).
		 */
		public function set strong( content: * ): void {
			_strong = content;
		}
		
		public function get strong(): * {
			return _strong;
		}
		
		/**
		 * <code>true</code> if the content of this <code>ListNode</code> has been
		 * added weak.
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
		 * Content if the content has been added weak.
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
			strong = null;
			next = null;
			prev = null;
		}
		
		/**
		 * Clears the weak storage
		 */
		private function clearWeak(): void {
			WeakDictionary.POOL.returnInstance( _weak );
			_weak = null;
			_isWeak = false;
		}
		
	}
}
