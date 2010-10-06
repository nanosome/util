package nanosome.util.list {
	import flexunit.framework.TestCase;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class ListTest extends TestCase {
		
		private var _list : ExampleList;
		private var _a : Object;
		private var _b : Object;
		private var _c : Object;
		private var _d : Object;
		
		override public function setUp() : void {
			_list = new ExampleList();
			_a = {};
			_b = {};
			_c = {};
			_d = {};
		}
		
		public function testAddRemoveInIteration(): void {
			assertEquals( _list.iterate(), null );
			assertEquals( _list.iterate(), null );
			_list.add( _a );
			assertEquals( _list.iterate(), _a );
			assertEquals( _list.iterate(), null );
			assertEquals( _list.iterate(), _a );
			_list.add( _b );
			assertEquals( _list.iterate(), _b );
			assertEquals( _list.iterate(), null );
			assertEquals( _list.iterate(), _a );
			assertEquals( _list.iterate(), _b );
			_list.remove( _b );
			assertEquals( _list.iterate(), null );
			_list.add( _b );
			_list.add( _c );
			assertEquals( _list.iterate(), _a );
			assertEquals( _list.iterate(), _b );
			assertEquals( _list.iterate(), _c );
			assertEquals( _list.iterate(), null );
			assertEquals( _list.iterate(), _a );
			_list.remove( _b );
			assertEquals( _list.iterate(), _c );
			assertEquals( _list.iterate(), null );
			
			_list.add( _c );
			assertEquals( _list.iterate(), _a );
			assertEquals( _list.iterate(), _c );
			assertEquals( _list.iterate(), null );
		}
		
		public function testNormalAddRemoveFunctionality(): void {
			assertTrue( _list.empty );
			assertTrue( _list.add( _a ) );
			assertFalse( _list.empty );
			assertObjectEquals( _list.allNormal, [ _a ] );
			assertTrue( _list.contains( _a ) );
			assertFalse( _list.add( _a ) );
			assertObjectEquals( _list.allNormal, [ _a ] );
			assertEquals( _a, _list.iterate() );
			assertEquals( null, _list.iterate() );
			assertEquals( _a, _list.iterate() );
			assertEquals( null, _list.iterate() );
			assertFalse( _list.empty );
			assertTrue( _list.add( _b ) );
			assertObjectEquals( _list.allNormal, [ _a, _b ] );
			assertTrue( _list.size, 2 );
			assertFalse( _list.add( _b ) );
			assertTrue( _list.size, 2 );
			assertTrue( _list.contains( _b ) );
			assertObjectEquals( _list.allNormal, [ _a, _b ] );
			assertTrue( _list.remove( _b ) );
			assertObjectEquals( _list.allNormal, [ _a ] );
			assertFalse( _list.remove( _b ) );
			assertObjectEquals( _list.allNormal, [ _a ] );
			assertTrue( _list.remove( _a ) );
			assertObjectEquals( _list.allNormal, [] );
			assertEquals( _list.size, 0 );
			assertFalse( _list.contains( _a ) );
			assertFalse( _list.remove( _a ) );
			assertFalse( _list.contains( _a ) );
			assertEquals( _list.iterate(), null );
			assertEquals( _list.iterate(), null);
		}
		
		public function testWeakOperations(): void {
			assertTrue( _list.empty );
			assertFalse( _list.isWeakAdded( _a ) );
			
			assertTrue( _list.add( _a, true ) );
			assertFalse( _list.empty );
			assertEquals( 1, _list.size );
			assertTrue( _list.isWeakAdded( _a ) );
			assertTrue( _list.contains( _a ) );
			
			assertTrue( _list.remove( _a ) );
			assertTrue( _list.empty );
			assertFalse( _list.isWeakAdded( _a ) );
			assertFalse( _list.contains( _a ) );
			assertEquals( 0, _list.size );
			
			assertTrue( _list.add( _a, true ) );
			assertFalse( _list.add( _a, true ) );
			assertTrue( _list.add( _a, false ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertTrue( _list.contains( _a ) );
			
			assertTrue( _list.add( _b, true ) );
			assertFalse( _list.empty );
			assertTrue( _list.isWeakAdded( _b ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertTrue( _list.contains( _b ) );
			assertTrue( _list.contains( _a ) );
			assertEquals( 2, _list.size );
			
			assertTrue( _list.remove( _a ) );
			assertFalse( _list.empty );
			assertTrue( _list.isWeakAdded( _b ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertTrue( _list.contains( _b ) );
			assertFalse( _list.contains( _a ) );
			assertEquals( 1, _list.size );
			
			assertTrue( _list.add( _c, true ) );
			assertEquals( 2, _list.size );
			assertTrue( _list.isWeakAdded( _b ) );
			assertTrue( _list.isWeakAdded( _c ) );
			assertFalse( _list.empty );
			
			assertTrue( _list.add( _c, false ) );
			assertEquals( 2, _list.size );
			assertFalse( _list.isWeakAdded( _c ) );
			assertTrue( _list.isWeakAdded( _b ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertFalse( _list.empty );
		}
		
		public function testWhileIteration(): void {
			// Assure that in a locked state works 
			// adding like expected
			_list.pseudoIterate();
			assertTrue( _list.add( _a ) );
			assertEquals( 1, _list.size );
			assertFalse( _list.empty );
			assertTrue( _list.contains( _a ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertFalse( _list.add( _a ) );
			_list.pseudoStopIterate();
			
			assertObjectEquals( _list.allNormal, [ _a ] );
			
			// Assure that after unlocking the values are properly in the list
			assertEquals( 1, _list.size );
			assertFalse( _list.empty );
			assertFalse( _list.isWeakAdded( _a ) );
			assertTrue( _list.contains( _a ) );
			
			// Assure that locking and adding works right after each other
			_list.pseudoIterate();
			assertFalse( _list.add( _a ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertTrue( _list.add( _a, true ) );
			assertTrue( _list.isWeakAdded( _a ) );
			assertFalse( _list.add( _a, true ) );
			assertTrue( _list.isWeakAdded( _a ) );
			assertTrue( _list.add( _a ) );
			assertFalse( _list.isWeakAdded( _a ) );
			_list.pseudoStopIterate();
			
			_list.add( _b );
			
			assertObjectEquals( _list.allNormal, [ _a, _b ] );
			
			assertFalse( _list.isWeakAdded( _b ) );
			assertFalse( _list.isWeakAdded( _a ) );
			
			// Assure that during lock state, removing works
			_list.pseudoIterate();
			assertTrue( _list.remove( _a ) );
			assertEquals( 1, _list.size );
			assertFalse( _list.empty );
			assertFalse( _list.contains( _a ) );
			assertFalse( _list.remove( _a ) );
			_list.pseudoStopIterate();
			
			assertObjectEquals( _list.allNormal, [ _b ] );
			
			// Assure mixed-ins of lock state, weak reference changes work properly
			_list.pseudoIterate();
			assertTrue( _list.add( _c, true ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertFalse( _list.isWeakAdded( _b ) );
			assertTrue( _list.isWeakAdded( _c ) );
			assertTrue( _list.remove( _b ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertFalse( _list.isWeakAdded( _b ) );
			assertTrue( _list.isWeakAdded( _c ) );
			assertEquals( 1, _list.size );
			assertTrue( _list.add( _c, false ) );
			assertFalse( _list.isWeakAdded( _a ) );
			assertFalse( _list.isWeakAdded( _b ) );
			assertFalse( _list.isWeakAdded( _c ) );
			assertEquals( 1, _list.size );
			_list.pseudoStopIterate();
			
			assertObjectEquals( _list.allNormal, [ _c ] );
			
			_list.pseudoIterate();
			_list.add( _a, true );
			assertTrue( _list.isWeakAdded( _a ) );
			_list.pseudoStopIterate();
			
			assertObjectEquals( _list.allNormal, [ _c ] );
			assertObjectEquals( _list.allWeak, [ _a ] );
			
			assertTrue( _list.isWeakAdded( _a ) );
			_list.remove( _a );
			
			assertTrue( _list.add( _c, true ) );
			assertTrue( _list.isWeakAdded( _c ) );
			
			// Assure locking really works for iteration
			_list.add( _b );
			_list.pseudoIterate();
			assertObjectEquals( _list.allWeak, [ _c ] );
			assertObjectEquals( _list.allNormal, [ _b ] );
			_list.remove( _c );
			assertObjectEquals( _list.allWeak, [] );
			_list.add( _c, true );
			assertObjectEquals( _list.allWeak, [] );
			_list.remove( _b );
			assertObjectEquals( _list.allNormal, [] );
			_list.add( _b );
			assertObjectEquals( _list.allNormal, [] );
			_list.pseudoStopIterate();
			
			assertObjectEquals( _list.allWeak, [ _c ] );
			assertObjectEquals( _list.allNormal, [ _b ] );
		}
	}
}
