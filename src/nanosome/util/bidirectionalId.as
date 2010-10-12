package nanosome.util {
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public function bidirectionalId( uidA: IUID, uidB: IUID ): String {
		if( uidA.uid < uidB.uid ) {
			return uidA.uid + "x" + uidB.uid;
		} else {
			return uidB.uid + "x" + uidA.uid;
		}
	}
}
