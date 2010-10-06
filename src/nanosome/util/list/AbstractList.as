// @license@
package nanosome.util.list {
	
	import nanosome.util.pool.IInstancePool;
	import nanosome.util.IDisposable;
	import nanosome.util.pool.WeakDictionary;
	
	/**
	 * <code>AbstractList</code> combines the common functionality provided in both
	 * <code>UIDList</code> and <code>List</code>.
	 * 
	 * <p>Basic concepts like the queue during iteration or iterations itself are
	 * handled in both <code>UIDList</code> and <code>List</code> in the same way.
	 * In order to not have same methods twice, this class exists.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	internal class AbstractList implements IDisposable {
		
		// For performance reason store the pool in a local scope
		private static const WEAK_DICT_POOL: IInstancePool = WeakDictionary.POOL;
		
		// Stack-depth of iteration
		private var _iterDepth: int = -1;
		
		// Queue of entries that should be added after the iteration
		private var _addQueue: Array /* Object */;
		
		// Map for all entries in the queue that stores whether each entry should
		// be weak or not.
		private var _addQueueWeakMap: WeakDictionary /* Object -> Boolean */;
		
		/**
		 * Size of the list
		 */
		public function get size(): uint {
			return _addQueue ? _addQueue.length : 0;
		}
		
		/**
		 * @param value The entry that should be added.
		 * @return <code>true</code> if the entry is added and was added weak
		 */
		public final function isWeakAdded( value: * ): Boolean {
			if( _addQueue && _addQueue.indexOf( value ) != -1 ) {
				return _addQueueWeakMap[ value ];
			}
			return isWeakRegistered( value );
		}
		
		/**
		 * <code>true</code> if is no entry in the list
		 */
		public function get empty(): Boolean {
			if( _addQueue ) {
				return false;
			}
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose() : void {
			_addQueue = null;
			if( _addQueueWeakMap ) {
				WEAK_DICT_POOL.returnInstance( _addQueueWeakMap );
				_addQueueWeakMap = null;
			}
			_iterDepth = -1;
		}
		
		/**
		 * Removes the <code>value</code> from the queue, if it was added to the queue before
		 * 
		 * @param value <code>value</code> to be checked
		 * @return <code>true</code> if the value was part of the queue
		 */
		protected final function containsInQueue( value: * ): Boolean {
			return ( _addQueue && _addQueue.indexOf( value ) != -1 );
		}
		
		/**
		 * Adds a <code>value</code> to 
		 */
		protected final function safeAdd( value: *, weak: Boolean ): Boolean {
			if( value == null || value == undefined ) {
				// null or undefined might break the registry and might lead
				// to indifferent values.
				return false;
			} else {
				if( _iterDepth > -1 ) {
					
					if( containsInRegistry( value ) && weak == isWeakRegistered( value ) ) {
						// If it was already modified in the queue, remove potential entries in queue
						if( _addQueue ) {
							var index: uint = _addQueue.indexOf( value );
							if( index != -1 ) {
								_addQueue.splice( index, 1 );
								delete _addQueueWeakMap[ value ];
								return true;
							} else {
								return false;
							}
						} else {
							return false;
						}
					} else {
						if( !_addQueue ) {
							_addQueue = [ value ];
							_addQueueWeakMap = WeakDictionary.POOL.getOrCreate();
							_addQueueWeakMap[ value ] = weak;
							return true;
						} else {
							if( _addQueue.indexOf( value ) == -1 ) {
								_addQueue.push( value );
								_addQueueWeakMap[ value ] = weak;
								return true;
							} else {
								if( _addQueueWeakMap[ value ] != weak ) {
									_addQueueWeakMap[ value ] = weak;
									return true;
								} else {
									return false;
								}
							}
						}
					}
				} else {
					return addToLinkedList( value, weak );
				}
			}
		}
		
		/**
		 * Removes 
		 */
		protected final function removeInternal( content: * ): Boolean {
			if( _addQueue ) {
				var index: int = _addQueue.indexOf( content );
				if( index != -1 ) {
					_addQueue.splice( index, 1 );
					delete _addQueueWeakMap[ content ];
					if( _addQueue.length == 0 ) {
						_addQueue = null;
						WeakDictionary.POOL.returnInstance( _addQueueWeakMap );
					}
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}
		
		/**
		 * Starts a iteration
		 * 
		 * @return depth of iteration
		 */
		protected function startIterate(): int {
			return ++_iterDepth;
		}
		
		/**
		 * Stops a iteration
		 */
		protected function stopIterate(): void {
			--_iterDepth;
			if( _iterDepth == -1 ) {
				if( _addQueue ) {
					var queue: Array = _addQueue;
					var queueMap: WeakDictionary = _addQueueWeakMap;
					
					_addQueue = null;
					_addQueueWeakMap = null;
					
					while( queue.length ) {
						var content: * = queue.shift();
						safeAdd( content, queueMap[ content ] );
					}
					WEAK_DICT_POOL.returnInstance( queueMap );
				}
			}
		}
		
		protected function addToLinkedList( content: *, weak: Boolean ): Boolean {
			throw new Error( "abstract" );
		}
		
		protected function removeFromLinkedList( content: * ): Boolean {
			throw new Error( "abstract" );
		}
		
		protected function containsInRegistry( content: * ): Boolean {
			throw new Error( "abstract" );
		}
		
		protected function isWeakRegistered( value: * ): Boolean {
			throw new Error( "abstract" );
		}
	}
}
