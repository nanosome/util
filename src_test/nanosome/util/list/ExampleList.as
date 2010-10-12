package nanosome.util.list {
	
	
	import nanosome.util.pool.pools;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class ExampleList extends List {
		
		private var _first: ExampleListNode;
		private var _next: ExampleListNode;
		
		public function ExampleList() {
			super( pools.getOrCreate( ExampleListNode ) );
		}

		public function iterate(): * {
			startIterate();
			if( !_next ) {
				stopIterate();
				_next = _first;
				return null;
			}
			if( !_next ) {
				stopIterate();
				return null;
			}
			var content: * = _next._content;
			_next = _next._next;
			stopIterate();
			return content;
		}
		
		public function pseudoIterate(): void {
			startIterate();
		}
		
		public function pseudoStopIterate(): void {
			stopIterate();
		}
		
		public function get allWeak(): Array {
			startIterate();
			var all: Array = [];
			var current: ExampleListNode = _first;
			while( current ) {
				if( current.isWeak ) {
					all.push( current.weak );
				}
				current = current._next;
			}
			stopIterate();
			return all;
		}
		
		public function get allNormal(): Array {
			startIterate();
			var all: Array = [];
			var current: ExampleListNode = _first;
			while( current ) {
				if( !current.isWeak ) {
					all.push( current._content );
				}
				current = current._next;
			}
			stopIterate();
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
