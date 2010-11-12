// @license@
package nanosome.util.list {
	
	import nanosome.util.IUID;
	import nanosome.util.pool.ARRAY_POOL;
	import nanosome.util.pool.IInstancePool;
	
	/**
	 * <code>UIDList</code> is a implementation of the same concept as in <code>List</code>
	 * for <code>IUID</code> instances to reduce memory load.
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see List
	 * @see UIDListNode
	 * @see nanosome.bind.IUID
	 */
	public class UIDList extends AbstractList {
		
		// Last entry in the list, required for proper add/remove
		private var _last: UIDListNode;
		
		// Pool that is used to create list nodes
		private var _nodePool: IInstancePool;
		
		// Registry that holds the nodes to each entry in the pool, for faster add/remove
		private var _registry: Object;
		
		// Amount of entries in the linkedList (iteratable) part of the list
		private var _size: uint = 0;
		
		// Stack for every level of iteration, holds the next content, in order
		// to not mix up anything
		private var _nextStack: Array;
		
		// The size of weak entries in the list
		private var _weakSize: uint = 0;
		
		/**
		 * Creates a new <code>UIDList</code>
		 * 
		 * @param nodePool Pool to be used in the list to create new nodes
		 * @see nanosome.bind.pool.pool
		 */
		public function UIDList( nodePool: IInstancePool ) {
			super();
			_nodePool = nodePool;
		}
		
		/**
		 * Adds a new <code>value</code> to the list
		 * 
		 * <p>When adding something as <code>weak</code> that was added before, it
		 * will return <code>true</code> as a sign that the weak status changed.</p>
		 * 
		 * <p>It is not possible to add null or undefined.</p>
		 * 
		 * @param value Value to be added
		 * @param weak <code>true</code> to let the value be added as weak reference
		 * @return <code>true</code> if there has been a change in the list
		 */
		public function add( value: IUID, weak: Boolean = false ): Boolean {
			// Parent's function that will check if some iteration is ongoing
			return safeAdd( value, weak );
		}
		
		/**
		 * Removes a <code>value</code> from the list
		 * 
		 * @param value Value that should be removed from the list
		 * @return <code>true</code> if there has been a change in the list
		 */
		public function remove( value: IUID ): Boolean {
			if( removeFromLinkedList( value ) || removeInternal( value ) ) {
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * Finds out if <code>value</code> has been added to the list or not.
		 * 
		 * @param value <code>value</code> that should have been added
		 * @return <code>true</code> if the value has been added before
		 */
		public function contains( value: IUID ): Boolean {
			return ( _registry && _registry[ value.uid ] )
				|| containsInQueue( value );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get empty(): Boolean {
			if( _registry ) {
				return false;
			}
			return super.empty;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get size(): uint {
			return super.size + _size;
		}
		
		override public function get containsNonWeak(): Boolean {
			return _registry != null;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function addToLinkedList( content: *, weak: Boolean ): Boolean {
			// Create a registry, that is useful to save some perfromance/memory
			// when dealing with empty lists
			var uidContent: IUID = IUID( content );
			if( !_registry ) {
				_registry = {};
			}
			var node: UIDListNode = _registry[ uidContent.uid ];
			if( !node ) {
				// Only add the node if it wasn't added before
				node = UIDListNode( _nodePool.getOrCreate() );
				node.contentUID = uidContent.uid;
				
				// Save the content of the value
				node.content = uidContent;
				
				// Store isWeak to easier identify the node, will manipulate the storage of the value
				node.isWeak = weak;
				if( weak ) {
					++_weakSize;
				}
				
				_registry[ uidContent.uid ] = node;
				
				if( !first ) {
					first = node;
				} else {
					_last.next = node;
					node.prev = _last;
				}
				
				// Add the node to the list of iteration, in case somethings
				// coming up
				if( !next ) {
					next = node;
				}
				
				// Do same for the whole iteration stack
				if( _nextStack ) {
					var i: int = _nextStack.length;
					while( --i > -1 ) {
						if( !_nextStack[ i ] ) {
							_nextStack[ i ] = node;
						}
					}
				}
				
				_last = node;
				++_size;
				return true;
			} else {
				// If it was added before, check if the weak status changed
				// from before
				if( node.isWeak != weak) {
					node.isWeak = weak;
					if( weak ) {
						++_weakSize;
					} else {
						--_weakSize;
					}
					return true;
				} else {
					return false;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function containsInRegistry( content: * ): Boolean {
			return _registry && _registry[ IUID( content ).uid ] ;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function removeFromLinkedList( content: * ): Boolean {
			var uid: IUID = content;
			if( _registry && _registry[ uid.uid ] ) {
				// Remove the node only from linked list if it was really added
				removeNode( _registry[ uid.uid ] );
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose(): void {
			
			// Remove all added nodes
			var node: UIDListNode = first;
			while( node ) {
				var nextNode: UIDListNode = node.next;
				_nodePool.returnInstance( node );
				node = nextNode;
			}
			
			// Clear the registry
			_registry = null;
			
			// Remove the stack
			if( _nextStack ) {
				while( _nextStack.length > 0 ) {
					_nextStack.pop();
				}
				ARRAY_POOL.returnInstance( _nextStack );
				_nextStack = null;
			}
			
			_weakSize = 0;
			_size = 0;
			
			super.dispose();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function startIterate(): int {
			var iter: int = super.startIterate();
			if( iter == 1 ) {
				// Just create a stack if the iteration depth is bigger 0!
				_nextStack = ARRAY_POOL.getOrCreate();
			}
			// Add the current value of next and preserve it to resume the former iteratio
			if( _nextStack ) {
				_nextStack.push( next );
			}
			return iter;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function stopIterate() : void {
			super.stopIterate();
			if( _nextStack ) {
				if( _nextStack.length > 0 ) {
					// Resume with the previous iteration ...
					next = _nextStack.pop();
				} else {
					// ... or clear the iteration stack
					ARRAY_POOL.returnInstance( _nextStack );
					_nextStack = null;
				}
			}
		}
		
		/**
		 * Removes on node from the list.
		 * 
		 * <p>This method is protected in order to allow some subclass to remove
		 * nodes to weak entries that are empty.</p>
		 * 
		 * @param node <code>ListNode</code> that should be removed from the list
		 */
		protected function removeNode( node: UIDListNode ): void {
			
			// Tell the previous to use the next, or else set the next as first
			if( node.prev ) node.prev.next = node.next;
			else if( (first = node.next) ) first.prev = null;
			
			// Tell the next to use the previous, or else set the previous as last
			if( node.next ) node.next.prev = node.prev;
			else if( (_last = node.prev) ) _last.next = null;
			
			// If the next node would be this node, replace next
			if( next == node )
				next = node.next;
			
			// Do same for the whole iteration stack
			if( _nextStack ) {
				var i: int = _nextStack.length;
				while( --i > -1 ) {
					if( _nextStack[ i ] == node ) {
						_nextStack[ i ] = node.next;
					}
				}
			}
			
			// Delete the node from the registry
			delete _registry[ node.contentUID ];
			
			// Reduce the size of the weak references
			if( node.isWeak ) {
				--_weakSize;
			}
			
			// Return the node the the nodepool
			_nodePool.returnInstance( node );
			
			// Reduce the whole linked size
			--_size;
			
			// Remove the _registry dictionary if unused.
			for( var any: * in _registry ) {
				any;
				return;
			}
			_registry = null;
			
		}
		
		override protected function isWeakRegistered( value: * ): Boolean {
			if( _registry ) {
				var node: UIDListNode = _registry[ IUID( value ).uid ];
				return node && node.isWeak;
			}
			return false;
		}
		
		/**
		 * Override this method to the list which the first entry should be.
		 * 
		 * @return <code>ListNode</code> that is the first entry of the list
		 */
		protected function get first(): UIDListNode {
			throw new Error( "Abstract method" );
		}
		
		/**
		 * Stores the passed-in <code>ListNode</code> as the first entry in the
		 * iteration.
		 * 
		 * @param node <code>ListNode</code> that should be first in iteration
		 */
		protected function set first( node: UIDListNode ): void{
			throw new Error( "Abstract method" );
		}
		
		/**
		 * Override this method to the list which the next entry should be.
		 * 
		 * @return <code>ListNode</code> that is the next entry of the list
		 */
		protected function get next(): UIDListNode {
			throw new Error( "Abstract method" );
		}
		
		/**
		 * Stores the passed-in <code>ListNode</code> as the next entry in the
		 * iteration.
		 * 
		 * @param node <code>ListNode</code> that should be next in iteration
		 */
		protected function set next( node: UIDListNode ): void{
			throw new Error( "Abstract method" );
		}
		
		/**
		 * Clears all weak entries that don't contain a value anymore
		 */
		protected function clearEmptyWeak(): void {
			var current: UIDListNode = first;
			while( current ) {
				var next: UIDListNode = current.next;
				if( current.isWeak && current.weak == null ) {
					removeNode( current );
				}
				current = next;
			}
		}
	}
}
