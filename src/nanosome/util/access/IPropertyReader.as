package nanosome.util.access {
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public interface IPropertyReader {
		function read( instance: * ): *;
		function get observable(): Boolean;
		function get bindable(): Boolean;
		function get sendingEvent(): String;
		function get silent(): Boolean;
	}
}
