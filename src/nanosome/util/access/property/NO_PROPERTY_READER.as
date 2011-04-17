package nanosome.util.access.property {
	import nanosome.util.access.IPropertyReader;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public const NO_PROPERTY_READER: IPropertyReader = new NoPropertyReader();
}

import nanosome.util.access.IPropertyReader;

class NoPropertyReader implements IPropertyReader {
	
	public function read( instance: * ): * {
		return null;
	}
	
	public function get observable(): Boolean {
		return false;
	}
	
	public function get bindable(): Boolean {
		return false;
	}
	
	public function get sendingEvent(): String {
		return null;
	}
	
	public function get type(): Class {
		return null;
	}
	
	public function get silent(): Boolean {
		return true;
	}
}