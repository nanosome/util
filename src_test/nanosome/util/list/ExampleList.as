package nanosome.util.list {
	
	
	import nanosome.util.pool.POOL_STORAGE;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class ExampleList extends List {
		
		private var _first: ExampleListNode;
		private var _next: ExampleListNode;
		private var _firstLevel: Boolean;
		
		public function ExampleList() {
			super( POOL_STORAGE.getOrCreate( ExampleListNode ) );
		}

		public function iterate(): * {
			if( !_isIterating ) {
				_isIterating = true;
				_next = _first;
			}
			if( !_next ) {
				_isIterating = false;
				_next = null;
				stopIteration();
				return null;
			}
			var content: * = _next._content;
			_next = _next._next;
			return content;
		}
		
		public function pseudoIterate(): void {
			_firstLevel = _isIterating ? subIterate() : _isIterating = true;
		}
		
		public function pseudoStopIterate(): void {
			_firstLevel ? stopIteration() : stopSubIteration();
		}
		
		public function get allWeak(): Array {
			var first: Boolean = _isIterating ? subIterate() : _isIterating = true;
			var all: Array = [];
			var current: ExampleListNode = _first;
			while( current ) {
				if( current.isWeak ) {
					all.push( current.weak );
				}
				current = current._next;
			}
			first ? stopIteration() : stopSubIteration();
			return all;
		}
		
		public function get allNormal(): Array {
			var first: Boolean = _isIterating ? subIterate() : _isIterating = true;
			var all: Array = [];
			var current: ExampleListNode = _first;
			while( current ) {
				if( !current.isWeak ) {
					all.push( current._content );
				}
				current = current._next;
			}
			first ? stopIteration() : stopSubIteration();
			return all;
		}

		override protected function get first() : ListNode {
			return _first;
		}
		
		override protected function set first(node : ListNode) : void {
			_first = ExampleListNode( node );
		}
		
		override protected function get next() : ListNode {
			return _next;
		}
		
		override protected function set next( node : ListNode ): void {
			_next = ExampleListNode( node );
		}
	}
}
