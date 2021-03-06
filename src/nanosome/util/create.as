// @license@ 
package nanosome.util {
	
	import nanosome.util.access.qname;
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
	 * @param props properties to be set immediatly to the new instance
	 * @param args constructor arguments
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function create( clazz: Class, props: Object = null, args: Array = null ): * {
		var result: *;
		args = args || EMPTY_ARRAY;
		var l: int = CACHE[ clazz ];
		if( l < 1 ) {
			// Store one variable more to do it properly
			CACHE[ clazz ] = ( l = describeType( clazz ).factory
									.constructor.parameter.(@optional!="true").length() ) + 1;
		} else {
			l--;
		}
		switch( l ) {
			case 0:
				result = new clazz();
				break;
			case 1:
				result = new clazz( args[0] );
				break;
			case 2:
				result = new clazz( args[0], args[1] );
				break;
			case 3:
				result = new clazz( args[0], args[1], args[2] );
				break;
			case 4:
				result = new clazz( args[0], args[1], args[2], args[3] );
				break;
			case 5:
				result = new clazz( args[0], args[1], args[2], args[3], args[4] );
				break;
			case 6:
				result = new clazz( args[0], args[1], args[2], args[3], args[4],
					args[5] );
				break;
			case 7:
				result = new clazz( args[0], args[1], args[2], args[3], args[4],
					args[5], args[6] );
				break;
			case 8:
				result = new clazz( args[0], args[1], args[2], args[3], args[4],
					args[5], args[6], args[7] );
				break;
			case 9:
				result = new clazz( args[0], args[1], args[2], args[3], args[4],
					args[5], args[6], args[7], args[8] );
				break;
			case 10:
				result = new clazz( args[0], args[1], args[2], args[3], args[4],
					args[5], args[6], args[7], args[8], args[9] );
				break;
			case 11:
				result = new clazz( args[0], args[1], args[2], args[3], args[4],
					args[5], args[6], args[7], args[8], args[9], args[10] );
				break;
			case 12:
				result = new clazz( args[0], args[1], args[2], args[3], args[4],
					args[5], args[6], args[7], args[8], args[9], args[10], args[11] );
				break;
		}
		if( !result ) {
			throw new Error( "Class not instantiatable, too many arguments." );
		}
		if( props ) {
			if( result is ILockable ) {
				ILockable( result ).lock();
			}
			for( var propName: * in props ) {
				result[ qname(propName) ] = props[propName];
			}
			if( result is ILockable ) {
				ILockable( result ).unlock();
			}
		}
		return result;
	}
}
import flash.utils.Dictionary;

const CACHE: Dictionary = new Dictionary();
const EMPTY_ARRAY: Array = [];