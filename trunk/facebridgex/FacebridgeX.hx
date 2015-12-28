/*
* Copyright (c) 2009, Zerofractal Studio - http://www.zerofractal.com
*   Ported to haxe by JLM at Justinfront dot net
*   Updated for small facebook change ( renaud bardet at succubus dot fr)
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
* THIS SOFTWARE IS PROVIDED BY Zerofractal Studio ''AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL Zerofractal Studio BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


import flash.external.ExternalInterface;


class FacebridgeX extends IntHash<Dynamic>
{
    
    private var _debug:         Bool;
    private var _flash_name:    String;
    private var _calls:         Array<Dynamic>;
    
    
    public function new(
                            flash_name_:    String  = "flashContent",
                            debug_:         Bool    = true
                        )
    {
        
        super();
        
        _flash_name = flash_name_;
        _debug      = debug_;
        _calls      = [];
        
        ExternalInterface.addCallback( "onCallMethod", onCallMethod );
        
    }
    
    
    //////////////GETTERS & SETTERS///////////////
    public var version( getVersion, null ):         String;
    private function getVersion():                  String 
    {
        
        return "0.6.1";
        
    }
    
    
    //TODO: This string path should be abstracted to a string constant?
    public var api_key( getApi_key, null ):         String;
    private function getApi_key():                  String
    {
        
        var call:   String = "function(){return FB.Facebook.apiClient.get_apiKey();}";
        return ExternalInterface.call( call );
        
    }
    
    
    public var session_key( getSession_key, null ): String;
    public function getSession_key():               String
    {
        var call:String = "function(){return FB.Facebook.apiClient.get_session().session_key;}";	
        return ExternalInterface.call( call );
        
    }
    
    //Float should be Int??
    public var expires( getExpires, null ):         Float;
    private function getExpires():                  Float 
    {
        
        var call:String = "function(){return FB.Facebook.apiClient.get_session().expires;}";	
        return ExternalInterface.call( call );
        
    }
    
    
    public var secret( getSecret, null ):           String; 
    private function getSecret():                   String
    {
        
        var call:String = "function(){return FB.Facebook.apiClient.get_session().secret;}";	
        return ExternalInterface.call( call );
        
    }
    
    
    public var sig( getSig, null ):                 String;
    private function getSig():                      String
    {
        var call:String = "function(){return FB.Facebook.apiClient.get_session().sig;}";	
        return ExternalInterface.call( call );
        
    }
    
    
    public var uid( getUid, null ):                 String;
    private function getUid():                      String 
    {
        
        var call:String = "function(){return FB.Facebook.apiClient.get_session().uid;}";	
        return ExternalInterface.call( call );
        
    }
    
    
    //////////////PUBLIC FUNCTIONS///////////////
    public function dump( 
                            obj: Dynamic,
                            txt: String = ""
                        )
    {
        
        ExternalInterface.call( "Debug.dump", obj, txt );
        
    }
    
    
    public function callMethod( fbCall: FacebookCall )
    {
        
        var callID = _calls.push( fbCall ) - 1;
        var temp;//Pointer
        for ( o in Reflect.fields( fbCall.args ) )
        {
            
            temp = Reflect.field( fbCall.args, o );
            temp = '' + Reflect.field( fbCall.args, o );
            
        }
        
        if ( _debug ) 
        {
            
            dump(fbCall.args, "Calling method " + fbCall.method);
            
        }
        
        var jsCall: String =    "function(method, args, callID){"+
                                "FB.Facebook.apiClient.callMethod(method, args,function(result, exception){" +
                                "document." + _flash_name + ".onCallMethod(result, exception, callID);" +
                                "});" +
                                "}";
                                
        ExternalInterface.call( jsCall, fbCall.method, fbCall.args, callID );
        
    }
    
    
    //////////////PRIVATE FUNCTIONS///////////////
    //private??
    public function onCallMethod( 
                                    result:     Dynamic, 
                                    exception:  Dynamic, 
                                    callID:     Int
                                )
    {
        //TODO: Use proper typing why is this not working??!!
        var fbCall:     FacebookCall       = _calls[callID];
        var fbResponse: FacebookResponse   = new FacebookResponse( result, exception );
        
        if ( _debug ) 
        {
            
            dump( { result: result, exception: exception }, "Got response for method" + fbCall.method );
            
        }
        
        fbCall.callback__.call( this, fbCall, fbResponse );
        
    }
    
    
}
