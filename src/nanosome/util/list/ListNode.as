// @license@
package nanosome.util.list {
	import nanosome.util.IDisposable;
	import nanosome.util.UID;
	import nanosome.util.pool.WeakDictionary;
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see List
	 */
	public class ListNode extends UID implements IDisposable {
		
		// Next node to be stored in the common format
		private var _next: ListNode;
		
		private var _weak: WeakDictionary;
		
		private var _strong : *;
		
		private var _isWeak : Boolean;
		
		public function set next( node: ListNode ): void {
			_next = node;
		}
		
		public function get next(): ListNode {
			return _next;
		}
		
		public function set content( content: * ): void {
			strong = content;
			_isWeak = false;
		}
		
		public function set strong( content: * ): void {
			_strong = content;
		}
		
		public function get strong(): * {
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
			if( _weak ) {
				_weak.dispose();
			} else {
				_weak = WeakDictionary.POOL.getOrCreate();
			}
			_weak[ content ] = true;
		}
		
		public function get weak(): * {
			for( var content: * in _weak ) {
				return content;
			}
			clearWeak();
			return null;
		}
		
		private function clearWeak() : void {
			WeakDictionary.POOL.returnInstance( _weak );
			_weak = null;
			_isWeak = false;
		}
		
		public function dispose(): void {
			_weak = null;
			_isWeak = false;
			strong = null;
			next = null;
			prev = null;
		}
		
		public var prev: ListNode;
	}
}
