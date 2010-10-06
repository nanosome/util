package nanosome.util {
	
	import flexunit.framework.TestCase;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class MergeArraysTest extends TestCase {
		
		public function testEmptyArray(): void {
			var empty: Array = [];
			assertObjectEquals( empty, mergeArrays( null, null ) );
			assertObjectEquals( empty, mergeArrays( null, undefined ) );
			assertObjectEquals( empty, mergeArrays( undefined, null ) );
			assertObjectEquals( empty, mergeArrays( undefined, undefined ) );
			assertObjectEquals( empty, mergeArrays( empty, null ) );
			assertTrue( empty !== mergeArrays( empty, null ) );
			assertObjectEquals( empty, mergeArrays( null, empty ) );
			assertTrue( empty !== mergeArrays( null, empty ) );
			assertObjectEquals( empty, mergeArrays( empty, undefined ) );
			assertTrue( empty !== mergeArrays( empty, undefined ) );
			assertObjectEquals( empty, mergeArrays( undefined, empty ) );
			assertTrue( empty !== mergeArrays( undefined, empty ) );
		}
		
		public function testDuplicates(): void {
			var duplicates: Array = [2,1,1,2,3,4];
			var duplicates2: Array = [2,1,3,5,6,7,8,3];
			assertObjectEquals( [1,2,3,4], mergeArrays( duplicates ).sort() );
			assertObjectEquals( [1,2,3,5,6,7,8], mergeArrays( null, duplicates2 ).sort() );
			assertObjectEquals( [1,2,3,4,5,6,7,8], mergeArrays( duplicates, duplicates2 ).sort() );
		}
		
		public function testNormal(): void {
			var unique: Array = [1,2,3];
			var unique2: Array = [3,4,5];
			var mixed: Array = [1,2,3,4,5];
			assertObjectEquals( mixed, mergeArrays( unique, unique2 ).sort() );
			assertObjectEquals( [1,2,3], unique );
			assertObjectEquals( [3,4,5], unique2 );
		}
		
	}
}
