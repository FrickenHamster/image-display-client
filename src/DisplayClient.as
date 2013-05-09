/**
 * Created with IntelliJ IDEA.
 * User: Fricken Hamster
 * Date: 5/9/13
 * Time: 12:35 AM
 *
 */
package
{
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.utils.ByteArray;

public class DisplayClient
{
	private var main:DisplayClientMain;
	private var host:String;
	private var port:int;

	private var socket:Socket;
	private var connected:Boolean;

	private var packetSize:int;
	private var packetBuffer:ByteArray;
	private var buffering:Boolean;


	public static const PING:int = 0;
	public static const IMAGE_LINK:int = 1;

	public function DisplayClient(main:DisplayClientMain)
	{
		this.main = main;
		host = DisplayClientMain.HOST_ADDRESS;
		port = DisplayClientMain.SERVER_PORT;

		connected = false;
		buffering = false;

		socket = new Socket(host, port);
	}

	public function connect():Boolean
	{
		this.socket.addEventListener(Event.CONNECT, socketConnect);
		this.socket.addEventListener(Event.CLOSE, socketClose);
		this.socket.addEventListener(IOErrorEvent.IO_ERROR, socketError);
		this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
		this.socket.addEventListener(ProgressEvent.SOCKET_DATA, socketData);

		connected = false;
		try
		{
			socket.connect( host , port );
		}
		catch ( e:Error )
		{
			return false;
		}
		return true;

	}

	private function readPacket(packet:ByteArray):void
	{
		var id:int = packet.readByte();
		switch (id)
		{
			case PING:
				debug("recieved ping");
				break;
			
			case IMAGE_LINK:
				var link:String = packet.readUTFBytes(packet.bytesAvailable);
				
				break;
		}
	}

	public function sendPing():void
	{
		try
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeByte(PING);
			sendPacket(byteArray);
		}
		catch(e:Error)
		{
			debug("Send Error");
		}
	}

	public function sendPacket( ba:ByteArray )
	{
		try
		{
			socket.writeShort( ba.length );
			socket.writeBytes( ba );
			socket.flush();
			debug( "sent bytearray length:" + ba.length );
		}
		catch ( e:Error )
		{
			debug( "send bytearray error:" + e );
		}
	}

	private function socketConnect(event:Event):void {
		debug ("Connected: " + event);
		connected = true;
	}

	private function socketData(event:ProgressEvent):void {
		debug( "Receiving data: " + event);
		//receiveData(this.socket.readUTFBytes(this.socket.bytesAvailable));
		if ( buffering == true )
		{
			socket.readBytes( packetBuffer , packetBuffer.length , 0 );
			if ( packetBuffer.length == packetSize )
			{
				buffering = false;
				readPacket(packetBuffer );
			}
		}
		else
		{
			packetSize = socket.readShort();
			packetBuffer = new ByteArray();
			socket.readBytes( packetBuffer , 0 , 0 );
			if ( packetBuffer.length < packetSize )
			{
				buffering = true;
			}
			else
			{
				readPacket(packetBuffer );
				socket.flush();
			}
		}

	}



	private function socketClose(event:Event):void {
		debug( "Connection closed: " + event);
	}

	private function socketError(event:IOErrorEvent):void {
		debug(  "Socket error: " + event);
	}

	private function securityError(event:SecurityErrorEvent):void {
		debug(  "Security error: " + event);
	}

	public function debug( msg:String ):void
	{
		trace("Client:" + msg);
	}
}
}
