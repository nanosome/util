package nanosome.util.access.property {
	import nanosome.util.access.IPropertyReader;
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class DynamicPropertyReader implements IPropertyReader {
		
		protected var _name: QName;
		private var _observable: Boolean;
		private var _bindable: Boolean;
		private var _sendingEvent: String;
		
		public function DynamicPropertyReader( name: QName, observable: Boolean,
											   bindable: Boolean, sendingEvent: String ) {
			_name = name;
			_observable = observable;
			_bindable = bindable;
			_sendingEvent = sendingEvent;
		}
		
		public function read( instance: * ): * {
			try {
				return instance[ _name ];
			} catch( e: Error ) {
				return null;
			}
		}
		
		public function get bindable(): Boolean {
			return _bindable;
		}
		
		public function get observable(): Boolean {
			return _observable;
		}
		
		public function get sendingEvent(): String {
			return _sendingEvent;
		}
		
		public function get name(): QName {
			return _name;
		}
		
		public function get silent(): Boolean {
			return !_bindable && !_observable && ( _sendingEvent == null );
		}
	}
	
}
