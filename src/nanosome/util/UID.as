// @license@
package nanosome.util {
	
	/**
	 * <code>UID</code> util to provide across a application a unique id.
	 * 
	 * <p>Its recommended to use this class for any implementation of <code>IUID</code>.
	 * You can eigther extend this class, or use the static <code>next()</code>
	 * method to retreive a new id.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see nanosome.util.IUID
	 */
	public class UID implements IUID {
		
		// Internal holder for a id
		private static var ID: uint = 0;
		
		/**
		 * Creates a new unique identifier.
		 * 
		 * @return new id to be used.
		 */
		public static function next(): uint {
			return ++ID;
		}
		
		// Id associated with this instance.
		private const _id: uint = UID.next();
		
		public function UID() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get uid(): uint {
			return _id;
		}
	}
}
