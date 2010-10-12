// @license@
package nanosome.util.pool {
	
	import nanosome.util.pool.IInstancePool;
	
	/**
	 * Instance pool for Arrays.
	 * 
	 * <p>To return instances to this pool the array has to be empty.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public const ARRAY_POOL: IInstancePool = pools.getOrCreate( Array );
}
