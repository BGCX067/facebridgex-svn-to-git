/*
* Copyright (c) 2009, Zerofractal Studio - http://www.zerofractal.com
*   Ported to haxe by JLM at Justinfront dot net
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


class FacebookCall extends IntHash<Dynamic>
{
    
    private var _method:    String;
    private var _args:      Dynamic;
    private var _callback:  Dynamic;
    
    
    public function new(
                            method_:    String, 
                            args_:      Dynamic, 
                            callback_:  Dynamic
                        )
    {
        super();
        _method     = method_;
        _args       = args_;
        _callback   = callback_;
        
    }
    
    //////////////GETTERS & SETTERS///////////////
    
    public var method( getMethod, null ):       String;
    private function getMethod():               String
    { 
        
        return _method; 
        
    }
    
    public var args( getArgs, null ):           Dynamic;
    private function getArgs():                 Dynamic
    { 
        
        return _args; 
        
    }
    
    public var callback__( getCallBack, null ):   Dynamic;
    private function getCallBack():             Dynamic
    { 
        
        return _callback;
        
    }
    
    
}
