package nanosome.util.pool {
	import nanosome.util.IDisposable;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class PoolTestClass implements IDisposable {
		public static var lastInstance : *;

		public function PoolTestClass() {
			lastInstance = this;
		}
		
		public function dispose() : void {
			lastInstance = null;
		}
	}
}
