package nanosome.util.access {
	import nanosome.util.ChangedPropertyNode;
	import nanosome.notify.observe.ObservableSprite;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class ProxyClass extends ObservableSprite implements ISetterProxy, IGetterProxy {
		
		public var normal: Array;
		
		public var internalClass: InternalClass;
		
		internal var internalVariable: Array;
		
		[Bindable]
		public var bindable: Array;
		
		private var _observable: Array;
		
		private var _changedProperties : Object = {};
		
		[Observable]
		public function get observable(): Array {
			return _observable;
		}
		
		public function set observable( observable: Array) : void {
			if( _observable != observable ) notifyPropertyChange( "observable", _observable, _observable = observable );
		}
		
		public function write(name : String, value : *) : Boolean {
			if( name == "not_valid") {
				return false;
			} else {
				_changedProperties[ name ] = value;
				return true;
			}
		}
		
		public function setAll(target : *, targetProxy : Accessor = null ) : void {
		}
		
		public function read(name : *) : * {
		}
		
		public function readAll( fields: Array = null, connectableOnly : Boolean = false ) : Object {
			return {
			};
		}
		
		public function get changedProperties() : Object {
			return _changedProperties;
		}

		public function compareWithStorage(source : *, storage : Object) : ChangedPropertyNode {
			// TODO: Auto-generated method stub
			return null;
		}
	}
}

class InternalClass {
}
