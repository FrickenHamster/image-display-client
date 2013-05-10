/**
 * Created with IntelliJ IDEA.
 * User: Fricken Hamster
 * Date: 5/9/13
 * Time: 12:34 AM
 *
 */
package
{
import flash.display.Loader;
import flash.display.MovieClip;
import flash.system.Security;

public class DisplayClientMain extends  MovieClip
{

	public static const HOST_ADDRESS:String = "127.0.0.1";
	public static const POLICY_PORT:int = 12242;
	public static const SERVER_PORT:int = 12244;
	
	private var imageList:Vector.<LoadedImage>;
	
	private var displayImage:LoadedImage;
	
	public function DisplayClientMain()
	{
		Security.loadPolicyFile("xmlsocket://" + HOST_ADDRESS + ":" + POLICY_PORT);

		graphics.lineStyle(1, 0x000000);
		graphics.moveTo(50, 50);
		graphics.lineTo(50, 650);
		graphics.lineTo(650, 650);
		graphics.lineTo(650, 50);
		graphics.lineTo(50, 50);
		
	}
	
	public function switchImage(image:LoadedImage):void
	{
		if (contains(displayImage))
		{
			removeChild(displayImage);
		}
		displayImage = image;
		addChild(displayImage);
	}
	
	public function addImage(id:int, link:String):void
	{
		var image:LoadedImage = new LoadedImage(this, id, link);
		imageList.push(image);
	}
}
}
