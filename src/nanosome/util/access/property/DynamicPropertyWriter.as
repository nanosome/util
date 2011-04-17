package nanosome.util.access.property {
	import nanosome.util.access.IPropertyWriter;
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class DynamicPropertyWriter implements IPropertyWriter {
		
		private var _name: QName;
		
		public function DynamicPropertyWriter( name: QName ) {
			_name = name;
		}
		
		public function write( target: *, value: * ): Boolean {
			try {
				target[ _name ] = value;
				return true;
			} catch( e: Error ){}
			return false;
		}
		
		public function remove( target: * ): Boolean {
			try {
				delete target[ _name ];
				return true;
			} catch( e: Error ){}
			return false;
		}
	}
}
