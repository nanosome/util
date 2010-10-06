package nanosome.util.access {
	
	import nanosome.util.ILockable;
	import nanosome.util.UID;
	
	public dynamic class DynamicClass extends UID implements ILockable {
		
		private var _uid: uint;
		
		public function DynamicClass( id: uint ) {
			_uid = id;
		}
		
		override public function get uid() : uint {
			return _uid;
		}
		
		public var normal: Array;
		
		public var internalClass: InternalClass;
		
		internal var internalVariable: Array;
		
		[Bindable]
		public var bindable: Array;
		
		private var _observable: Array;
		
		[Observable]
		public function get observable(): Array {
			return _observable;
		}
		
		public function set observable( observable: Array ): void {
			_observable = observable;
		}
		
		public var wasLocked: Boolean;
		public var wasUnlocked: Boolean;
		
		public function set locked(locked : Boolean) : void {
			if( locked != _locked ) {
				if( locked ) {
					wasLocked = true;
					wasUnlocked = false;
				} else if( wasLocked ) {
					wasUnlocked = true;
				}
			}
			_locked = locked;
		}
		
		public function get locked(): Boolean {
			return _locked;
		}
		
		public function lock(): void {
			locked = true;
		}
		
		public function unlock(): void {
			locked = false;
		}
		
		private var _locked: Boolean;
	}
}

class InternalClass {
}