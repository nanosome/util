// @license@ 
package nanosome.util.pool {
	
	import nanosome.util.IDisposable;
	
	import flash.utils.Dictionary;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class WeakDictionary extends Dictionary implements IDisposable {
		
		public static const POOL: IInstancePool = poolFor( WeakDictionary );
		
		public function WeakDictionary() {
			super( true );
		}
		
		public function dispose() : void {
			for( var any: * in this ) {
				delete this[ any ];
			}
		}
	}
}
