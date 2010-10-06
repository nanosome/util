// @license@
package nanosome.util.list {
	
	import nanosome.util.pool.WeakDictionary;
	import nanosome.util.pool.ARRAY_POOL;
	import nanosome.util.pool.IInstancePool;
	
	/**
	 * <code>List</code> is a abstract linked-list construct to improve code quality
	 * and performance.
	 * 
	 * <p>Linked lists are performance-wise fast and efficient ways to iterate
	 * over a lot of entries. There are however 3 complex and common problems in
	 * iterating over annonymous content:</p>
	 * 
	 * <ul>
	 *   <li>elements should not need to be casted</li>
	 *   <li>add/remove during iteations should not break them</li>
	 *   <li>elements should be addable as weak reference</li>
	 * </ul>
	 * 
	 * <p>This <code>List</code> implements solutions to all these three problems
	 * while keeping one's code fast and small, without the need to implement a lot
	 * new for every instance.</p>
	 * 
	 * <p>How are the different problems covered?</p>
	 * <p></p>
	 * <p><strong>Cast-free types while iteration</strong></p>
	 * <p>To have cast free types, it is (of course) necessary to extend <code>List</code>
	 * with your custom list. It is also required to create your own list node.</p>
	 * 
	 * <listing>
	 *    import nanosome.bind.pool.pool;
	 *    import nanosome.bind.list.List;
	 *    
	 *    class MyList extends List {
	 *      
	 *      private var _next: MyListNode;
	 *      private var _first: MyListNode;
	 *      
	 *      public function MyList(): void {
	 *        // Advise List to use the MyListNode InstancePool for creating instances
	 *        super( pool.getOrCreate( MyListNode ) );
	 *      }
	 *      
	 *      override protected function set next( next: ListNode ): void {
	 *        _next = MyListNode( node );
	 *      }
	 *      override protected function get next(): ListNode {
	 *        return _next;
	 *      }
	 *      
	 *      override protected function set first( node: ListNode ): void {
	 *        _first = MyListNode( node );
	 *      }
	 *      override protected function get first(): ListNode {
	 *        return _first;
	 *      }
	 *    }
	 *    
	 *    import nanosome.bind.list.ListNode;
	 *    
	 *    // Final is a bit of a performance booster as well.
	 *    final class MyListNode extends ListNode {
	 *      
	 *      internal var _next: MyListNode;
	 *      internal var _typedValue: MyType;
	 *      
	 *      override public function set next( node: ListNode ): void {
	 *        // Casting while next provides only creation type requirement for casting
	 *        _next = MyListNode( node );
	 *        super.next = node;
	 *      }
	 *      
	 *      override public function set strong( value: * ): void {
	 *        _typedValue = MyType( value );
	 *        
	 *        // No reference to super call to reduce memory, requires getter implementation
	 *      }
	 *      
	 *      override public function get strong(): * {
	 *        return _typedValue;
	 *      }
	 *    }
	 * </listing>
	 * 
	 * <p>In this first step its possible to have a easy iteration to functions, entirely typed:</p>
	 * 
	 * <listing>
	 *   class MyList {
	 *     ...
	 *     public function iterate(): void {
	 *       var current: MyListNode = _first;
	 *       while( current ) {
	 *         
	 *         // Do something with the current now.
	 *         current._typedValue.doSomething();
	 *         
	 *         // Access to the private variable avoids typing
	 *         current = current._next;
	 *       }
	 *     }
	 *   }
	 * </listing>
	 * 
	 * <p><strong>Error-free iterations</strong></p>
	 * <p>In order to provider error-free iterations its necessary to provide the
	 * list with the next element that you are about to process after the current one.
	 * This way it can modify the next entry in case of remove calls during iteration.
	 * <code>startIteration()</code> and <code>stopIteration()</code> are required
	 * around your iteration in order to provide a possiblity to stack <code>next</code>
	 * propery for having more than one iteration possible within a call stack.
	 * </p>
	 * 
	 * <listing>
	 *   class MyList extends List {
	 *     ...
	 *     public function iterate(): void {
	 *       startIteration();
	 *       var current: MyListNode = _first;
	 *       while( current ) {
	 *         _next = current.next;
	 *         
	 *         // Do something with the current now.
	 *         current._typedValue.doSomething();
	 *         
	 *         current = _next;
	 *       }
	 *       stopIteration();
	 *     }
	 *   }
	 * </listing>
	 * 
	 * <p><strong>Weak references</strong></p>
	 * <p>For weak references, every list node contains the strong typed value
	 * as well as a weak reference dictionary. With this it is easy to tackle both.</p>
	 * 
	 * <listing>
	 *   class MyList extends List {
	 *     ...
	 *     public function iterate(): void {
	 *       startIteration();
	 *       var current: MyListNode = _first;
	 *       while( current ) {
	 *         _next = current.next;
	 *         
	 *         // Do something with the current now.
	 *         var typed: MyType = current._typedValue;
	 *         if( typed ) {
	 *           typed.doSomething();
	 *         } else {
	 *           // Of course here: some casting needs to be done
	 *           typed = current.weak;
	 *           // Can be null because the weak entry might be not used anymore
	 *           if( typed ) {
	 *             typed.doSomething();
	 *           } else {
	 *             removeNode( current );
	 *           }
	 *         }
	 *         
	 *         current = _next;
	 *       }
	 *       stopIteration();
	 *     }
	 *   }
	 * </listing>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see UIDList
	 * @see ListNode
	 */
	public class List extends AbstractList {
		
		// Last entry in the list, required for proper add/remove
		private var _last: ListNode;
		
		// Pool that is used to create list nodes
		private var _nodePool: IInstancePool;
		
		// Registry that holds the nodes to each entry in the pool, for faster add/remove
		private var _registry: WeakDictionary;
		
		// Amount of entries in the linkedList (iteratable) part of the list
		private var _size: uint = 0;
		
		// Stack for every level of iteration, holds the next content, in order
		// to not mix up anything
		private var _nextStack: Array;
		
		/**
		 * Creates a new <code>List</code>
		 * 
		 * @param nodePool Pool to be used in the list to create new nodes
		 * @see nanosome.bind.pool.pool
		 */
		public function List( nodePool: IInstancePool ) {
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
		public function add( value: *, weak: Boolean = false ): Boolean {
			// Parent's function that will check if some iteration is ongoing
			return safeAdd( value, weak );
		}
		
		/**
		 * Removes a <code>value</code> from the list
		 * 
		 * @param value Value that should be removed from the list
		 * @return <code>true</code> if there has been a change in the list
		 */
		public function remove( value: * ): Boolean {
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
		public function contains( value: * ): Boolean {
			return ( _registry && _registry[ value ] )
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
		
		/**
		 * @inheritDoc
		 */
		override protected function addToLinkedList( content: *, weak: Boolean ): Boolean {
			// Create a registry, that is useful to save some perfromance/memory
			// when dealing with empty lists
			if( !_registry ) {
				_registry = WeakDictionary.POOL.getOrCreate();
			}
			var node: ListNode = ListNode( _registry[ content ] );
			if( !node ) {
				// Only add the node if it wasn't added before
				node = ListNode( _nodePool.getOrCreate() );
				
				// Save the content of the value
				node.content = content;
				
				// Store isWeak to easier identify the node, will manipulate the storage of the value
				node.isWeak = weak;
				
				_registry[ content ] = node;
				
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
			return _registry && _registry[ content ];
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function removeFromLinkedList( content: * ): Boolean {
			if( _registry && _registry[ content ] ) {
				// Remove the node only from linked list if it was really added
				removeNode( _registry[ content ] );
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
			var node: ListNode = first;
			while( node ) {
				var nextNode: ListNode = node.next;
				_nodePool.returnInstance( node );
				node = nextNode;
			}
			
			// Clear the registry
			if( _registry ) {
				WeakDictionary.POOL.returnInstance( _registry );
				_registry = null;
			}
			
			// Remove the stack
			if( _nextStack ) {
				while( _nextStack.length > 0 ) {
					_nextStack.pop();
				}
				ARRAY_POOL.returnInstance( _nextStack );
				_nextStack = null;
			}
			
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
		
		override protected function isWeakRegistered( value: * ): Boolean {
			if( _registry ) {
				var node: ListNode = _registry[value];
				return node && node.isWeak;
			}
			return false;
		}
		
		/**
		 * Removes on node from the list.
		 * 
		 * <p>This method is protected in order to allow some subclass to remove
		 * nodes to weak entries that are empty.</p>
		 * 
		 * @param node <code>ListNode</code> that should be removed from the list
		 */
		protected function removeNode( node: ListNode ) : void {
			
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
			delete _registry[ node.isWeak ? node.weak : node.strong ];
			
			// Return the node the the nodepool
			_nodePool.returnInstance( node );
			
			// Reduce the whole linked size
			--_size;
			
			// Remove the _registry dictionary if unused.
			if( _size == 0 ) {
				WeakDictionary.POOL.returnInstance( _registry );
				_registry = null;
			}
		}
		
		/**
		 * Override this method to the list which the first entry should be.
		 * 
		 * @return <code>ListNode</code> that is the first entry of the list
		 */
		protected function get first(): ListNode {
			throw new Error( "Abstract method" );
		}
		
		/**
		 * Stores the passed-in <code>ListNode</code> as the first entry in the
		 * iteration.
		 * 
		 * @param node <code>ListNode</code> that should be first in iteration
		 */
		protected function set first( node: ListNode ): void{
			throw new Error( "Abstract method" );
		}
		
		/**
		 * Override this method to the list which the next entry should be.
		 * 
		 * @return <code>ListNode</code> that is the next entry of the list
		 */
		protected function get next(): ListNode {
			throw new Error( "Abstract method" );
		}
		
		/**
		 * Stores the passed-in <code>ListNode</code> as the next entry in the
		 * iteration.
		 * 
		 * @param node <code>ListNode</code> that should be next in iteration
		 */
		protected function set next( node: ListNode ): void {
			throw new Error( "Abstract method" );
		}
		
		/**
		 * Clears all weak entries that don't contain a value anymore
		 */
		protected function clearEmptyWeak(): void {
			var current: ListNode = first;
			while( current ) {
				var next: ListNode = current.next;
				if( current.isWeak && current.weak == null ) {
					removeNode( current );
				}
				current = next;
			}
		}
	}
}
