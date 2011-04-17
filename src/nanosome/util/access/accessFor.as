// @license@ 
package nanosome.util.access {
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Retrieves a <code>Accessor</code> that allows proper access to
	 * variables of a class.
	 * 
	 * <p>If you request a Accessor for a unaccessible class which is eighter
	 * a internal class or not loaded yet you will retrieve the same Accessor
	 * you would also retreive for <code>null</code>. This certain Accessor
	 * can not access the type informations, which leads to the inability to
	 * respect <code>IPropertiesSetterProxy</code> and the also the pre-checks
	 * of valid types doesn't work.</p>
	 * 
	 * @param object Instance of a class or the class itself for which
	 *            a Modifier should be retrieved
	 * @return Modifier that can handle this class
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see Accessor
	 */
	public function accessFor( object: * ): Accessor {
		var typeName: String = null;
		if( object ) {
			typeName = getQualifiedClassName( object );
		}
		
		try {
			return _objectMap[ typeName ] || ( _objectMap[ typeName ] = new Accessor( typeName, object ) );
		} catch( e: Error ) {
			// trace( e.getStackTrace() );
		}
		
		// If the instanciation doesn't work, treat the class as
		// completly dynamic!
		return accessFor( null );
	}
}

// Stores modifier intances for each class
// Maps class name to Modifier instance
const _objectMap: Object /* String -> Modifier */ = {};