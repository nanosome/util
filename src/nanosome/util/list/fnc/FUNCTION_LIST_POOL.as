package nanosome.util.list.fnc {
	import nanosome.util.pool.poolFor;
	import nanosome.util.pool.IInstancePool;

	/**
	 * @author mh
	 */
	public const FUNCTION_LIST_POOL: IInstancePool = poolFor( FunctionList );
}
