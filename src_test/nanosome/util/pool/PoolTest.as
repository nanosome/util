package nanosome.util.pool {
	
	
	import flexunit.framework.TestCase;

	import nanosome.util.EnterFrame;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class PoolTest extends TestCase {
		
		private var _p: InstancePool;
		private var _async: Function;
		
		override public function setUp(): void {
			_p = pools.getOrCreate( PoolTestClass );
			_p.clean( int.MAX_VALUE );
		}
		
		public function testGetOrCreate(): void {
			assertEquals( _p, pools.getOrCreate( PoolTestClass ) );
		}
		
		public function testPool(): void {
			var i: PoolTestClass = _p.getOrCreate();
			
			assertStrictlyEquals( i, PoolTestClass.lastInstance );
			_p.returnInstance( i );
			assertNull( PoolTestClass.lastInstance );
			_async = addAsync( function(): void {}, 1000 );
			EnterFrame.add( next );
		}
		
		public function next(): void {
			assertNull( PoolTestClass.lastInstance );
			_async( null );
			EnterFrame.remove( next );
		}
	}
}
