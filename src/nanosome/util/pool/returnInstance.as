package nanosome.util.pool {
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function returnInstance( instance: * ): void {
		try {
			POOL_LIST.getOrCreate(
				getDefinitionByName( getQualifiedClassName( instance ) ) as Class
			).returnInstance( instance );
		} catch( e: ReferenceError ) {
			throw new Error( "Class of passed-in instance not evaluatable because its not public." );
		}
	}
}
