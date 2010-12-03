package nanosome.util.normalize {
	import flexunit.framework.TestCase;

	/**
	 * @author mh
	 */
	public class NormalizeCosinusTest extends TestCase {
		
		private var _map: NormalizeCosinus;
		
		override public function setUp(): void {
			_map = COSINUS;
		}
		
		public function testCosinusMapping(): void {
			assertEquals( _map.to( 0.1 ) , Math.cos( 0.1 ) );
			assertEquals( _map.to( 0.256 ) , Math.cos( 0.256 ) );
			assertEquals( _map.from( 0.156 ) , Math.acos( 0.156 ) );
			assertEquals( _map.from( 0.2 ) , Math.acos( 0.2 ) );
		}
		
		public function testBlindMapping(): void {
			for( var i: Number = 0.0; i<=1.0; i+= 0.025 ) {
				var result: Number = _map.from( _map.to( i ) );
				assertTrue( i > result - 0.001 && i < result + 0.001 );
			}
			for( i = 0.0; i<=1.0; i+= 0.025 ) {
				result = _map.to( _map.from( i ) );
				assertTrue( i > result - 0.001 && i < result + 0.001 );
			}
		}
		
		
		override public function tearDown(): void {
			_map = null;
		}
	}
}
