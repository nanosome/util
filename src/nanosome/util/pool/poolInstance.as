package nanosome.util.pool {
	
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function poolInstance( clazz: Class ): * {
		return POOL_LIST.getOrCreate( clazz ).getOrCreate();
	}
}
