// @license@

package nanosome.util.access {
	
	
	/**
	 * <code>IGetterProxy</code> is a definition for classes that allow the
	 * getting of its properties by using methods. This interface is respected by
	 * <code>Accessor</code> and subsequently by the <code>connect</code> functionality.
	 * 
	 * <p>This ist the counterpart to <code>ISetterProxy</code>.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see ISetterProxy
	 * @see Accessor
	 */
	public interface IGetterProxy {
		
		/**
		 * Gets one property of the instance.
		 * 
		 * @param name Name of the property
		 * @return value of the property
		 */
		function read( name: * ): *;
		
		/**
		 * Gets all properties of the instance.
		 * 
		 * @param fields Fields that should be read
		 * @param connectableOnly Only the properties that are eigther <code>[Bindable]</code>
		 *        or <code>Connectable</code>
		 * @return Mapping of all property names to all values
		 */
		function readAll( fields: Object = null, connectableOnly: Boolean = false ): Object/* String -> Object */;
	}
}
