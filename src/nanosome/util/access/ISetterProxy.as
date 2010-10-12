// @license@
package nanosome.util.access {
	
	/**
	 * <code>ISetterProxy</code> is a definition for classes that allow the
	 * setting of its properties by using methods. This interface is respected by
	 * <code>Accessor</code> and subsequently by the <code>connect</code>
	 * functionality.
	 * 
	 * <p>This ist the counterpart to <code>IGetterProxy</code>.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see IGetterProxy
	 * @see Accessor
	 */
	public interface ISetterProxy {
		
		/**
		 * Sets one property of the instance.
		 * 
		 * @param name Name of the property.
		 * @param value Value that the property should get
		 * @return <code>true</code> if the property was accepted properly
		 */
		function write( name: String, value: * ): Boolean;

		function remove( property: String ): Boolean;
	}
}
