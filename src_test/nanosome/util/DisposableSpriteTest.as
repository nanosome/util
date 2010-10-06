package nanosome.util {
	
	import flexunit.framework.TestCase;

	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * @author Martin Heidegger mh@leichtgewicht.at
	 */
	public class DisposableSpriteTest extends TestCase {
		
		protected var _sprite: DisposableSprite;
		
		override public function setUp(): void {
			_sprite = new DisposableSprite();
		}
		
		public function testDisposing(): void {
			var parent: Sprite = new Sprite();
			var normalChild: Sprite = new Sprite();
			var disposableChild: CustomSprite = new CustomSprite();
			
			parent.addChild( _sprite );
			assertEquals( parent, _sprite.parent );
			_sprite.dispose();
			assertNull( _sprite.parent );
			
			_sprite.scrollRect = new Rectangle();
			_sprite.dispose();
			assertNull( _sprite.scrollRect );
			
			parent.addChild( _sprite );
			_sprite.addChild( normalChild );
			assertEquals( 1, _sprite.numChildren );
			_sprite.dispose();
			assertNull( _sprite.parent );
			assertNull( normalChild.parent );
			assertEquals( 0, _sprite.numChildren );
			
			parent.addChild( _sprite );
			_sprite.addChild( disposableChild );
			_sprite.addChild( normalChild );
			_sprite.dispose();
			assertNull( _sprite.parent );
			assertEquals( 0, _sprite.numChildren );
			assertNull( normalChild.parent );
			assertNull( disposableChild.parent );
			assertTrue( disposableChild.disposed );
		}
	}
}

import nanosome.util.IDisposable;
import flash.display.Sprite;

class CustomSprite extends Sprite implements IDisposable {
	
	public var disposed: Boolean = false;
	
	public function dispose() : void {
		disposed = true;
	}
}