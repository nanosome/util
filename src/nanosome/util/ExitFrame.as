// @license@
package nanosome.util {
	
	import nanosome.util.list.fnc.FunctionList;
	import flash.display.Shape;
	
	/**
	 * <code>ExitFrame</code> provides a high-performant way to trigger the common
	 * exit-frame event dispatched by DisplayObject's.
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 * @see flash.display.Event
	 * @see flash.display.DisplayList
	 * @see nanosome.util.EnterFrame
	 * @see nanosome.util.list.fnc.FunctionList
	 */
	public class ExitFrame {
		
		// Shape that provides the enter frame event
		private static const _helper: Shape = new Shape();
		
		// List of functions that can be processed fast
		private static const _list: FunctionList = new FunctionList( removeListeners );
		
		// Private variable to note if the listener has been added.
		private static var _listening: Boolean = false;
		
		/**
		 * Adds a method that should be called starting from next enter-frame
		 * event.
		 * 
		 * @param method method that should be executed
		 * @param executeImmediately <code>true</code> to execute the method immediatly
		 * @param weakReference <code>true</code> to register the method as weak reference
		 * @return <code>true</code> if the method was successfully added,
		 *         <code>false</code> if the method was already added before
		 */
		public static function add( method: Function, executeImmediately: Boolean = false,
												weakReference: Boolean = false ): Boolean {
			var added: Boolean = _list.add( method, weakReference );
			if( !_listening ) {
				_listening = true;
				_helper.addEventListener( "exitFrame", _list.execute );
			}
			if( executeImmediately && method != null ) {
				method();
			}
			return added;
		}
		
		/**
		 * Check method to see whether or not a method is added to the enter-frame
		 * event.
		 * 
		 * @param method Method to be checked whether its contained or not
		 * @return <code>true</code> if the method was added
		 */
		public static function contains( method: Function ): Boolean {
			return _list.contains( method);
		}

		/**
		 * Removes a method from beeing called on next next
		 * event.
		 * 
		 * @param method method that should not be executed
		 * @return <code>true</code> if the method was successfully removed,
		 *         <code>false</code> if the method was not added before
		 */
		public static function remove( method: Function ): Boolean {
			if( _list.remove( method ) ) {
				if( _list.empty && _listening ) {
					removeListeners();
				}
				return true;
			}
			return false;
		}
		
		private static function removeListeners(): void {
			_listening = false;
			_helper.removeEventListener( "exitFrame", _list.execute );
		}
	}
}
