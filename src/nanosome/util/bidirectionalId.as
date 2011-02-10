// @license@ 
package nanosome.util {
	/**
	 * This fairly simple util helps to store a value to two <code>IUID</code>s.
	 * 
	 * <p>When you want to store simple information like: Is "A" connected
	 * to "B" you might need many dictionaries and difficult code to store it, in
	 * case both are anonymous. Here is a example of how this could go wrong:</p>
	 * 
	 * <listing version="3">
	 * private const infos: Dictionary = new Dictionary(); 
	 * public function storeInfo( A: Object, B: Object, info: Object ): void {
	 *   var infosA: Dictionary = infos[A] || ( infos[A] = new Dictionary() );
	 *   var infosB: Dictionary = infos[B] || ( infos[B] = new Dictionary() );
	 *   infosA[B] = info;
	 *   infosB[A] = info;
	 * }
	 * public function getInfo( A: Object, B: Object ): Object {
	 *   if( infos[A] ) {
	 *     return infos[A][B];
	 *   }
	 *   return null;
	 * }
	 * public function removeInfo( A: Object, B: Object ): void {
	 *   var infosA: Dictionary = infos[A];
	 *   var infosB: Dictionary = infos[B];
	 *   var found: Boolean;
	 *   var field: Object;
	 *   if( infosA ) {
	 *     delete infosA[B];
	 *     // Its necessary to clear the dictionary if empty now
	 *     found = false;
	 *     for( field in infosA ) {
	 *       found = true;
	 *       break;
	 *     }
	 *     if( !found ) {
	 *       delete infos[A]
	 *     }
	 *   }
	 *   // same for the other dictionary
	 *   if( infosB ) {
	 *     delete infosB[A];
	 *     found = false;
	 *     for( field in infosB ) {
	 *       found = true;
	 *       break;
	 *     }
	 *     if( !found ) {
	 *       delete infos[B]
	 *     }
	 *   }
	 * }
	 * </listing>
	 * 
	 * <p>Now - Thats a lot of code! With bidirectionial ids of <code>IUID</code>
	 * instances the same functionality might look like this:</p>
	 * 
	 * <listing version="3">
	 * private const infos: Dictionary = new Dictionary();
	 * public function storeInfo( A: IUID, B: IUID, info: Object ): Object {
	 *   infos[ bidirectionalId( A, B ) ] = info;
	 * }
	 * public function getInfo( A: IUID, B: IUID ): Object {
	 *   return infos[ bidirectionalId( A, B ) ];
	 * }
	 * public function removeInfo( A: IUID, B: IUID ): void {
	 *   delete infos[ bidirectionalId( A, B ) ];
	 * }
	 * </listing>
	 * 
	 * <p>As you can see this is a lot simpler and doesnt consume that much processing
	 * power.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @param uidA First <code>IUID</code> to be mingled
	 * @param uidB Second <code>IUID</code> to be mingled
	 * @return String that identifies both ids
	 * @see nanosome.util.IUID
	 */
	public function bidirectionalId( uidA: IUID, uidB: IUID ): String {
		if( uidA.uid < uidB.uid ) {
			return uidA.uid + "x" + uidB.uid;
		} else {
			return uidB.uid + "x" + uidA.uid;
		}
	}
}
