/*
* Copyright (c) 2009, Justinfront Ltd
*   author: JLM at Justinfront dot net
*   based on original work by: Zerofractal Studio - http://www.zerofractal.com
*   Special thanks to: Niel Drummond with some debug guidence
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the Zerofractal Studio nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY Justinfront Ltd ''AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL Justinfront Ltd BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


import flash.display.Sprite;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import flash.display.Stage;
import flash.text.TextField;

class FacebookExample
{
    
    
    private var _stage:         Stage;
    private var _txt:           TextField;
    private var _mc:            Sprite;
    private var _responseText:  TextField;
    private var _fb:            FacebridgeX;
    
    
    public function new ():Void
    {
        
        _stage = Lib.current.stage;
        init();
        
    }
    
    
    private function init():Void
    {
        
        _fb             = new FacebridgeX( _stage.loaderInfo.parameters.flash_name );
        
        _txt            = new TextField();
        _txt.text       = "JLM's HaXe Facebook Example (based on zerofractal's flash)";
        _txt.width = 300;
        _txt.x = 3;
        _txt.y = 3;
        _stage.addChild( _txt );
        _responseText   = new TextField();
        _responseText.x = 10;
        _responseText.y = 25;
        _responseText.width      = 300;
        _responseText.height     = 180;
        _responseText.background = true;
        _responseText.backgroundColor = FacebookStyleguide.BLUE_LITE0;
        _responseText.border = true;
        _responseText.borderColor = FacebookStyleguide.BORDER_GREY;
        _responseText.text = 'test text area';
        _stage.addChild( _responseText );
        _mc             = new Sprite();
        var but: Sprite = basicButton( 'get groups', getGroups );
        but.x = 230;
        but.y = 200;
        
    }
    
    
    private function basicButton( label_: String, buttonFunction_: Dynamic ):Sprite
    {
        
        var mc: Sprite   = new Sprite();
        _stage.addChild( mc );
        drawRect( mc, 60, 20, FacebookStyleguide.BORDER_GREY, FacebookStyleguide.FACEBOOK_BLUE );
        
        var tx: TextField   = new TextField();
        tx.x=2;
        tx.y=2;
        mc.addChild( tx );
        tx.text             = label_;
        // style text here ( FacebookStyleguide.TEXT_GREY, FacebookStyleguide.HEADING_SMALL );
        
        mc.addEventListener( MouseEvent.MOUSE_DOWN, buttonFunction_ );
        mc.buttonMode       = true; 
        mc.mouseChildren    = false;
        return mc;
        
    }
    
    
    private function drawRect(  
                                mc:         Sprite, 
                                w:          Int, 
                                h:          Int, 
                                c_border:   Int,
                                c_bg:       Int 
                                            ):Void
    {
        
        mc.graphics.lineStyle( 0, c_border, 1 );
        mc.graphics.beginFill( c_bg, 1 );
        mc.graphics.drawRect( 0, 0, w, h );
        mc.graphics.endFill();
        
    }
    
    // These should not be Dynamic?????
    private function onFacebookReply( fbCall: FacebookCall, fbResponse: FacebookResponse ):Void
    {
        
         _responseText.text += '\n' + 'onFacebookReply';
         _responseText.text = "Result for method " + fbCall + ":\n";
        if ( fbResponse.success )
        {
           
            _responseText.text = "Result for method " + fbCall.method + ":\n";
            for( all in Reflect.fields( fbResponse.result ))
            {
                for( key in Reflect.fields( Reflect.field( fbResponse.result , all) ) ) //fbResponse.result[ 0 ]
                {
                    
                    _responseText.appendText( key + "  " + Reflect.field ( Reflect.field( fbResponse.result , all) , key ) + "\n" );
                    
                }
            }
            //loadImage( fbResponse.result[0]['name'],fbResponse.result[0]['pic'] );
            
        } 
        else 
        {
            
            onError( fbCall, fbResponse );
            
        }
       
    }
    
    
    private function onError( 
                                fbCall:     FacebookCall,
                                fbResponse: FacebookResponse
                            ):Void
    {
        
        _responseText.text = "\n\nError Calling method " + fbCall.method + ":\n" + cast( fbResponse.exception.error_msg, String );
        
    }
    
    
    private function FQLquery( q: String ):Void
    {
        _responseText.text += '\n' + 'FQLquery';
        _fb.callMethod( new FacebookCall(
                                            "fql.query",
                                            { query: q },
                                            onFacebookReply
                                        ));
        
    }
    
    
    private function callAPI( call, refObj ):Void
    {
        
        _fb.callMethod(new FacebookCall( 
                                            call, 
                                            refObj, 
                                            onFacebookReply 
                                        ));
        
    }
    
    
    static function main() 
    {
        
        new FacebookExample();
        
    }
    
    
    //////////////  Face Book Examples
    
    
    // get groups
    private function getGroups( e: Event = null )
    {
        
        _responseText.text += '\n' + 'get groups for user number: ' + _fb.uid;
        var id: String = _fb.uid;
        FQLquery( "SELECT gid, name FROM group WHERE gid IN (SELECT gid FROM group_member WHERE uid=" + _fb.uid + ");" );
        
    }
    
    

    
    
}
