package nanosome.util.list.fnc {
	
	import flexunit.framework.TestCase;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class FunctionListTest extends TestCase {
		
		private var _list: FunctionList;
		
		override public function setUp(): void {
			_list = new FunctionList();
		}
		
		public function testArguments(): void {
			
			_list.add( trickyTest ); // Should throw no error;
			
			var errorThrown: Boolean = true;
			try {
				_list.add( false );
				errorThrown = false;
			} catch( e: Error ) {}
			
			assertTrue( "Argument of wrong type should throw an error.", errorThrown );
			
			_list.execute();
		}
		
		private function trickyTest(): void {
			assertTrue( _list.remove( trickyTest ) );
			assertFalse( _list.contains( trickyTest ) );
			assertFalse( _list.remove( trickyTest ) );
			assertTrue( _list.add( trickyTest ) );
			assertTrue( _list.contains( trickyTest ) );
			assertTrue( _list.remove( trickyTest ) );
			assertFalse( _list.contains( trickyTest ) );
			assertTrue( _list.add( trickyTest ) );
		}
	}
}
