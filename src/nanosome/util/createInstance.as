// @license@
package nanosome.util {
	
	import flash.utils.describeType;
	
	/**
	 * Creates a instance from a anonymous class.
	 * 
	 * <p>Occasionally its necessary to have a instance of a class for analyzation.
	 * this might be especially necessary since <code>describeType</code> shows
	 * different results on instances than on classes.</p>
	 * 
	 * <p>Note: As for now, it will use always just the not-optional parameters,
	 * no matter how many you pass in.</p>
	 * 
	 * @param clazz anonymous class to create a instance from
	 * @param args constructor arguments
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function createInstance( clazz: Class, args: Array = null ): * {
		if( !args ) {
			args = [];
		}
		var xml: XML = describeType( clazz );
		const l: int = xml.factory.constructor.parameter.(@optional!="true").length();
		switch( l ) {
			case 0:
				return new clazz();
			case 1:
				return new clazz( args[0] );
			case 2:
				return new clazz( args[0], args[1] );
			case 3:
				return new clazz( args[0], args[1], args[2] );
			case 4:
				return new clazz( args[0], args[1], args[2], args[3] );
			case 5:
				return new clazz( args[0], args[1], args[2], args[3], args[4] );
			case 6:
				return new clazz( args[0], args[1], args[2], args[3], args[4],
					args[5] );
			case 7:
				return new clazz( args[0], args[1], args[2], args[3], args[4],
					args[5], args[6] );
			case 8:
				return new clazz( args[0], args[1], args[2], args[3], args[4],
					args[5], args[6], args[7] );
			case 9:
				return new clazz( args[0], args[1], args[2], args[3], args[4],
					args[5], args[6], args[7], args[8] );
			case 10:
				return new clazz( args[0], args[1], args[2], args[3], args[4],
					args[5], args[6], args[7], args[8], args[9] );
			case 11:
				return new clazz( args[0], args[1], args[2], args[3], args[4],
					args[5], args[6], args[7], args[8], args[9], args[10] );
			case 12:
				return new clazz( args[0], args[1], args[2], args[3], args[4],
					args[5], args[6], args[7], args[8], args[9], args[10], args[11] );
		}
		throw new Error( "Class not instantiatable, too many arguments." );
	}
}
