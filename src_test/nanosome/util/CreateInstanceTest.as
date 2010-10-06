package nanosome.util {
	
	import flexunit.framework.TestCase;
	/**
	 * @author Martin Heidegger
	 */
	public class CreateInstanceTest extends TestCase{
		
		public function testOptionalArguments(): void {
			var inst : ConstructOptional = createInstance(ConstructOptional);
			assertEquals( 0, inst._p1 );
			assertEquals( 2, inst._p2 );
		}
		
		public function testAnnonymousConstruction(): void {
			
			assertNotNull( createInstance( Constructor0 ) );
			assertNotNull( createInstance( Constructor1 ) );
			assertNotNull( createInstance( Constructor2 ) );
			assertNotNull( createInstance( Constructor3 ) );
			assertNotNull( createInstance( Constructor4 ) );
			assertNotNull( createInstance( Constructor5 ) );
			assertNotNull( createInstance( Constructor6 ) );
			assertNotNull( createInstance( Constructor7 ) );
			assertNotNull( createInstance( Constructor8 ) );
			assertNotNull( createInstance( Constructor9 ) );
			assertNotNull( createInstance( Constructor10 ) );
			assertNotNull( createInstance( Constructor11 ) );
			assertNotNull( createInstance( Constructor12 ) );
			
			var error: Boolean = false;
			try {
				assertNotNull( createInstance( Constructor13 ) );
			} catch( e: Error ) {
				error = true;
			}
			assertTrue( error );
		}
		
	}
}

class Constructor0 {}

class Constructor1 {
	public function Constructor1( p: int ) {}
}

class Constructor2 {
	public function Constructor2( p1: int, p2: int ) {}
}

class Constructor3 {
	public function Constructor3( p1: int, p2: int, p3: int ) {}
}

class Constructor4 {
	public function Constructor4( p1: int, p2: int, p3: int, p4: int ) {}
}

class Constructor5 {
	public function Constructor5( p1: int, p2: int, p3: int, p4: int, p5: int ) {}
}

class Constructor6 {
	public function Constructor6( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int ) {}
}

class Constructor7 {
	public function Constructor7( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int ) {}
}

class Constructor8 {
	public function Constructor8( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int, p8: int ) {}
}

class Constructor9 {
	public function Constructor9( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int, p8: int, p9: int ) {}
}

class Constructor10 {
	public function Constructor10( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int, p8: int, p9: int, p10: int ) {}
}

class Constructor11 {
	public function Constructor11( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int, p8: int, p9: int, p10: int, p11: int ) {}
}

class Constructor12 {
	public function Constructor12( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int, p8: int, p9: int, p10: int, p11: int, p12: int ) {}
}

class Constructor13 {
	public function Constructor13( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int, p8: int, p9: int, p10: int, p11: int, p12: int, p13: int ) {}
}

class Constructor14 {
	public function Constructor14( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int, p8: int, p9: int, p10: int, p11: int, p12: int, p13: int, p14: int ) {}
}

class ConstructOptional {
	internal var _p2 : int;
	internal var _p1 : int;
	
	public function ConstructOptional( p: int, p2: int = 2 ) {
		_p1 = p;
		_p2 = p2;
	}
}