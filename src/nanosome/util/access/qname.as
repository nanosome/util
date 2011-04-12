package nanosome.util.access {
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function qname( input: * ): QName {
		var q: QName = input as QName;
		var str: String;
		if( q ) {
			str = QName( input ).toString();
			q = storage[ str ] || ( storage[ str ] = q );
		} else {
			str = input as String;
			q = storage[ str ];
			if( !q ) {
				var pos: int = str.indexOf("::");
				if( pos == -1 ) {
					q = new QName( "", str );
				} else {
					q = new QName( str.substr( 0, pos ), str.substr( pos + 2 ) );
				}
				storage[ str ] = q;
			}
		}
		return q;
	}
}
const storage: Object = {};