package {
	import nanosome.notify.bind.BinderTest;
	import nanosome.notify.bind.WatchTest;
	import nanosome.notify.field.FieldTest;
	import nanosome.notify.observe.PropertyBroadcasterTest;
	import nanosome.util.CreateInstanceTest;
	import nanosome.util.DisposableSpriteTest;
	import nanosome.util.EnterFrameTest;
	import nanosome.util.ExitFrameTest;
	import nanosome.util.MergeArraysTest;
	import nanosome.util.UIDTest;
	import nanosome.util.access.AccessorTest;
	import nanosome.util.list.ListTest;
	import nanosome.util.list.UIDListTest;
	import nanosome.util.list.fnc.FunctionListTest;
	import nanosome.util.pool.PoolTest;

	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;

	import flash.display.Sprite;

	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]

	public class FlexUnitRunner extends Sprite {
		private var core : FlexUnitCore;
		private var _tests : Array;

		public function FlexUnitRunner() {
			//Instantiate the core.
			core = new FlexUnitCore();
			
			//Add any listeners. In this case, the TraceListener has been added to display results.
			core.addListener(new TraceListener());
			
			_tests = [
				MergeArraysTest,
				UIDTest,
				ListTest,
				UIDListTest,
				FunctionListTest,
				EnterFrameTest,
				ExitFrameTest,
				DisposableSpriteTest,
				PoolTest,
				PropertyBroadcasterTest,
				WatchTest,
				AccessorTest,
				FieldTest,
				BinderTest,
				CreateInstanceTest,
			];
			
			core.run( _tests);
		}
	}
}
