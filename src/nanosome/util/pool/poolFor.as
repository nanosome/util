package nanosome.util.pool {
	
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function poolFor( clazz: Class ): IInstancePool {
		return POOL_LIST.getOrCreate( clazz );
	}
}
