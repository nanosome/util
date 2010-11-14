package nanosome.util.list {
	import nanosome.util.IUID;
	import nanosome.util.pool.POOL_LIST;
	
	

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class ExampleUIDList extends UIDList {
		
		private var _first: ExampleUIDListNode;
		private var _next: ExampleUIDListNode;
		
		public function ExampleUIDList() {
			super( POOL_LIST.getOrCreate( ExampleUIDListNode ) );
		}
		
		public function iterate(): IUID {
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
			var content: IUID = _next._content;
			stopIterate();
			_next = _next._next;
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
			var current: ExampleUIDListNode = _first;
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
			var current: ExampleUIDListNode = _first;
			while( current ) {
				if( !current.isWeak ) {
					all.push( current._content );
				}
				current = current._next;
			}
			stopIterate();
			return all;
		}
		
		override protected function get first(): UIDListNode {
			return _first;
		}
		
		override protected function set first( node: UIDListNode ): void {
			_first = ExampleUIDListNode( node );
		}
		
		override protected function get next(): UIDListNode {
			return _next;
		}
		
		override protected function set next( node: UIDListNode ): void {
			_next = ExampleUIDListNode( node );
		}
	}
}
