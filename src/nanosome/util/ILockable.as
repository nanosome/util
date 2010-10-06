// @license@
package nanosome.util {
	
	/**
	 * <code>ILockable</code> generalizes the case where instances have to update
	 * after each change. Doing many changes would result in a lot of events(code)
	 * that has to happen. Making a instance lockable might in certain cases reduce
	 * the operation time significantly.
	 * 
	 * <p>In a locked state the instance is adviced to not send out any updates
	 * and stock all the events in order to provide a constistant state.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public interface ILockable {
		
		/**
		 * Locks the instance, preventing it to send out events.
		 */
		function lock(): void;
		
		/**
		 * Unlocks the instance, letting it send all the yet to be sent out
		 * events.
		 */
		function unlock(): void;
		
		/**
		 * Tells whether or not the instances is currently locked.
		 * 
		 * @return <code>true</code> if the instance is locked, else <code>false</code>
		 */
		function get locked(): Boolean;
		
		/**
		 * Allows a different access to change the lock of a instance
		 * 
		 * @param <code>true</code> if no changes should be tracked.
		 */
		function set locked( locked: Boolean ): void;
	}
}
