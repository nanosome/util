// @license@ 
package nanosome.util.access {
	
	import nanosome.util.IDisposable;
	import nanosome.util.cleanObject;
	import nanosome.util.pool.OBJECT_POOL;
	
	/**
	 * 
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public class Changes implements IDisposable {
		
		/**
		 * Map of old values before the change.
		 */
		public const oldValues: Object /* String -> Object */ = OBJECT_POOL.getOrCreate();
		
		
		/**
		 * Map of new values after the change.
		 */
		public const newValues: Object /* String -> Object */ = OBJECT_POOL.getOrCreate();
		
		public function Changes() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose(): void {
			cleanObject( oldValues );
			OBJECT_POOL.returnInstance( oldValues );
			cleanObject( newValues );
			OBJECT_POOL.returnInstance( newValues );
		}
	}
}