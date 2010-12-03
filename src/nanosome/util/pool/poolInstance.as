package nanosome.util.pool {
	
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function poolInstance( clazz: Class ): * {
		return POOL_STORAGE.getOrCreate( clazz ).getOrCreate();
	}
}
