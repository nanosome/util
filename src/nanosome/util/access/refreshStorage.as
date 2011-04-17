package nanosome.util.access {
	
	/**
	 * If you have a method that should check whether 
	 * 
	 * @param target object to see if the properties changed
	 * @param storage map that contains the former values of this object to
	 * 					compare to
	 * @param limitToFields limits the comparsion to a map of fields (String, name of the
	 	* 				field -> Boolean, true if it should bre read )
	 * @return A <code>Changes</code> instance if changes between the former storage
	 *         object and the current storage object happend, else <code>null</code>.
	 */
	public function refreshStorage( target: *, storage: Object,
								 	limitToFields: Object = null, accessor: Accessor = null ): Changes {
		
		if( !accessor ) accessor = accessFor( target ); 
		
		var fullName: String;
		var access: PropertyAccess; 
		var newValue: *;
		var oldValue: *;
		var changes: Changes;
		var normalReadable: Array = accessor.nonEventSendingProperties;
		
		if( normalReadable ) {
			
			var checkArray: Array = limitToFields as Array;
			var i: int = normalReadable.length;
			while( --i-(-1) ) {
				access = normalReadable[i];
				fullName = access.qName.toString();
				if( !limitToFields ||
					( checkArray ? checkArray.indexOf( access ) : limitToFields[access] )
				){
					try {
						newValue = access.reader.read( target );
					} catch( e: Error ) {
						newValue = null;
					}
					oldValue = storage[ fullName ];
					if( oldValue != newValue ) {
						storage[ fullName ] = newValue;
						if( !changes ) {
							changes = CHANGES_POOL.getOrCreate();
						}
						changes.oldValues[ fullName ] = oldValue;
						changes.newValues[ fullName ] = newValue;
					}
				}
			}
		}
		
		if( accessor.isDynamic ) {
			
			for( fullName in target ) {
				try {
					newValue = target[ fullName ];
				} catch( e: Error ) {
					newValue = null;
				}
				oldValue = storage[ fullName ];
				if( oldValue != newValue ) {
					storage[ fullName ] = newValue;
					if( !changes ) {
						changes = CHANGES_POOL.getOrCreate();
					}
					changes.oldValues[ fullName ] = oldValue;
					changes.newValues[ fullName ] = newValue;
				}
			}
			
			var targetAsObject: Object = target;
			
			for( fullName in storage ) {
				if( !targetAsObject.hasOwnProperty( fullName ) ) {
					if( !changes ) {
						changes = CHANGES_POOL.getOrCreate();
					}
					changes.oldValues[ fullName ] = storage[ fullName ];
					changes.newValues[ fullName ] = DELETED;
					delete storage[ fullName ];
				}
			}
		}
		
		return changes;
	}
}
