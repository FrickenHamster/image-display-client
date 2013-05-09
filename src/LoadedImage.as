/**
 * Created with IntelliJ IDEA.
 * User: Fricken Hamster
 * Date: 5/9/13
 * Time: 1:04 AM
 *
 */
package
{
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;

public class LoadedImage extends Loader
{
	private var id:int;
	private var link:String;
	public function LoadedImage(id:int, link:String)
	{
		super()
		this.id = id;
		this.link = link;
		contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderReady);
		contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
		
	}
	
	private function onLoaderReady(e:Event):void
	{
		
		
		contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaderReady);
		contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
	}
	
	private function loadError()
	{
		
	}
	
}
}
