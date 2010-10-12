// @license@

package nanosome.util.pool {
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	
	
	import nanosome.util.IDisposable;
	import nanosome.util.UID;
	
	/**
	 * 
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @version 1.0
	 */
	public class InstancePool extends UID implements IInstancePool {
		
		private static const IDISPOSABLE: String = getQualifiedClassName( IDisposable );
		
		private var _list: Array;
		private var _clazz: Class;
		private var _disposable: Boolean;
		private var _inPoolsList: Boolean = false;
		
		public function InstancePool( clazz: Class ) {
			_clazz = clazz;
			_disposable = describeType( clazz ).factory.implementsInterface.(@type==IDISPOSABLE).length() > 0;
		}
		
		public function getOrCreate(): * {
			return _list ? ( _list.pop() || new _clazz() ) : new _clazz();
		}
		
		public function returnInstance( instance: * ): void {
			if( instance ) {
				if( _disposable ) {
					IDisposable( instance ).dispose();
				}
				( _list || ( _list = [] ) ).push(instance);
				if( !_inPoolsList ) {
					_inPoolsList = true;
					pools.add( this );
				}
			}
		}
		
		public function clean( i: int ): int {
			if( !_list ) {
				return i;
			}
			while( i > 0 && _list.length > 0 ) {
				_list.pop();
				--i;
			}
			if( _list.length == 0 ) {
				_list = null;
				_inPoolsList = false;
				pools.remove( this );
			}
			return i;
		}
	}
}
