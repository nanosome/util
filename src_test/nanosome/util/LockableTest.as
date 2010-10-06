package nanosome.util {
	
	
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.assertFalse;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class LockableTest {
		
		public static function test( instanceProvider: ITestInstanceProvider ): void {
			
			var instance: ILockable = ILockable( instanceProvider.createInstance() );
			assertFalse( instance.locked );
			instance.lock();
			assertTrue( instance.locked );
			instance.unlock();
			assertFalse( instance.locked );
		}
	}
}
