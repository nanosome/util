package nanosome.util.list {
	import nanosome.util.IUID;
	import nanosome.util.pool.POOL_STORAGE;
	
	

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class ExampleUIDList extends UIDList {
		
		private var _first: ExampleUIDListNode;
		private var _next: ExampleUIDListNode;
		private var _firstLevel: Boolean;
		
		public function ExampleUIDList() {
			super( POOL_STORAGE.getOrCreate( ExampleUIDListNode ) );
		}
		
		public function iterate(): IUID {
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
			var content: IUID = _next._content;
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
			var current: ExampleUIDListNode = _first;
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
			var first: Boolean = _isIterating ? subIterate() : _isIterating = true;;
			var all: Array = [];
			var current: ExampleUIDListNode = _first;
			while( current ) {
				if( !current.isWeak ) {
					all.push( current._content );
				}
				current = current._next;
			}
			first ? stopIteration() : stopSubIteration();
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
