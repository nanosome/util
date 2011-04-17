package nanosome.util.access {
	import nanosome.util.UID;

	import flash.display.Sprite;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class ProxyClass extends Sprite implements ISetterProxy, IGetterProxy {
		
		public var normal: Array;
		
		public var internalClass: InternalClass;
		
		internal var internalVariable: Array;
		
		[Bindable]
		public var bindable: Array;
		
		private var _observable: Array;
		
		private var _changedProperties : Object = {};
		
		private var _uid: uint = UID.next();
		
		public function get uid(): uint {
			return _uid;
		}
		
		[Observable]
		public function get observable(): Array {
			return _observable;
		}
		
		public function set observable( observable: Array) : void {
			_observable = observable;
		}
		
		public function write( name: QName, value: * ) : Boolean {
			if( name.toString() == "not_valid") {
				return false;
			} else {
				_changedProperties[ name ] = value;
				return true;
			}
		}
		
		public function setAll(target : *, targetProxy : Accessor = null ) : void {
		}
		
		public function read( name: QName ): * {
		}
		
		public function readAll( fields: Object = null, connectableOnly : Boolean = false ) : Object {
			return {
			};
		}
		
		public function remove( name: QName ): Boolean {
			return false;
		}
		
		public function get changedProperties() : Object {
			return _changedProperties;
		}

		public function isObservable( name: QName ): Boolean {
			return false;
		}

		public function isBindable( name: QName ): Boolean {
			return false;
		}

		public function getSendingEvent( name: QName ): String {
			return "";
		}

		public function hasWritableProperty( fullName: String ): Boolean {
			return false;
		}

		public function hasReadableProperty( fullName: String ): Boolean {
			return false;
		}
	}
}

class InternalClass {
}
