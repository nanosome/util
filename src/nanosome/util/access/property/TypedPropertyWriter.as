package nanosome.util.access.property {
	import nanosome.util.access.IPropertyWriter;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class TypedPropertyWriter implements IPropertyWriter {
		
		private var _name: QName;
		private var _type: Class;
		
		public function TypedPropertyWriter( name: QName, type: Class ) {
			_name = name;
			_type = type;
		}
		
		public function write( target: *, value: * ): Boolean {
			if( !( value is _type ) && value != null ) {
				return false;
			} else {
				try {
					target[ _name ] = value;
					return true;
				} catch( e: Error ) {}
				return false;
			}
		}
		
		public function remove( target: * ): Boolean {
			return false;
		}
	}
}
