// @license@ 
package nanosome.util.access {
	import flash.events.IEventDispatcher;
	
	
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
	public interface IGetterProxy extends IEventDispatcher {
		
		/**
		 * Gets one property of the instance.
		 * 
		 * @param name Name of the property
		 * @param ns Namespace of the property 
		 * @param fullName Name of the property including the namespace
		 * @return value of the property
		 */
		function read( name: QName ): *;
	}
}
