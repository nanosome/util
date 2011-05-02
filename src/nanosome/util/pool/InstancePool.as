// @license@ 
package nanosome.util.pool {
	import nanosome.util.create;
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	
	
	import nanosome.util.IDisposable;
	import nanosome.util.UID;
	
	/**
	 * Default implementation of <code>IInstancePool</code>.
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see IInstancePool
	 */
	public class InstancePool extends UID implements IInstancePool {
		
		// Storage to remember the full class name of IDisposable to easier compare later on.
		private static const IDISPOSABLE: String = getQualifiedClassName( IDisposable );
		
		// List, should be set to null or filled. No empty array
		private var _list: Array /* Object */;
		
		// Class to create instances of
		private var _clazz: Class;
		
		// true if the class implements IDisposable
		private var _disposable: Boolean;
		
		// true if this pool is about to be cleared by the PoolCleaner
		private var _inPoolCleaner: Boolean = false;
		
		/**
		 * Creates a new instance pool for the passed-in <code>Class</code>
		 * 
		 * @param clazz Class of the instances of this pool
		 */
		public function InstancePool( clazz: Class ) {
			super();
			_clazz = clazz;
			// Check for implementation of Disposable just once
			_disposable = describeType( clazz ).factory.implementsInterface.(@type==IDISPOSABLE).length() > 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getOrCreate(): * {
			return _list ? ( _list.pop() || create( _clazz ) ) : create( _clazz );
		}
		
		/**
		 * @inheritDoc
		 */
		public function returnInstance( instance: * ): void {
			if( instance ) {
				if( _disposable ) {
					IDisposable( instance ).dispose();
				}
				( _list || ( _list = [] ) ).push(instance);
				if( !_inPoolCleaner ) {
					_inPoolCleaner = true;
					POOL_CLEANER.add( this );
				}
			}
		}
		
		/**
		 * Cleans the passed-in amount of instances.
		 * 
		 * @param instances amount of instances to clean
		 * @return if the amount of instances in this pool was less than should
		 *         be cleaned it returns difference between how many should and
		 *         how many have been cleaned.
		 */
		public function clean( instances: int ): int {
			
			// In case someone calls this method even tough no instances have 
			// been added just return all instances.
			if( !_list ) {
				return instances;
			}
			
			while( instances > 0 && _list.length > 0 ) {
				_list.pop();
				--instances;
			}
			
			// Release the list from the memory and remove this pool from beeing
			// cleaned.
			if( _list.length == 0 ) {
				_list = null;
				_inPoolCleaner = false;
				POOL_CLEANER.remove( this );
			}
			return instances;
		}
	}
}
