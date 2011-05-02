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
			try {
				target[ _name ] = _type( value );
				return true;
			} catch( e: Error ) {
			}
			return false;
		}
		
		public function remove( target: * ): Boolean {
			return false;
		}
	}
}
