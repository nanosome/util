package nanosome.util.access {
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function getNamespace( uri: String ): Namespace {
		if( uri ) {
			return store[ uri ] || ( store[ uri ] = new Namespace( null, uri ) );
		} else {
			return publicNs;
		}
	}
}
const store: Object = {};