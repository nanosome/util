// @license@
package nanosome.util {
	
	/**
	 * <code>LockableSprite</code> is a useful template that implements <code>ILockable</code>.
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see ILockable
	 */
	public class LockableSprite extends DisposableSprite implements ILockable {
		
		private var _locked: Boolean;
		
		public function LockableSprite() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public final function lock(): void {
			locked = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public final function unlock(): void {
			locked = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get locked(): Boolean {
			return _locked;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set locked( locked: Boolean ): void {
			_locked = locked;
		}
	}
}
