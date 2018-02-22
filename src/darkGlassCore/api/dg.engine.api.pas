//------------------------------------------------------------------------------
// This file is part of the DarkGlass game engine project.
// More information can be found here: http://chapmanworld.com/darkglass
//
// DarkGlass is licensed under the MIT License:
//
// Copyright 2018 Craig Chapman
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the �Software�),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED �AS IS�, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.
//------------------------------------------------------------------------------
unit dg.engine.api;

interface
uses
  darkglass.types;

function dgVersionMajor: uint32;                                                   {$ifdef MSWINDOWS} stdcall; {$else} cdecl; {$endif} export;
function dgVersionMinor: uint32;                                                   {$ifdef MSWINDOWS} stdcall; {$else} cdecl; {$endif} export;
procedure dgRun;                                                                   {$ifdef MSWINDOWS} stdcall; {$else} cdecl; {$endif} export;
function dgGetMessageChannel( ChannelName: string ): THMessageChannel;             {$ifdef MSWINDOWS} stdcall; {$else} cdecl; {$endif} export;
function dgSendMessage( Channel: THMessageChannel; aMessage: TMessage ): boolean;  {$ifdef MSWINDOWS} stdcall; {$else} cdecl; {$endif} export;

implementation
uses
  sysutils,
  dg.platform.platform,
  dg.platform.platform.standard;

const
  cVersionMajor = 1;
  cVersionMinor = 0;

var
  Platform: IPlatform = nil;

function dgVersionMajor: uint32;
begin
  Result := cVersionMajor;
end;

function dgVersionMinor: uint32;
begin
  Result := cVersionMinor;
end;

procedure dgRun;
begin
  if not assigned(Platform) then begin
    exit;
  end;
  Platform.Run;
end;

function dgGetMessageChannel( ChannelName: string ): THMessageChannel;
begin
  Result := Platform.getMessageChannel( ChannelName );
end;

function dgSendMessage( Channel: THMessageChannel; aMessage: TMessage ): boolean;
begin
  Result := Platform.SendMessage( Channel, aMessage );
end;

procedure dgInitialize;
begin
  Platform := TPlatform.Create;
  if not Platform.Initialize then begin
    raise
      Exception.Create('DarkGlass engine failed to initialize.');
  end;
end;

procedure dgFinalize;
begin
  if not Platform.Finalize then begin
    raise
      Exception.Create('DarkGlass engine failed to finalize.');
  end;
end;

exports
  dgVersionMajor,
  dgVersionMinor,
  dgRun;

initialization
  dgInitialize;

finalization
  dgFinalize;
  Platform := nil;

end.
