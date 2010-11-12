package nanosome.util.access {
	import nanosome.util.IDisposable;
	import nanosome.util.cleanObject;
	import nanosome.util.pool.IInstancePool;
	import nanosome.util.pool.OBJECT_POOL;
	import nanosome.util.pool.poolFor;
	/**
 * @author Martin Heidegger mh@leichtgewicht.at
 */
	public class Changes implements IDisposable {
		
		public static const POOL: IInstancePool = poolFor( Changes );
		
		public const oldValues: Object = OBJECT_POOL.getOrCreate();
		public const newValues: Object = OBJECT_POOL.getOrCreate();
		
		public function Changes() {
			super();
		}
		
		public function dispose(): void {
			cleanObject( oldValues );
			OBJECT_POOL.returnInstance( oldValues );
			cleanObject( newValues );
			OBJECT_POOL.returnInstance( newValues );
		}
	}
}