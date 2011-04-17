package nanosome.util.access {
	import nanosome.util.access.property.NO_PROPERTY_READER;
	import nanosome.util.access.property.NO_PROPERTY_WRITER;
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class PropertyAccess {
		
		public function PropertyAccess() {}
		
		public var qName: QName;
		public var type: Class;
		public var reader: IPropertyReader = NO_PROPERTY_READER;
		public var writer: IPropertyWriter = NO_PROPERTY_WRITER;
	}
	
}
