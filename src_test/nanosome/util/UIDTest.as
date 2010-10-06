package nanosome.util {
	
	
	
	import org.flexunit.Assert;

	import flexunit.framework.TestCase;
	
	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class UIDTest extends TestCase implements ITestInstanceProvider {
		
		public static function test( uidTestProvider: ITestInstanceProvider ): void {
			var id: uint = UID.next();
			var instance: IUID = IUID( uidTestProvider.createInstance() );
			Assert.failNotEquals( "Global UID doesn't increase", id+1, instance.uid );
			var newId: uint = UID.next();
			Assert.failNotEquals( "Global UID doesn't increase properly", newId, id+2 );
			var instance2: IUID = IUID( uidTestProvider.createInstance() );
			Assert.failNotEquals( "The instances id changes", instance.uid, instance.uid );
			Assert.assertTrue( "Two instances have to have different ids", instance.uid !== instance2.uid);
			
			if( instance is IDisposable ) {
				var uid: int = instance.uid;
				IDisposable( instance ).dispose();
				Assert.assertEquals( uid, instance.uid );
			}
		}
		
		public function createInstance() : * {
			return new UID;
		}
		
		public function testInterfaceTests(): void {
			UIDTest.test( this );
		}
	}
}
