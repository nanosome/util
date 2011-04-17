package nanosome.util.access {
	
	import nanosome.util.ChangedPropertyNode;
	import nanosome.util.ILockable;
	
	/**
	 * Fills, like <code>writeAll</code>, a instance with all passed
	 * in properties by using a change-property-node-list.
	 * 
	 * @param target target instance that should be written to
	 * @param changed Nodes that were changed
	 * @param map Mapping of the changed properties to the object properties
	 * @return list of properties that couldn't be written (unmapped, as in the
	 *          ChangedPropertyNode), null if all could have
	 * @see IPropertyObserver
	 */
	public function writeAllByNodes( target: *, changed: ChangedPropertyNode,
									 map: Object = null, accessor: Accessor = null ): Array {
		if( !accessor ) {
			accessor = accessFor( target );
		}
		var doUnlock: Boolean = false;
		if( accessor.isLockable ) {
			const lockable: ILockable = ILockable( target );
			if( !lockable.locked ) {
				doUnlock = true;
				lockable.lock();
			}
		}
		
		var failed: Array = null;
		var i: int = 0;
		var prop: PropertyAccess;
		
		if( map ) {
			while( changed ) {
				prop = accessor.prop( map[ changed.name.toString() ] );
				if( !prop || !prop.writer.write( target, changed.newValue ) ) {
					( failed || (failed = []) )[ i++ ] = changed.name;
				};
				changed = changed.next;
			}
		} else {
			while( changed ) {
				prop = accessor.prop( changed.name );
				if( !prop || !prop.writer.write( target, changed.newValue ) ) {
					( failed || (failed = []) )[ i++ ] = changed.name;
				};
				changed = changed.next;
			}
		}
		
		if( doUnlock ) lockable.unlock();
		
		return failed;
	}
}
