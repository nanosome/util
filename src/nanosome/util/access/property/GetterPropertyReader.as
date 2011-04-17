package nanosome.util.access.property {
	import nanosome.util.access.IGetterProxy;
	import nanosome.util.access.IPropertyReader;
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class GetterPropertyReader extends DynamicPropertyReader implements IPropertyReader {
		
		public function GetterPropertyReader( name: QName, observable: Boolean,
											   bindable: Boolean, sendingEvent: String ) {
			super( name, observable, bindable, sendingEvent );
		}
		
		override public function read( instance: * ): * {
			return IGetterProxy( instance ).read( _name );
		}
	}
}
