package nanosome.util.access {
	import nanosome.util.list.List;
	import nanosome.util.pool.POOL_STORAGE;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class StaticClass1 extends List{
		
		public var test: String;

		public function StaticClass1() {
			super(POOL_STORAGE.getOrCreate(StaticClass1));
		}
		
		private var _te: uint;
		
		public function test2(): void {
			_te;
		}
	}
}
