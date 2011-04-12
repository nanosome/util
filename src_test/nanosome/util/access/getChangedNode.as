package nanosome.util.access {
	import nanosome.util.ChangedPropertyNode;
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function getChangedNode( oldValues: Object, newValues: Object ): ChangedPropertyNode {
		var first: ChangedPropertyNode;
		var last: ChangedPropertyNode;
		for( var name: * in newValues ) {
			var next: ChangedPropertyNode = pool.getOrCreate();
			next.name = qname( name );
			next.newValue = newValues[ name ];
			next.oldValue = oldValues[ name ];
			
			if( !first ) first = next;
			next.addTo( last );
			last = next;
		}
		return first;
	}
}

import nanosome.util.ChangedPropertyNode;
import nanosome.util.pool.IInstancePool;
import nanosome.util.pool.poolFor;

const pool: IInstancePool = poolFor( ChangedPropertyNode );