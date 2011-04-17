package nanosome.util.access.property {
	import nanosome.util.access.IPropertyWriter;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class PrimitiveWriter implements IPropertyWriter {
		
		private var _name: QName;
		private var _type: Class;
		
		public function PrimitiveWriter( name: QName, type: Class ) {
			_name = name;
			_type = type;
		}
		
		public function write( target: *, value: * ): Boolean {
			var temp: *  = _type( value );
			if( temp != value ) {
				try {
					target[ _name ] = 0;
				} catch( e: Error ) {}
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
