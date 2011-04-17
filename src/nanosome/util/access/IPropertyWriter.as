package nanosome.util.access {
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public interface IPropertyWriter {
		function write( target: *, value: * ): Boolean;
		function remove( target: * ): Boolean;
	}
}
