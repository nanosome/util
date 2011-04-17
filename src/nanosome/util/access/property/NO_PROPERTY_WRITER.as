package nanosome.util.access.property {
	import nanosome.util.access.IPropertyWriter;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public const NO_PROPERTY_WRITER: IPropertyWriter = new NoPropertyWriter();
}

import nanosome.util.access.IPropertyWriter;

class NoPropertyWriter implements IPropertyWriter {
	
	public function write( target: *, value: * ): Boolean {
		return false;
	}
	
	public function remove( target: * ): Boolean {
		return false;
	}
}