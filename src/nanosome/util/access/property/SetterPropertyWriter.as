package nanosome.util.access.property {
	import nanosome.util.access.IPropertyWriter;
	import nanosome.util.access.ISetterProxy;
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class SetterPropertyWriter implements IPropertyWriter {
		
		private var _name: QName;
		
		public function SetterPropertyWriter( name: QName ) {
			_name = name;
		}
		
		public function write( target: *, value: * ): Boolean {
			return ISetterProxy( target ).write( _name, value );
		}

		public function remove( target: * ): Boolean {
			return ISetterProxy( target ).remove( _name );
		}
	}
}
