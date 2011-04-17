package nanosome.util.access {
	import nanosome.util.ILockable;
		
	/**
	 * Writes all passed-in properties to the target
	 * 
	 * <p>This method call will automatically lock the target before setting
	 * the first property and unlock it afterwards (if it wasn't locked before).</p>
	 * 
	 * @param target target that should be modified.
	 * @param properties Object that maps property-names to values to be set
	 * @return list of nodes that couldn't be written, null if all could have
	 */
	public function writeAll( target: *, properties: Object, accessor: Accessor = null ): Array {
		if( !accessor ) {
			accessor = accessFor( target );
		}
		if( target && properties ) {
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
			
			for( var propertyName: * in properties ) {
				var prop: PropertyAccess = accessor.prop( propertyName );
				if( !prop || !prop.writer.write( target, properties[ propertyName ] ) ) {
					( failed || (failed = []) )[ i++ ] = qname( propertyName );
				}
			}
			
			if( doUnlock ) lockable.unlock();
			
			return failed;
		}
		return null;
	}
}
