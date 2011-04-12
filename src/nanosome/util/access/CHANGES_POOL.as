package nanosome.util.access {
	
	import nanosome.util.pool.IInstancePool;
	import nanosome.util.pool.poolFor;
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	internal const CHANGES_POOL: IInstancePool = poolFor( Changes );
}
