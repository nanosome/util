package nanosome.util {
	
	import flexunit.framework.TestCase;
	/**
	 * @author Martin Heidegger
	 */
	public class CreateInstanceTest extends TestCase{
		
		public function testOptionalArguments(): void {
			var inst : ConstructOptional = create( ConstructOptional);
			assertEquals( 0, inst._p1 );
			assertEquals( 2, inst._p2 );
		}
		
		public function testArguments(): void {
			var a1: Constructor1 = create( Constructor1, null, [1] );
			assertEquals( a1.p, 1 );
			var a2: Constructor2 = create( Constructor2, null, [1,2] );
			assertEquals( a2.p1, 1 );
			assertEquals( a2.p2, 2 );
			var a3: Constructor3 = create( Constructor3, null, [1,2,3] );
			assertEquals( a3.p1, 1 );
			assertEquals( a3.p2, 2 );
			assertEquals( a3.p3, 3 );
			var a4: Constructor4 = create( Constructor4, null, [1,2,3,4] );
			assertEquals( a4.p1, 1 );
			assertEquals( a4.p2, 2 );
			assertEquals( a4.p3, 3 );
			assertEquals( a4.p4, 4 );
			var a5: Constructor5 = create( Constructor5, null, [1,2,3,4,5] );
			assertEquals( a5.p1, 1 );
			assertEquals( a5.p2, 2 );
			assertEquals( a5.p3, 3 );
			assertEquals( a5.p4, 4 );
			assertEquals( a5.p5, 5 );
			var a6: Constructor6 = create( Constructor6, null, [1,2,3,4,5,6] );
			assertEquals( a6.p1, 1 );
			assertEquals( a6.p2, 2 );
			assertEquals( a6.p3, 3 );
			assertEquals( a6.p4, 4 );
			assertEquals( a6.p5, 5 );
			assertEquals( a6.p6, 6 );
			var a7: Constructor7 = create( Constructor7, null, [1,2,3,4,5,6,7] );
			assertEquals( a7.p1, 1 );
			assertEquals( a7.p2, 2 );
			assertEquals( a7.p3, 3 );
			assertEquals( a7.p4, 4 );
			assertEquals( a7.p5, 5 );
			assertEquals( a7.p6, 6 );
			assertEquals( a7.p7, 7 );
			var a8: Constructor8 = create( Constructor8, null, [1,2,3,4,5,6,7,8] );
			assertEquals( a8.p1, 1 );
			assertEquals( a8.p2, 2 );
			assertEquals( a8.p3, 3 );
			assertEquals( a8.p4, 4 );
			assertEquals( a8.p5, 5 );
			assertEquals( a8.p6, 6 );
			assertEquals( a8.p7, 7 );
			assertEquals( a8.p8, 8 );
			var a9: Constructor9 = create( Constructor9, null, [1,2,3,4,5,6,7,8,9] );
			assertEquals( a9.p1, 1 );
			assertEquals( a9.p2, 2 );
			assertEquals( a9.p3, 3 );
			assertEquals( a9.p4, 4 );
			assertEquals( a9.p5, 5 );
			assertEquals( a9.p6, 6 );
			assertEquals( a9.p7, 7 );
			assertEquals( a9.p8, 8 );
			assertEquals( a9.p9, 9 );
			var a10: Constructor10 = create( Constructor10, null, [1,2,3,4,5,6,7,8,9,10] );
			assertEquals( a10.p1, 1 );
			assertEquals( a10.p2, 2 );
			assertEquals( a10.p3, 3 );
			assertEquals( a10.p4, 4 );
			assertEquals( a10.p5, 5 );
			assertEquals( a10.p6, 6 );
			assertEquals( a10.p7, 7 );
			assertEquals( a10.p8, 8 );
			assertEquals( a10.p9, 9 );
			assertEquals( a10.p10, 10 );
			var a11: Constructor11 = create( Constructor11, null, [1,2,3,4,5,6,7,8,9,10,11] );
			assertEquals( a11.p1, 1 );
			assertEquals( a11.p2, 2 );
			assertEquals( a11.p3, 3 );
			assertEquals( a11.p4, 4 );
			assertEquals( a11.p5, 5 );
			assertEquals( a11.p6, 6 );
			assertEquals( a11.p7, 7 );
			assertEquals( a11.p8, 8 );
			assertEquals( a11.p9, 9 );
			assertEquals( a11.p10, 10 );
			assertEquals( a11.p11, 11 );
			var a12: Constructor12 = create( Constructor11, null, [1,2,3,4,5,6,7,8,9,10,11,12] );
			assertEquals( a12.p1, 1 );
			assertEquals( a12.p2, 2 );
			assertEquals( a12.p3, 3 );
			assertEquals( a12.p4, 4 );
			assertEquals( a12.p5, 5 );
			assertEquals( a12.p6, 6 );
			assertEquals( a12.p7, 7 );
			assertEquals( a12.p8, 8 );
			assertEquals( a12.p9, 9 );
			assertEquals( a12.p10, 10 );
			assertEquals( a12.p11, 11 );
			assertEquals( a12.p12, 12 );
		}
		
		public function testParams(): void {
			var a1: Constructor1 = create( Constructor1, {p:1} );
			assertEquals( a1.p, 1 );
			var a2: Constructor2 = create( Constructor2, {p1:1,p2:2} );
			assertEquals( a2.p1, 1 );
			assertEquals( a2.p2, 2 );
			var a3: Constructor3 = create( Constructor3, {p1:1,p2:2,p3:3} );
			assertEquals( a3.p1, 1 );
			assertEquals( a3.p2, 2 );
			assertEquals( a3.p3, 3 );
			var a4: Constructor4 = create( Constructor4, {p1:1,p2:2,p3:3,p4:4} );
			assertEquals( a4.p1, 1 );
			assertEquals( a4.p2, 2 );
			assertEquals( a4.p3, 3 );
			assertEquals( a4.p4, 4 );
			var a5: Constructor5 = create( Constructor5, {p1:1,p2:2,p3:3,p4:4,p5:5} );
			assertEquals( a5.p1, 1 );
			assertEquals( a5.p2, 2 );
			assertEquals( a5.p3, 3 );
			assertEquals( a5.p4, 4 );
			assertEquals( a5.p5, 5 );
			var a6: Constructor6 = create( Constructor6, {p1:1,p2:2,p3:3,p4:4,p5:5,p6:6} );
			assertEquals( a6.p1, 1 );
			assertEquals( a6.p2, 2 );
			assertEquals( a6.p3, 3 );
			assertEquals( a6.p4, 4 );
			assertEquals( a6.p5, 5 );
			assertEquals( a6.p6, 6 );
			var a7: Constructor7 = create( Constructor7, {p1:1,p2:2,p3:3,p4:4,p5:5,p6:6,p7:7} );
			assertEquals( a7.p1, 1 );
			assertEquals( a7.p2, 2 );
			assertEquals( a7.p3, 3 );
			assertEquals( a7.p4, 4 );
			assertEquals( a7.p5, 5 );
			assertEquals( a7.p6, 6 );
			assertEquals( a7.p7, 7 );
			var a8: Constructor8 = create( Constructor8, {p1:1,p2:2,p3:3,p4:4,p5:5,p6:6,p7:7,p8:8} );
			assertEquals( a8.p1, 1 );
			assertEquals( a8.p2, 2 );
			assertEquals( a8.p3, 3 );
			assertEquals( a8.p4, 4 );
			assertEquals( a8.p5, 5 );
			assertEquals( a8.p6, 6 );
			assertEquals( a8.p7, 7 );
			assertEquals( a8.p8, 8 );
			var a9: Constructor9 = create( Constructor9, {p1:1,p2:2,p3:3,p4:4,p5:5,p6:6,p7:7,p8:8,p9:9} );
			assertEquals( a9.p1, 1 );
			assertEquals( a9.p2, 2 );
			assertEquals( a9.p3, 3 );
			assertEquals( a9.p4, 4 );
			assertEquals( a9.p5, 5 );
			assertEquals( a9.p6, 6 );
			assertEquals( a9.p7, 7 );
			assertEquals( a9.p8, 8 );
			assertEquals( a9.p9, 9 );
			var a10: Constructor10 = create( Constructor10, {p1:1,p2:2,p3:3,p4:4,p5:5,p6:6,p7:7,p8:8,p9:9,p10:10} );
			assertEquals( a10.p1, 1 );
			assertEquals( a10.p2, 2 );
			assertEquals( a10.p3, 3 );
			assertEquals( a10.p4, 4 );
			assertEquals( a10.p5, 5 );
			assertEquals( a10.p6, 6 );
			assertEquals( a10.p7, 7 );
			assertEquals( a10.p8, 8 );
			assertEquals( a10.p9, 9 );
			assertEquals( a10.p10, 10 );
			var a11: Constructor11 = create( Constructor11, {p1:1,p2:2,p3:3,p4:4,p5:5,p6:6,p7:7,p8:8,p9:9,p10:10,p11:11} );
			assertEquals( a11.p1, 1 );
			assertEquals( a11.p2, 2 );
			assertEquals( a11.p3, 3 );
			assertEquals( a11.p4, 4 );
			assertEquals( a11.p5, 5 );
			assertEquals( a11.p6, 6 );
			assertEquals( a11.p7, 7 );
			assertEquals( a11.p8, 8 );
			assertEquals( a11.p9, 9 );
			assertEquals( a11.p10, 10 );
			assertEquals( a11.p11, 11 );
			var a12: Constructor12 = create( Constructor11, {p1:1,p2:2,p3:3,p4:4,p5:5,p6:6,p7:7,p8:8,p9:9,p10:10,p11:11,p12:12} );
			assertEquals( a12.p1, 1 );
			assertEquals( a12.p2, 2 );
			assertEquals( a12.p3, 3 );
			assertEquals( a12.p4, 4 );
			assertEquals( a12.p5, 5 );
			assertEquals( a12.p6, 6 );
			assertEquals( a12.p7, 7 );
			assertEquals( a12.p8, 8 );
			assertEquals( a12.p9, 9 );
			assertEquals( a12.p10, 10 );
			assertEquals( a12.p11, 11 );
			assertEquals( a12.p12, 12 );
		}
		
		public function testAnnonymousConstruction(): void {
			assertNotNull( create( Constructor0 ) );
			assertNotNull( create( Constructor1 ) );
			assertNotNull( create( Constructor2 ) );
			assertNotNull( create( Constructor3 ) );
			assertNotNull( create( Constructor4 ) );
			assertNotNull( create( Constructor5 ) );
			assertNotNull( create( Constructor6 ) );
			assertNotNull( create( Constructor7 ) );
			assertNotNull( create( Constructor8 ) );
			assertNotNull( create( Constructor9 ) );
			assertNotNull( create( Constructor10 ) );
			assertNotNull( create( Constructor11 ) );
			assertNotNull( create( Constructor12 ) );
			
			var error: Boolean = false;
			try {
				assertNotNull( create( Constructor13 ) );
			} catch( e: Error ) {
				error = true;
			}
			assertTrue( error );
		}
		
	}
}

class Constructor0 {}

class Constructor1 {
	public var p: int;
	
	public function Constructor1( p: int ) {
		this.p = p;
	}
}

class Constructor2 {
	public var p1: int;
	public var p2: int;
	public function Constructor2( p1: int, p2: int ) {
		this.p1 = p1;
		this.p2 = p2;
	}
}

class Constructor3 {
	public var p1: int;
	public var p2: int;
	public var p3: int;
	public function Constructor3( p1: int, p2: int, p3: int ) {
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
	}
}

class Constructor4 {
	public var p1: int;
	public var p2: int;
	public var p3: int;
	public var p4: int;
	public function Constructor4( p1: int, p2: int, p3: int, p4: int ) {
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
		this.p4 = p4;
	}
}

class Constructor5 {
	public var p1: int;
	public var p2: int;
	public var p3: int;
	public var p4: int;
	public var p5: int;
	public function Constructor5( p1: int, p2: int, p3: int, p4: int, p5: int ) {
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
		this.p4 = p4;
		this.p5 = p5;
	}
}

class Constructor6 {
	public var p1: int;
	public var p2: int;
	public var p3: int;
	public var p4: int;
	public var p5: int;
	public var p6: int;
	public function Constructor6( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int ) {
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
		this.p4 = p4;
		this.p5 = p5;
		this.p6 = p6;
	}
}

class Constructor7 {
	public var p1: int;
	public var p2: int;
	public var p3: int;
	public var p4: int;
	public var p5: int;
	public var p6: int;
	public var p7: int;
	public function Constructor7( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int ) {
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
		this.p4 = p4;
		this.p5 = p5;
		this.p6 = p6;
		this.p7 = p7;
	}
}

class Constructor8 {
	public var p1: int;
	public var p2: int;
	public var p3: int;
	public var p4: int;
	public var p5: int;
	public var p6: int;
	public var p7: int;
	public var p8: int;
	public function Constructor8( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int, p8: int ) {
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
		this.p4 = p4;
		this.p5 = p5;
		this.p6 = p6;
		this.p7 = p7;
		this.p8 = p8;
	}
}

class Constructor9 {
	public var p1: int;
	public var p2: int;
	public var p3: int;
	public var p4: int;
	public var p5: int;
	public var p6: int;
	public var p7: int;
	public var p8: int;
	public var p9: int;
	public function Constructor9( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int, p8: int, p9: int ) {
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
		this.p4 = p4;
		this.p5 = p5;
		this.p6 = p6;
		this.p7 = p7;
		this.p8 = p8;
		this.p9 = p9;
	}
}

class Constructor10 {
	public var p1: int;
	public var p2: int;
	public var p3: int;
	public var p4: int;
	public var p5: int;
	public var p6: int;
	public var p7: int;
	public var p8: int;
	public var p9: int;
	public var p10: int;
	public function Constructor10( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int, p8: int, p9: int, p10: int ) {
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
		this.p4 = p4;
		this.p5 = p5;
		this.p6 = p6;
		this.p7 = p7;
		this.p8 = p8;
		this.p9 = p9;
		this.p10 = p10;
	}
}

class Constructor11 {
	public var p1: int;
	public var p2: int;
	public var p3: int;
	public var p4: int;
	public var p5: int;
	public var p6: int;
	public var p7: int;
	public var p8: int;
	public var p9: int;
	public var p10: int;
	public var p11: int;
	public function Constructor11( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int, p8: int, p9: int, p10: int, p11: int ) {
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
		this.p4 = p4;
		this.p5 = p5;
		this.p6 = p6;
		this.p7 = p7;
		this.p8 = p8;
		this.p9 = p9;
		this.p10 = p10;
		this.p11 = p11;
	}
}

class Constructor12 {
	public var p1: int;
	public var p2: int;
	public var p3: int;
	public var p4: int;
	public var p5: int;
	public var p6: int;
	public var p7: int;
	public var p8: int;
	public var p9: int;
	public var p10: int;
	public var p11: int;
	public var p12: int;
	public function Constructor12( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int, p8: int, p9: int, p10: int, p11: int, p12: int ) {
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
		this.p4 = p4;
		this.p5 = p5;
		this.p6 = p6;
		this.p7 = p7;
		this.p8 = p8;
		this.p9 = p9;
		this.p10 = p10;
		this.p11 = p11;
		this.p12 = p12;
	}
}

class Constructor13 {
	public var p1: int;
	public var p2: int;
	public var p3: int;
	public var p4: int;
	public var p5: int;
	public var p6: int;
	public var p7: int;
	public var p8: int;
	public var p9: int;
	public var p10: int;
	public var p11: int;
	public var p12: int;
	public var p13: int;
	public function Constructor13( p1: int, p2: int, p3: int, p4: int, p5: int, p6: int, p7: int, p8: int, p9: int, p10: int, p11: int, p12: int, p13: int ) {
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
		this.p4 = p4;
		this.p5 = p5;
		this.p6 = p6;
		this.p7 = p7;
		this.p8 = p8;
		this.p9 = p9;
		this.p10 = p10;
		this.p11 = p11;
		this.p12 = p12;
		this.p13 = p13;
	}
}

class ConstructOptional {
	internal var _p2 : int;
	internal var _p1 : int;
	
	public function ConstructOptional( p: int, p2: int = 2 ) {
		_p1 = p;
		_p2 = p2;
	}
}