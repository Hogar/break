/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.03.14
 * Time: 22:27
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.panels.bottomPanel.chatPanel {

    import breakdance.BreakdanceApp;
    import breakdance.core.server.ServerApi;
    import breakdance.core.server.ServerTime;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.socketServer.SocketServerManager;
    import breakdance.socketServer.events.ReceiveChatMessageEvent;
    import breakdance.ui.panels.bottomPanel.TypeButton;
    import breakdance.ui.panels.bottomPanel.TypeButtonWithText;
    import breakdance.user.AppUser;

    import com.hogargames.debug.Tracer;

    import com.hogargames.display.GraphicStorage;
    import com.hogargames.display.scrolls.TextFieldScroll;
    import com.hogargames.utils.StringUtilities;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.ui.Keyboard;

    public class ChatPanel extends GraphicStorage implements ITextContainer {

        private var scroll:TextFieldScroll;
        private var tfSend:TextField;
        private var tfChatLog:TextField;
        private var btnPrevious:TypeButton;
        private var btnNext:TypeButton;
        private var mcScrollBar:Sprite;
        private var mcScrollBase:Sprite;
        private var btnSend:TypeButtonWithText;
        private var mcTfSendBackground:Sprite;

        private var textManager:TextsManager;
        private var appUser:AppUser;

        private var chatAdmins:Array;
        private var chatAdminColor:String;

        private const MAX_LINES:int = 200;
        private const MAX_MESSAGE_LENGTH:int = 250;
        private static const SCROLL_OUT_ALPHA:Number = .5;

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function ChatPanel (mc:MovieClip) {
            var chatAdminsString:String = StaticData.instance.getSetting ("chat_admins");
            chatAdmins = chatAdminsString.split (",");
            chatAdminColor = StaticData.instance.getSetting ("chat_admin_color");

            textManager = TextsManager.instance;
            appUser = BreakdanceApp.instance.appUser;
            super (mc);
            ServerApi.instance.query (ServerApi.GET_LOG_LIST, {}, onGetLogList);
        }

        private function onGetLogList (response:Object):void {
            Tracer.traceObject (response);
            if (response.response_code == 1) {
                var delta:Number = ServerTime.instance.delta;
                trace ("delta = " + delta);
                if (response.hasOwnProperty ("data")) {
                    var data:Object = response.data;
                    var numChatLogs:int = parseInt (StaticData.instance.getSetting ("num_chat_logs"));
                    for (var i:int = Math.max (0, data.length - numChatLogs); i < data.length; i++) {
                        var messageData:Object = data [i];
                        var messageDate:String = messageData.create_date;
                        var message:String = unescape (messageData.message);
                        var nickname:String = unescape (messageData.nickname);
                        var uid:String = unescape (messageData.user_id);
                        trace ("Message " + i);
                        trace ("date " + messageDate);
                        var date:Date = ServerTime.instance.parseDateStr (messageDate);
                        var isUserMessage:Boolean = (uid == appUser.uid);
                        if (isUserMessage) {
                            nickname = textManager.getText ("i");
                        }
                        addMessage (message, nickname, isUserMessage, uid, date);
                    }
                }
            }
        }

        public function setTexts ():void {
            btnSend.text = textManager.getText ("send");
        }

        override public function destroy ():void {
            if (scroll) {
                scroll.destroy ();
                scroll = null;
            }
            if (btnSend) {
                btnSend.removeEventListener (MouseEvent.CLICK, clickListener);
                btnSend.destroy ();
                btnSend = null;
            }
            if (btnNext) {
                btnNext.destroy ();
                btnNext = null;
            }
            if (btnPrevious) {
                btnPrevious.destroy ();
                btnPrevious = null;
            }
            SocketServerManager.instance.removeEventListener (ReceiveChatMessageEvent.RECEIVE_CHAT_MESSAGE, receiveChatMessageListener);
            TextsManager.instance.removeTextContainer (this);
            super.destroy ();
        }

        public function addMessage (message:String, authorName:String, userText:Boolean, uid:String, date:Date = null):void {
            if (tfChatLog.numLines > MAX_LINES) {
                tfChatLog.text = "";
            }
            if (date == null) {
                date = new Date ();
            }
            var minutes:String = String (date.minutes);
            while (minutes.length < 2) {
                minutes = "0" + minutes;
            }
            var hours:String = String (date.hours);
            while (hours.length < 2) {
                hours = "0" + hours;
            }

            var text:String = "<font color='#565656'>" + hours + ":" + minutes + "</font>  ";
            var isAdmin:Boolean = (chatAdmins.indexOf (uid) != -1);
            if (isAdmin) {
                text += "<b><font color='" + chatAdminColor + "'>" + authorName + "</font>";
                text += "<font color='"  + chatAdminColor + "'>: " + message + "</font></b><br>";
            }
            else {
                if (userText) {
                    text += "<font color='#ffffff'><b>" + authorName + "</b></font>";
                    text += "<font color='#ffffff'>: " + message + "</font><br>";
                }
                else {
                    text += "<font color='#ffce0c'><b><u>" + authorName + "</u></b></font>";
                    text += "<font color='#cccccc'>: " + message + "</font><br>";
                }
            }

            tfChatLog.htmlText = "<textFormat leading='2' indent='-43' blockIndent='43'>" + tfChatLog.htmlText + text + "</textFormat>";
            scroll.setPositionAt (1);

        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcScrollBar = getElement ("mcScrollBar");
            mcScrollBase = getElement ("mcScrollBase");
            btnPrevious = new TypeButton (mc ["btnPrevious"]);
            btnNext = new TypeButton (mc ["btnNext"]);
            tfSend = getElement ("tfSend");
            tfChatLog = getElement ("tfChatLog");
            btnSend = new TypeButtonWithText (mc ["btnSend"]);
            mcTfSendBackground = getElement ("mcTfSendBackground");

            tfChatLog.text = "";
            tfSend.text = "";
            tfSend.maxChars = MAX_MESSAGE_LENGTH;

            var textFormat:TextFormat = tfChatLog.getTextFormat ();
            textFormat.indent = -10;
            tfChatLog.defaultTextFormat = textFormat;

            scroll = new TextFieldScroll ();
            scroll.x = btnPrevious.x;
            scroll.y = btnPrevious.y;
            scroll.buttonMargin = mcScrollBase.y - (btnPrevious.y + btnPrevious.height);
            scroll.setExternalScrollBar (mcScrollBar, true);
            scroll.setExternalScrollBase (mcScrollBase, true);
            scroll.setExternalTopButton (btnPrevious, false);
            scroll.setExternalBottomButton (btnNext, true);
            scroll.y += scroll.totalButtonHeight;
            scroll.setTextField (tfChatLog);
            addChild (scroll);

            btnSend.addEventListener (MouseEvent.CLICK, clickListener);

            SocketServerManager.instance.addEventListener (ReceiveChatMessageEvent.RECEIVE_CHAT_MESSAGE, receiveChatMessageListener);
            tfSend.addEventListener (FocusEvent.FOCUS_IN, focusInListener);
            tfSend.addEventListener (FocusEvent.FOCUS_OUT, focusOutListener);

            TextsManager.instance.addTextContainer (this);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function sendMessage ():void {
            var message:String = tfSend.text;
            if (!StringUtilities.isNotValueString (message)) {
                addMessage (message, textManager.getText ("i"), true, appUser.uid);
                SocketServerManager.instance.broadcast (message);
                ServerApi.instance.query (ServerApi.SAVE_LOG, {message:escape (message), nickname:escape (appUser.nickname)}, onSaveLog);
                tfSend.text = "";
                if (stage) {
                    stage.focus = tfSend;
                }
            }
        }

        private function onSaveLog (response:Object):void {
            trace ("response = " + response);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            if (appUser.installed) {
                sendMessage ();
            }
        }

        private function receiveChatMessageListener (event:ReceiveChatMessageEvent):void {
            addMessage (event.message, event.authorName, false, event.uid);
        }

        private function focusInListener (event:FocusEvent):void {
            if (stage) {
                stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDownListener);
                mcTfSendBackground.alpha = 1;
            }
        }

        private function focusOutListener (event:FocusEvent):void {
            if (stage) {
                stage.removeEventListener (KeyboardEvent.KEY_DOWN, keyDownListener);
                mcTfSendBackground.alpha = SCROLL_OUT_ALPHA;
            }
        }

        private function keyDownListener (event:KeyboardEvent):void {
            if (event.keyCode == Keyboard.ENTER) {
                sendMessage ();
            }
        }
    }
}
