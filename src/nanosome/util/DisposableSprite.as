// @license@ 
package nanosome.util {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * <code>DisposableSprite</code> is a useful util <code>Sprite</code> basis 
	 * that removes itself and its children from the display tree on <code>dispose</code>.
	 * 
	 * <p>All instances added as children will be removed for convenience reasons.
	 * <strong>If a child is IDisposable it will be disposed!</strong> If you want to
	 * prevent that from happening its recommended to remove the child before calling
	 * <code>IDispose</code></p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see IDisposable
	 */
	public class DisposableSprite extends Sprite implements IUID, IDisposable {
		
		// Id provider
		private const _uid: uint = UID.next();
		
		public function DisposableSprite() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get uid(): uint {
			return _uid;
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose(): void {
			
			// Remove from tree if still added
			if( parent ) parent.removeChild( this );
			
			// Remove all children if there are still some available
			// this has to be done after the object was removed from its parent
			// to ensure that eventual parent onAdd/onRemove listeners didn't confuse
			// stuff.
			while( numChildren > 0 ) {
				var child: DisplayObject = removeChildAt( 0 );
				
				// Dispose the child if its disposable.
				// TODO: Investigate possible, negative side-effects.
				if( child is IDisposable ) {
					IDisposable( child ).dispose();
				}
			}
			
			// remove any given scrollRect
			scrollRect = null;
			
			// remove any given mask
			mask = null;
		}
	}
}
