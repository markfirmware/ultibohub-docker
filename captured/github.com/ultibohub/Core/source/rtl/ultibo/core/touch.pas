{
Ultibo Touch interface unit.

Copyright (C) 2016 - SoftOz Pty Ltd.

Arch
====

 <All>

Boards
======

 <All>

Licence
=======

 LGPLv2.1 with static linking exception (See COPYING.modifiedLGPL.txt)
 
Credits
=======

 Information for this unit was obtained from:

 
References
==========


Touch Devices
=============

}

{$mode delphi} {Default to Delphi compatible syntax}
{$H+}          {Default to AnsiString}
{$inline on}   {Allow use of Inline procedures}

unit Touch;

interface

uses GlobalConfig,GlobalConst,GlobalTypes,Platform,Threads,Devices,SysUtils;
     
{==============================================================================}
{Global definitions}
{$INCLUDE GlobalDefines.inc}

{==============================================================================}
const
 {Touch specific constants}
 TOUCH_NAME_PREFIX = 'Touch';  {Name prefix for Touch Devices}

 {Touch Device Types}
 TOUCH_TYPE_NONE       = 0;
 TOUCH_TYPE_RESISTIVE  = 1;
 TOUCH_TYPE_CAPACITIVE = 2;
 
 {Touch Device States}
 TOUCH_STATE_DISABLED = 0;
 TOUCH_STATE_ENABLED  = 1;
 
 {Touch Device Flags}
 TOUCH_FLAG_NONE         = $00000000;
 TOUCH_FLAG_NON_BLOCK    = $00000001; {If set device reads are non blocking (Also supported in Flags parameter of TouchDeviceRead)}
 TOUCH_FLAG_PEEK_BUFFER  = $00000002; {Peek at the buffer to see if any data is available, don't remove it (Used only in Flags parameter of TouchDeviceRead)}
 TOUCH_FLAG_MOUSE_DATA   = $00000004; {If set the device will write a mouse data event for each touch event}
 TOUCH_FLAG_MULTI_POINT  = $00000008; {If set the device supports multi point touch}
 TOUCH_FLAG_PRESSURE     = $00000010; {If set the device supports pressure value on touch points}
 
 {Flags supported by TOUCH_CONTROL_GET/SET/CLEAR_FLAG}
 TOUCH_FLAG_MASK = TOUCH_FLAG_NON_BLOCK or TOUCH_FLAG_MOUSE_DATA or TOUCH_FLAG_MULTI_POINT or TOUCH_FLAG_PRESSURE;
 
 {Touch Device Control Codes}
 TOUCH_CONTROL_GET_FLAG         = 1;  {Get Flag}
 TOUCH_CONTROL_SET_FLAG         = 2;  {Set Flag}
 TOUCH_CONTROL_CLEAR_FLAG       = 3;  {Clear Flag}
 TOUCH_CONTROL_FLUSH_BUFFER     = 4;  {Flush Buffer}
 //To Do //Calibration/Rotation etc
 
 {Touch Buffer Size}
 TOUCH_BUFFER_SIZE = 1024; 
 
 {Touch Data Definitions (Values for TTouchData.Info)}
 TOUCH_FINGER = $00000001; {A finger is pressed at this touch point}
 
 {Touch Data Definitions (Values for TTouchData.PointID)}
 TOUCH_ID_UNKNOWN = Word(-1);
 
 {Touch Data Definitions (Values for TTouchData.PositionX)}
 TOUCH_X_UNKNOWN = -1; 

 {Touch Data Definitions (Values for TTouchData.PositionY)}
 TOUCH_Y_UNKNOWN = -1;

 {Touch Data Definitions (Values for TTouchData.PositionZ)}
 TOUCH_Z_UNKNOWN = -1;
 
 {Touch Rotation}
 TOUCH_ROTATION_0   = FRAMEBUFFER_ROTATION_0;    {No rotation}
 TOUCH_ROTATION_90  = FRAMEBUFFER_ROTATION_90;   {90 degree rotation}
 TOUCH_ROTATION_180 = FRAMEBUFFER_ROTATION_180;  {180 degree rotation}
 TOUCH_ROTATION_270 = FRAMEBUFFER_ROTATION_270;  {270 degree rotation}
 
 {Touch logging}
 TOUCH_LOG_LEVEL_DEBUG     = LOG_LEVEL_DEBUG;  {Touch debugging messages}
 TOUCH_LOG_LEVEL_INFO      = LOG_LEVEL_INFO;   {Touch informational messages, such as a device being attached or detached}
 TOUCH_LOG_LEVEL_ERROR     = LOG_LEVEL_ERROR;  {Touch error messages}
 TOUCH_LOG_LEVEL_NONE      = LOG_LEVEL_NONE;   {No Touch messages}

var 
 TOUCH_DEFAULT_LOG_LEVEL:LongWord = TOUCH_LOG_LEVEL_DEBUG; {Minimum level for Touch messages.  Only messages with level greater than or equal to this will be printed}
 
var 
 {Touch logging}
 TOUCH_LOG_ENABLED:Boolean; 
 
{==============================================================================}
type
 {Touch specific types}
 {Touch Data}
 PTouchData = ^TTouchData;
 TTouchData = record
  Info:LongWord;
  PointID:Word;
  PositionX:SmallInt;
  PositionY:SmallInt;
  PositionZ:SmallInt;
 end;
 
 {Touch Buffer}
 PTouchBuffer = ^TTouchBuffer;
 TTouchBuffer = record
  Wait:TSemaphoreHandle;     {Buffer ready semaphore}
  Start:LongWord;            {Index of first buffer ready}
  Count:LongWord;            {Number of entries ready in buffer}
  Buffer:array[0..(TOUCH_BUFFER_SIZE - 1)] of TTouchData; 
 end;

 {Touch Properties}
 PTouchProperties = ^TTouchProperties;
 TTouchProperties = record
  Flags:LongWord;        {Device flags (eg TOUCH_FLAG_MULTI_POINT)}
  Width:LongWord;        {Screen Width}
  Height:LongWord;       {Screen Height}
  Rotation:LongWord;     {Screen Rotation (eg TOUCH_ROTATION_180)}
  MaxX:LongWord;         {Maximum (absolute) X value for the touch device}
  MaxY:LongWord;         {Maximum (absolute) Y value for the touch device}
  MaxZ:LongWord;         {Maximum (absolute) Z value for the touch device}
  MaxPoints:LongWord;    {Maximum number of touch points}
 end;
 
 {Touch Device}
 PTouchDevice = ^TTouchDevice;
 
 {Touch Enumeration Callback}
 TTouchEnumerate = function(Touch:PTouchDevice;Data:Pointer):LongWord;
 {Touch Notification Callback}
 TTouchNotification = function(Device:PDevice;Data:Pointer;Notification:LongWord):LongWord;
 
 {Touch Device Methods}
 TTouchDeviceStart = function(Touch:PTouchDevice):LongWord; 
 TTouchDeviceStop = function(Touch:PTouchDevice):LongWord; 
 
 TTouchDevicePeek = function(Touch:PTouchDevice):LongWord; 
 TTouchDeviceRead = function(Touch:PTouchDevice;Buffer:Pointer;Size,Flags:LongWord;var Count:LongWord):LongWord; 
 TTouchDeviceWrite = function(Touch:PTouchDevice;Buffer:Pointer;Size,Count:LongWord):LongWord; 
 TTouchDeviceFlush = function(Touch:PTouchDevice):LongWord; 
 TTouchDeviceControl = function(Touch:PTouchDevice;Request:Integer;Argument1:LongWord;var Argument2:LongWord):LongWord;
 
 TTouchDeviceGetProperties = function(Touch:PTouchDevice;Properties:PTouchProperties):LongWord;
 
 TTouchDevice = record
  {Device Properties}
  Device:TDevice;                                 {The Device entry for this Touch device}
  {Touch Properties}
  TouchId:LongWord;                               {Unique Id of this Touch device in the Touch device table}
  TouchState:LongWord;                            {Touch dveice state (eg TOUCH_STATE_ENABLED)}
  DeviceStart:TTouchDeviceStart;                  {A Device specific DeviceStart method implementing the standard Touch device interface (Mandatory)}
  DeviceStop:TTouchDeviceStop;                    {A Device specific DeviceStop method implementing the standard Touch device interface (Mandatory)}
  DevicePeek:TTouchDevicePeek;                    {A Device specific DevicePeek method implementing a standard Touch device interface (Or nil if the default method is suitable)}
  DeviceRead:TTouchDeviceRead;                    {A Device specific DeviceRead method implementing a standard Touch device interface (Or nil if the default method is suitable)}
  DeviceWrite:TTouchDeviceWrite;                  {A Device specific DeviceWrite method implementing a standard Touch device interface (Or nil if the default method is suitable)}
  DeviceFlush:TTouchDeviceFlush;                  {A Device specific DeviceFlush method implementing a standard Touch device interface (Or nil if the default method is suitable)}
  DeviceControl:TTouchDeviceControl;              {A Device specific DeviceControl method implementing a standard Touch device interface (Or nil if the default method is suitable)}
  DeviceGetProperties:TTouchDeviceGetProperties;  {A Device specific DeviceGetProperties method implementing a standard Touch device interface (Or nil if the default method is suitable)}
  {Driver Properties}
  Lock:TMutexHandle;                              {Device lock}
  Buffer:TTouchBuffer;                            {Touch input buffer}
  Properties:TTouchProperties;                    {Device properties}
  {Statistics Properties}
  ReceiveCount:LongWord;
  ReceiveErrors:LongWord;
  BufferOverruns:LongWord;
  {Internal Properties}                                                                        
  Prev:PTouchDevice;                              {Previous entry in Touch device table}
  Next:PTouchDevice;                              {Next entry in Touch device table}
 end; 
  
{==============================================================================}
{var}
 {Touch specific variables}
 
{==============================================================================}
{Initialization Functions}
procedure TouchInit;

{==============================================================================}
{Touch Functions}
function TouchDeviceStart(Touch:PTouchDevice):LongWord;
function TouchDeviceStop(Touch:PTouchDevice):LongWord;

function TouchDevicePeek(Touch:PTouchDevice):LongWord;

function TouchDeviceRead(Touch:PTouchDevice;Buffer:Pointer;Size,Flags:LongWord;var Count:LongWord):LongWord; 
function TouchDeviceWrite(Touch:PTouchDevice;Buffer:Pointer;Size,Count:LongWord):LongWord; 

function TouchDeviceFlush(Touch:PTouchDevice):LongWord;

function TouchDeviceControl(Touch:PTouchDevice;Request:Integer;Argument1:LongWord;var Argument2:LongWord):LongWord;

function TouchDeviceProperties(Touch:PTouchDevice;Properties:PTouchProperties):LongWord; inline;
function TouchDeviceGetProperties(Touch:PTouchDevice;Properties:PTouchProperties):LongWord;
  
function TouchDeviceCreate:PTouchDevice;
function TouchDeviceCreateEx(Size:LongWord):PTouchDevice;
function TouchDeviceDestroy(Touch:PTouchDevice):LongWord;

function TouchDeviceRegister(Touch:PTouchDevice):LongWord;
function TouchDeviceDeregister(Touch:PTouchDevice):LongWord;

function TouchDeviceFind(TouchId:LongWord):PTouchDevice;
function TouchDeviceFindByName(const Name:String):PTouchDevice; inline;
function TouchDeviceFindByDescription(const Description:String):PTouchDevice; inline;
function TouchDeviceEnumerate(Callback:TTouchEnumerate;Data:Pointer):LongWord;
 
function TouchDeviceNotification(Touch:PTouchDevice;Callback:TTouchNotification;Data:Pointer;Notification,Flags:LongWord):LongWord;

{==============================================================================}
{RTL Touch Functions}

{==============================================================================}
{Touch Helper Functions}
function TouchGetCount:LongWord; inline;
function TouchDeviceGetDefault:PTouchDevice; inline;
function TouchDeviceSetDefault(Touch:PTouchDevice):LongWord; 

function TouchDeviceCheck(Touch:PTouchDevice):PTouchDevice;

procedure TouchLog(Level:LongWord;Touch:PTouchDevice;const AText:String);
procedure TouchLogInfo(Touch:PTouchDevice;const AText:String); inline;
procedure TouchLogError(Touch:PTouchDevice;const AText:String); inline;
procedure TouchLogDebug(Touch:PTouchDevice;const AText:String); inline;

{==============================================================================}
{==============================================================================}

implementation

{==============================================================================}
{==============================================================================}
var
 {Touch specific variables}
 TouchInitialized:Boolean;

 TouchDeviceTable:PTouchDevice;
 TouchDeviceTableLock:TCriticalSectionHandle = INVALID_HANDLE_VALUE;
 TouchDeviceTableCount:LongWord;

 TouchDeviceDefault:PTouchDevice;
 
{==============================================================================}
{==============================================================================}
{Initialization Functions}
procedure TouchInit;
{Initialize the Touch unit and Touch device table}

{Note: Called only during system startup}
begin
 {}
 {Check Initialized}
 if TouchInitialized then Exit;
 
 {Initialize Logging}
 TOUCH_LOG_ENABLED:=(TOUCH_DEFAULT_LOG_LEVEL <> TOUCH_LOG_LEVEL_NONE); 
 
 {Initialize Touch Device Table}
 TouchDeviceTable:=nil;
 TouchDeviceTableLock:=CriticalSectionCreate; 
 TouchDeviceTableCount:=0;
 if TouchDeviceTableLock = INVALID_HANDLE_VALUE then
  begin
   if TOUCH_LOG_ENABLED then TouchLogError(nil,'Failed to create Touch device table lock');
  end;
 TouchDeviceDefault:=nil;
 
 {Register Platform Touch Handlers}
 {Nothing}
 
 TouchInitialized:=True;
end;

{==============================================================================}
{==============================================================================}
{Touch Functions}
function TouchDeviceStart(Touch:PTouchDevice):LongWord;
{Start the specified Touch device ready for receiving events}
{Touch: The Touch device to start}
{Return: ERROR_SUCCESS if completed or another error code on failure}
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Touch}
 if Touch = nil then Exit;
 if Touch.Device.Signature <> DEVICE_SIGNATURE then Exit; 
 
 {$IFDEF TOUCH_DEBUG}
 if TOUCH_LOG_ENABLED then TouchLogDebug(Touch,'Touch Device Start');
 {$ENDIF}
 
 {Check Disabled}
 Result:=ERROR_SUCCESS;
 if Touch.TouchState <> TOUCH_STATE_DISABLED then Exit;
 
 if MutexLock(Touch.Lock) = ERROR_SUCCESS then
  begin
   try
    if Assigned(Touch.DeviceStart) then
     begin
      {Call Device Start}
      Result:=Touch.DeviceStart(Touch);
      if Result <> ERROR_SUCCESS then Exit;
     end
    else
     begin
      Result:=ERROR_INVALID_PARAMETER;
      Exit;
     end;
     
    {Enable Device}
    Touch.TouchState:=TOUCH_STATE_ENABLED;
    
    {Notify Enable}
    NotifierNotify(@Touch.Device,DEVICE_NOTIFICATION_ENABLE);
    
    Result:=ERROR_SUCCESS;
   finally
    MutexUnlock(Touch.Lock);
   end; 
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;    
end;

{==============================================================================}

function TouchDeviceStop(Touch:PTouchDevice):LongWord;
{Stop the specified Touch device and terminate receiving events}
{Touch: The Touch device to stop}
{Return: ERROR_SUCCESS if completed or another error code on failure}
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Touch}
 if Touch = nil then Exit;
 if Touch.Device.Signature <> DEVICE_SIGNATURE then Exit; 
 
 {$IFDEF TOUCH_DEBUG}
 if TOUCH_LOG_ENABLED then TouchLogDebug(Touch,'Touch Device Stop');
 {$ENDIF}
 
 {Check Enabled}
 Result:=ERROR_SUCCESS;
 if Touch.TouchState <> TOUCH_STATE_ENABLED then Exit;
 
 if MutexLock(Touch.Lock) = ERROR_SUCCESS then
  begin
   try
    if Assigned(Touch.DeviceStop) then
     begin
      {Call Device Stop}
      Result:=Touch.DeviceStop(Touch);
      if Result <> ERROR_SUCCESS then Exit;
     end
    else
     begin
      Result:=ERROR_INVALID_PARAMETER;
      Exit;
     end;    
  
    {Disable Device}
    Touch.TouchState:=TOUCH_STATE_DISABLED;
    
    {Notify Disable}
    NotifierNotify(@Touch.Device,DEVICE_NOTIFICATION_DISABLE);
    
    Result:=ERROR_SUCCESS;
   finally
    MutexUnlock(Touch.Lock);
   end; 
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;    
end;

{==============================================================================}

function TouchDevicePeek(Touch:PTouchDevice):LongWord;
{Peek at the buffer of the specified touch device to see if any data packets are ready}
{Touch: The Touch device to peek at}
{Return: ERROR_SUCCESS if packets are ready, ERROR_NO_MORE_ITEMS if not or another error code on failure}
var
 Count:LongWord;
 Data:TTouchData;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Touch}
 if Touch = nil then Exit;
 if Touch.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {$IFDEF TOUCH_DEBUG}
 if TOUCH_LOG_ENABLED then TouchLogDebug(Touch,'Touch Device Peek');
 {$ENDIF}
 
 {Check Method}
 if Assigned(Touch.DevicePeek) then
  begin
   {Provided Method}
   Result:=Touch.DevicePeek(Touch);
  end
 else
  begin 
   {Default Method}
   Result:=TouchDeviceRead(Touch,@Data,SizeOf(TouchDeviceRead),TOUCH_FLAG_NON_BLOCK or TOUCH_FLAG_PEEK_BUFFER,Count);
  end; 
end;

{==============================================================================}

function TouchDeviceRead(Touch:PTouchDevice;Buffer:Pointer;Size,Flags:LongWord;var Count:LongWord):LongWord; 
{Read touch data packets from the buffer of the specified touch device}
{Touch: The Touch device to read from}
{Buffer: Pointer to a buffer to copy the touch data packets to}
{Size: The size of the buffer in bytes (Must be at least TTouchData or greater)}
{Flags: The flags for the behaviour of the read (eg TOUCH_FLAG_NON_BLOCK)}
{Count: The number of touch data packets copied to the buffer}
{Return: ERROR_SUCCESS if completed or another error code on failure}
var
 Offset:PtrUInt;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Touch}
 if Touch = nil then Exit;
 if Touch.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {$IFDEF TOUCH_DEBUG}
 if TOUCH_LOG_ENABLED then TouchLogDebug(Touch,'Touch Device Read (Size=' + IntToStr(Size) + ')');
 {$ENDIF}
 
 {Check Buffer}
 if Buffer = nil then Exit;
 
 {Check Size}
 if Size < SizeOf(TTouchData) then Exit;
 
 {Check Method}
 if Assigned(Touch.DeviceRead) then
  begin
   {Provided Method}
   Result:=Touch.DeviceRead(Touch,Buffer,Size,Flags,Count);
  end
 else
  begin 
   {Default Method}
   {Check Touch Enabled}
   if Touch.TouchState <> TOUCH_STATE_ENABLED then Exit;

   {$IFDEF TOUCH_DEBUG}
   if TOUCH_LOG_ENABLED then TouchLogDebug(Touch,'Attempting to read ' + IntToStr(Size) + ' bytes from touch');
   {$ENDIF}
   
   {Read to Buffer}
   Count:=0;
   Offset:=0;
   while Size >= SizeOf(TTouchData) do
    begin
     {Check Non Blocking}
     if (((Touch.Device.DeviceFlags and TOUCH_FLAG_NON_BLOCK) <> 0) or ((Flags and TOUCH_FLAG_NON_BLOCK) <> 0)) and (Touch.Buffer.Count = 0) then
      begin
       if Count = 0 then Result:=ERROR_NO_MORE_ITEMS;
       Break;
      end;
    
     {Check Peek Buffer}
     if (Flags and TOUCH_FLAG_PEEK_BUFFER) <> 0 then
      begin
       {Acquire the Lock}
       if MutexLock(Touch.Lock) = ERROR_SUCCESS then
        begin
         try
          if Touch.Buffer.Count > 0 then
           begin
            {Copy Data}
            PTouchData(PtrUInt(Buffer) + Offset)^:=Touch.Buffer.Buffer[Touch.Buffer.Start];
            
            {Update Count}
            Inc(Count);
            
            Result:=ERROR_SUCCESS;
            Break;
           end
          else
           begin
            Result:=ERROR_NO_MORE_ITEMS;
            Break;
           end;
         finally
          {Release the Lock}
          MutexUnlock(Touch.Lock);
         end;
        end
       else
        begin
         Result:=ERROR_CAN_NOT_COMPLETE;
         Exit;
        end;
      end
     else
      begin 
       {Wait for Touch Data}
       if SemaphoreWait(Touch.Buffer.Wait) = ERROR_SUCCESS then
        begin
         {Acquire the Lock}
         if MutexLock(Touch.Lock) = ERROR_SUCCESS then
          begin
           try
            {Copy Data}
            PTouchData(PtrUInt(Buffer) + Offset)^:=Touch.Buffer.Buffer[Touch.Buffer.Start];
            
            {Update Start}
            Touch.Buffer.Start:=(Touch.Buffer.Start + 1) mod TOUCH_BUFFER_SIZE;
          
            {Update Count}
            Dec(Touch.Buffer.Count);
       
            {Update Count}
            Inc(Count);
            
            {Update Size and Offset}
            Dec(Size,SizeOf(TTouchData));
            Inc(Offset,SizeOf(TTouchData));
           finally
            {Release the Lock}
            MutexUnlock(Touch.Lock);
           end;
          end
         else
          begin
           Result:=ERROR_CAN_NOT_COMPLETE;
           Exit;
          end;
        end  
       else
        begin
         Result:=ERROR_CAN_NOT_COMPLETE;
         Exit;
        end;
      end;
      
     {Return Result}
     Result:=ERROR_SUCCESS;
    end;
    
   {$IFDEF TOUCH_DEBUG}
   if TOUCH_LOG_ENABLED then TouchLogDebug(Touch,'Return count=' + IntToStr(Count));
   {$ENDIF}
  end; 
end;

{==============================================================================}

function TouchDeviceWrite(Touch:PTouchDevice;Buffer:Pointer;Size,Count:LongWord):LongWord; 
{Write touch data packets to the buffer of the specified touch device}
{Touch: The Touch device to write to}
{Buffer: Pointer to a buffer to copy the touch data packets from}
{Size: The size of the buffer in bytes (Must be at least TTouchData or greater)}
{Count: The number of touch data packets to copy from the buffer}
{Return: ERROR_SUCCESS if completed or another error code on failure}
var
 Offset:PtrUInt;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Touch}
 if Touch = nil then Exit;
 if Touch.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {$IFDEF TOUCH_DEBUG}
 if TOUCH_LOG_ENABLED then TouchLogDebug(Touch,'Touch Device Write (Size=' + IntToStr(Size) + ')');
 {$ENDIF}
 
 {Check Buffer}
 if Buffer = nil then Exit;
 
 {Check Size}
 if Size < SizeOf(TTouchData) then Exit;
 
 {Check Count}
 if Count < 1 then Exit;
 
 {Check Method}
 if Assigned(Touch.DeviceWrite) then
  begin
   {Provided Method}
   Result:=Touch.DeviceWrite(Touch,Buffer,Size,Count);
  end
 else
  begin 
   {Default Method}
   {Check Touch Enabled}
   if Touch.TouchState <> TOUCH_STATE_ENABLED then Exit;

   {$IFDEF TOUCH_DEBUG}
   if TOUCH_LOG_ENABLED then TouchLogDebug(Touch,'Attempting to write ' + IntToStr(Size) + ' bytes to touch');
   {$ENDIF}
 
   {Write from Buffer}
   Offset:=0;
   while (Size >= SizeOf(TTouchData)) and (Count > 0) do
    begin
     {Acquire the Lock}
     if MutexLock(Touch.Lock) = ERROR_SUCCESS then
      begin
       try
        {Check Buffer}
        if (Touch.Buffer.Count < TOUCH_BUFFER_SIZE) then
         begin
          {Copy Data}
          Touch.Buffer.Buffer[(Touch.Buffer.Start + Touch.Buffer.Count) mod TOUCH_BUFFER_SIZE]:=PTouchData(PtrUInt(Buffer) + Offset)^;
          
          {Update Count}
          Inc(Touch.Buffer.Count);
          
          {Update Count}
          Dec(Count);
          
          {Update Size and Offset}
          Dec(Size,SizeOf(TTouchData));
          Inc(Offset,SizeOf(TTouchData));
          
          {Signal Data Received}
          SemaphoreSignal(Touch.Buffer.Wait); 
         end
        else
         begin
          Result:=ERROR_INSUFFICIENT_BUFFER;
          Exit;
         end;
       finally
        {Release the Lock}
        MutexUnlock(Touch.Lock);
       end;
      end
     else
      begin
       Result:=ERROR_CAN_NOT_COMPLETE;
       Exit;
      end;
      
     {Return Result}
     Result:=ERROR_SUCCESS;
    end;
  end;
end;

{==============================================================================}

function TouchDeviceFlush(Touch:PTouchDevice):LongWord;
{Flush the contents of the buffer of the specified touch device}
{Touch: The Touch device to flush}
{Return: ERROR_SUCCESS if completed or another error code on failure}
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Touch}
 if Touch = nil then Exit;
 if Touch.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {$IFDEF TOUCH_DEBUG}
 if TOUCH_LOG_ENABLED then TouchLogDebug(Touch,'Touch Device Flush');
 {$ENDIF}
 
 {Check Method}
 if Assigned(Touch.DeviceFlush) then
  begin
   {Provided Method}
   Result:=Touch.DeviceFlush(Touch);
  end
 else
  begin 
   {Default Method}
   {Check Touch Enabled}
   if Touch.TouchState <> TOUCH_STATE_ENABLED then Exit;
 
   {Acquire the Lock}
   if MutexLock(Touch.Lock) = ERROR_SUCCESS then
    begin
     try
      while Touch.Buffer.Count > 0 do
       begin
        {Wait for Data (Should not Block)}
        if SemaphoreWait(Touch.Buffer.Wait) = ERROR_SUCCESS then
         begin
          {Update Start} 
          Touch.Buffer.Start:=(Touch.Buffer.Start + 1) mod TOUCH_BUFFER_SIZE;
          
          {Update Count}
          Dec(Touch.Buffer.Count);
         end
        else
         begin
          Result:=ERROR_CAN_NOT_COMPLETE;
          Exit;
         end;    
       end; 
      
      {Return Result}
      Result:=ERROR_SUCCESS;
     finally
      {Release the Lock}
      MutexUnlock(Touch.Lock);
     end;
    end
   else
    begin
     Result:=ERROR_CAN_NOT_COMPLETE;
     Exit;
    end;
  end; 
end;

{==============================================================================}

function TouchDeviceControl(Touch:PTouchDevice;Request:Integer;Argument1:LongWord;var Argument2:LongWord):LongWord;
{Perform a control request on the specified touch device}
{Touch: The Touch device to control}
{Request: The request code for the operation (eg TOUCH_CONTROL_GET_FLAG)}
{Argument1: The first argument for the operation (Dependent on request code)}
{Argument2: The second argument for the operation (Dependent on request code)}
{Return: ERROR_SUCCESS if completed or another error code on failure}
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Touch}
 if Touch = nil then Exit;
 if Touch.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {Check Method}
 if Assigned(Touch.DeviceControl) then
  begin
   {Provided Method}
   Result:=Touch.DeviceControl(Touch,Request,Argument1,Argument2);
  end
 else
  begin 
   {Default Method}
   {Check Touch Enabled}
   if Touch.TouchState <> TOUCH_STATE_ENABLED then Exit;

   {Acquire the Lock}
   if MutexLock(Touch.Lock) = ERROR_SUCCESS then
    begin
     try
      case Request of
       TOUCH_CONTROL_GET_FLAG:begin
         {Get Flag}
         LongBool(Argument2):=False;
         if (Touch.Device.DeviceFlags and Argument1) <> 0 then
          begin
           LongBool(Argument2):=True;
           
           {Return Result}
           Result:=ERROR_SUCCESS;
          end;
        end;
       TOUCH_CONTROL_SET_FLAG:begin 
         {Set Flag}
         if (Argument1 and not(TOUCH_FLAG_MASK)) = 0 then
          begin
           Touch.Device.DeviceFlags:=(Touch.Device.DeviceFlags or Argument1);
         
           {Return Result}
           Result:=ERROR_SUCCESS;
          end; 
        end;
       TOUCH_CONTROL_CLEAR_FLAG:begin 
         {Clear Flag}
         if (Argument1 and not(TOUCH_FLAG_MASK)) = 0 then
          begin
           Touch.Device.DeviceFlags:=(Touch.Device.DeviceFlags and not(Argument1));
         
           {Return Result}
           Result:=ERROR_SUCCESS;
          end; 
        end;
       TOUCH_CONTROL_FLUSH_BUFFER:begin
         {Flush Buffer}
         while Touch.Buffer.Count > 0 do 
          begin
           {Wait for Data (Should not Block)}
           if SemaphoreWait(Touch.Buffer.Wait) = ERROR_SUCCESS then
            begin
             {Update Start}
             Touch.Buffer.Start:=(Touch.Buffer.Start + 1) mod TOUCH_BUFFER_SIZE;
             
             {Update Count}
             Dec(Touch.Buffer.Count);
            end
           else
            begin
             Result:=ERROR_CAN_NOT_COMPLETE;
             Exit;
            end;
          end;
          
         {Return Result} 
         Result:=ERROR_SUCCESS;
        end;       
      end;
     finally
      {Release the Lock}
      MutexUnlock(Touch.Lock);
     end;
    end
   else
    begin
     Result:=ERROR_CAN_NOT_COMPLETE;
     Exit;
    end;
  end; 
end;

{==============================================================================}
 
function TouchDeviceProperties(Touch:PTouchDevice;Properties:PTouchProperties):LongWord; inline;
{Get the properties for the specified Touch device}
{Touch: The Touch device to get properties from}
{Properties: Pointer to a TTouchProperties structure to fill in}
{Return: ERROR_SUCCESS if completed or another error code on failure}

{Note: Replaced by TouchDeviceGetProperties for consistency}
begin
 {}
 Result:=TouchDeviceGetProperties(Touch,Properties);
end;

{==============================================================================}

function TouchDeviceGetProperties(Touch:PTouchDevice;Properties:PTouchProperties):LongWord;
{Get the properties for the specified Touch device}
{Touch: The Touch device to get properties from}
{Properties: Pointer to a TTouchProperties structure to fill in}
{Return: ERROR_SUCCESS if completed or another error code on failure}
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Properties}
 if Properties = nil then Exit;
 
 {Check Touch}
 if Touch = nil then Exit;
 if Touch.Device.Signature <> DEVICE_SIGNATURE then Exit; 
 
 {$IFDEF TOUCH_DEBUG}
 if TOUCH_LOG_ENABLED then TouchLogDebug(Touch,'Touch Device Get Properties');
 {$ENDIF}
 
 {Check Enabled}
 {Result:=ERROR_NOT_SUPPORTED;}
 {if Touch.TouchState <> TOUCH_STATE_ENABLED then Exit;} {Allow when disabled}
 
 if MutexLock(Touch.Lock) = ERROR_SUCCESS then
  begin
   if Assigned(Touch.DeviceGetProperties) then
    begin
     {Call Device Get Properites}
     Result:=Touch.DeviceGetProperties(Touch,Properties);
    end
   else
    begin
     {Get Properties}
     System.Move(Touch.Properties,Properties^,SizeOf(TTouchProperties));
       
     {Return Result}
     Result:=ERROR_SUCCESS;
    end;  
    
   MutexUnlock(Touch.Lock);
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;    
end;

{==============================================================================}

function TouchDeviceCreate:PTouchDevice;
{Create a new Touch device entry}
{Return: Pointer to new Touch device entry or nil if Touch device could not be created}
begin
 {}
 Result:=TouchDeviceCreateEx(SizeOf(TTouchDevice));
end;

{==============================================================================}

function TouchDeviceCreateEx(Size:LongWord):PTouchDevice;
{Create a new Touch device entry}
{Size: Size in bytes to allocate for new Touch device (Including the Touch device entry)}
{Return: Pointer to new Touch device entry or nil if Touch device could not be created}
begin
 {}
 Result:=nil;
 
 {Check Size}
 if Size < SizeOf(TTouchDevice) then Exit;
 
 {Create Touch}
 Result:=PTouchDevice(DeviceCreateEx(Size));
 if Result = nil then Exit;
 
 {Update Device}
 Result.Device.DeviceBus:=DEVICE_BUS_NONE;   
 Result.Device.DeviceType:=TOUCH_TYPE_NONE;
 Result.Device.DeviceFlags:=TOUCH_FLAG_NONE;
 Result.Device.DeviceData:=nil;

 {Update Touch}
 Result.TouchId:=DEVICE_ID_ANY;
 Result.TouchState:=TOUCH_STATE_DISABLED;
 Result.DeviceStart:=nil;
 Result.DeviceStop:=nil;
 Result.DevicePeek:=nil;
 Result.DeviceRead:=nil;
 Result.DeviceWrite:=nil;
 Result.DeviceFlush:=nil;
 Result.DeviceControl:=nil;
 Result.DeviceGetProperties:=nil;
 Result.Lock:=INVALID_HANDLE_VALUE;
 Result.Buffer.Wait:=INVALID_HANDLE_VALUE;
 
 {Check Defaults}
 if TOUCH_MOUSE_DATA_DEFAULT then Result.Device.DeviceFlags:=Result.Device.DeviceFlags or TOUCH_FLAG_MOUSE_DATA;
 
 {Create Lock}
 Result.Lock:=MutexCreateEx(False,MUTEX_DEFAULT_SPINCOUNT,MUTEX_FLAG_RECURSIVE);
 if Result.Lock = INVALID_HANDLE_VALUE then
  begin
   if TOUCH_LOG_ENABLED then TouchLogError(nil,'Failed to create lock for Touch device');
   TouchDeviceDestroy(Result);
   Result:=nil;
   Exit;
  end;
  
 {Create Buffer Semaphore}
 Result.Buffer.Wait:=SemaphoreCreate(0);
 if Result.Buffer.Wait = INVALID_HANDLE_VALUE then
  begin
   if TOUCH_LOG_ENABLED then TouchLogError(nil,'Failed to create buffer semaphore for Touch device');
   TouchDeviceDestroy(Result);
   Result:=nil;
   Exit;
  end;
end;

{==============================================================================}

function TouchDeviceDestroy(Touch:PTouchDevice):LongWord;
{Destroy an existing Touch device entry}
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Touch}
 if Touch = nil then Exit;
 if Touch.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {Check Touch}
 Result:=ERROR_IN_USE;
 if TouchDeviceCheck(Touch) = Touch then Exit;

 {Check State}
 if Touch.Device.DeviceState <> DEVICE_STATE_UNREGISTERED then Exit;
 
 {Destroy Buffer Semaphore}
 if Touch.Buffer.Wait <> INVALID_HANDLE_VALUE then
  begin
   SemaphoreDestroy(Touch.Buffer.Wait);
  end;
 
 {Destroy Lock}
 if Touch.Lock <> INVALID_HANDLE_VALUE then
  begin
   MutexDestroy(Touch.Lock);
  end;
 
 {Destroy Touch} 
 Result:=DeviceDestroy(@Touch.Device);
end;

{==============================================================================}

function TouchDeviceRegister(Touch:PTouchDevice):LongWord;
{Register a new Touch device in the Touch device table}
var
 TouchId:LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Touch}
 if Touch = nil then Exit;
 if Touch.TouchId <> DEVICE_ID_ANY then Exit;
 if Touch.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {Check Interfaces}
 if not(Assigned(Touch.DeviceStart)) then Exit;
 if not(Assigned(Touch.DeviceStop)) then Exit;
 
 {Check Touch}
 Result:=ERROR_ALREADY_EXISTS;
 if TouchDeviceCheck(Touch) = Touch then Exit;
 
 {Check State}
 if Touch.Device.DeviceState <> DEVICE_STATE_UNREGISTERED then Exit;
 
 {Insert Touch}
 if CriticalSectionLock(TouchDeviceTableLock) = ERROR_SUCCESS then
  begin
   try
    {Update Touch}
    TouchId:=0;
    while TouchDeviceFind(TouchId) <> nil do
     begin
      Inc(TouchId);
     end;
    Touch.TouchId:=TouchId;
    
    {Update Device}
    Touch.Device.DeviceName:=TOUCH_NAME_PREFIX + IntToStr(Touch.TouchId); 
    Touch.Device.DeviceClass:=DEVICE_CLASS_TOUCH;
    
    {Register Device}
    Result:=DeviceRegister(@Touch.Device);
    if Result <> ERROR_SUCCESS then
     begin
      Touch.TouchId:=DEVICE_ID_ANY;
      Exit;
     end; 
    
    {Link Touch}
    if TouchDeviceTable = nil then
     begin
      TouchDeviceTable:=Touch;
     end
    else
     begin
      Touch.Next:=TouchDeviceTable;
      TouchDeviceTable.Prev:=Touch;
      TouchDeviceTable:=Touch;
     end;
 
    {Increment Count}
    Inc(TouchDeviceTableCount);
    
    {Check Default}
    if TouchDeviceDefault = nil then
     begin
      TouchDeviceDefault:=Touch;
     end;
    
    {Return Result}
    Result:=ERROR_SUCCESS;
   finally
    CriticalSectionUnlock(TouchDeviceTableLock);
   end;
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;  
end;

{==============================================================================}

function TouchDeviceDeregister(Touch:PTouchDevice):LongWord;
{Deregister an Touch device from the Touch device table}
var
 Prev:PTouchDevice;
 Next:PTouchDevice;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Touch}
 if Touch = nil then Exit;
 if Touch.TouchId = DEVICE_ID_ANY then Exit;
 if Touch.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {Check Touch}
 Result:=ERROR_NOT_FOUND;
 if TouchDeviceCheck(Touch) <> Touch then Exit;
 
 {Check State}
 if Touch.Device.DeviceState <> DEVICE_STATE_REGISTERED then Exit;
 
 {Remove Touch}
 if CriticalSectionLock(TouchDeviceTableLock) = ERROR_SUCCESS then
  begin
   try
    {Deregister Device}
    Result:=DeviceDeregister(@Touch.Device);
    if Result <> ERROR_SUCCESS then Exit;
    
    {Unlink Touch}
    Prev:=Touch.Prev;
    Next:=Touch.Next;
    if Prev = nil then
     begin
      TouchDeviceTable:=Next;
      if Next <> nil then
       begin
        Next.Prev:=nil;
       end;       
     end
    else
     begin
      Prev.Next:=Next;
      if Next <> nil then
       begin
        Next.Prev:=Prev;
       end;       
     end;     
 
    {Decrement Count}
    Dec(TouchDeviceTableCount);
 
    {Check Default}
    if TouchDeviceDefault = Touch then
     begin
      TouchDeviceDefault:=TouchDeviceTable;
     end;
 
    {Update Touch}
    Touch.TouchId:=DEVICE_ID_ANY;
 
    {Return Result}
    Result:=ERROR_SUCCESS;
   finally
    CriticalSectionUnlock(TouchDeviceTableLock);
   end;
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;  
end;

{==============================================================================}

function TouchDeviceFind(TouchId:LongWord):PTouchDevice;
var
 Touch:PTouchDevice;
begin
 {}
 Result:=nil;
 
 {Check Id}
 if TouchId = DEVICE_ID_ANY then Exit;
 
 {Acquire the Lock}
 if CriticalSectionLock(TouchDeviceTableLock) = ERROR_SUCCESS then
  begin
   try
    {Get Touch}
    Touch:=TouchDeviceTable;
    while Touch <> nil do
     begin
      {Check State}
      if Touch.Device.DeviceState = DEVICE_STATE_REGISTERED then
       begin
        {Check Id}
        if Touch.TouchId = TouchId then
         begin
          Result:=Touch;
          Exit;
         end;
       end;
       
      {Get Next}
      Touch:=Touch.Next;
     end;
   finally
    {Release the Lock}
    CriticalSectionUnlock(TouchDeviceTableLock);
   end;
  end;
end;

{==============================================================================}

function TouchDeviceFindByName(const Name:String):PTouchDevice; inline;
begin
 {}
 Result:=PTouchDevice(DeviceFindByName(Name));
end;

{==============================================================================}

function TouchDeviceFindByDescription(const Description:String):PTouchDevice; inline;
begin
 {}
 Result:=PTouchDevice(DeviceFindByDescription(Description));
end;
       
{==============================================================================}

function TouchDeviceEnumerate(Callback:TTouchEnumerate;Data:Pointer):LongWord;
var
 Touch:PTouchDevice;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Callback}
 if not Assigned(Callback) then Exit;
 
 {Acquire the Lock}
 if CriticalSectionLock(TouchDeviceTableLock) = ERROR_SUCCESS then
  begin
   try
    {Get Touch}
    Touch:=TouchDeviceTable;
    while Touch <> nil do
     begin
      {Check State}
      if Touch.Device.DeviceState = DEVICE_STATE_REGISTERED then
       begin
        if Callback(Touch,Data) <> ERROR_SUCCESS then Exit;
       end;
       
      {Get Next}
      Touch:=Touch.Next;
     end;
     
    {Return Result}
    Result:=ERROR_SUCCESS;
   finally
    {Release the Lock}
    CriticalSectionUnlock(TouchDeviceTableLock);
   end;
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;  
end;

{==============================================================================}

function TouchDeviceNotification(Touch:PTouchDevice;Callback:TTouchNotification;Data:Pointer;Notification,Flags:LongWord):LongWord;
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Touch}
 if Touch = nil then
  begin
   Result:=DeviceNotification(nil,DEVICE_CLASS_Touch,Callback,Data,Notification,Flags);
  end
 else
  begin 
   {Check Touch}
   if Touch.Device.Signature <> DEVICE_SIGNATURE then Exit;

   Result:=DeviceNotification(@Touch.Device,DEVICE_CLASS_TOUCH,Callback,Data,Notification,Flags);
  end; 
end;

{==============================================================================}
{==============================================================================}
{RTL Touch Functions}

{==============================================================================}
{==============================================================================}
{Touch Helper Functions}
function TouchGetCount:LongWord; inline;
{Get the current Touch device count}
begin
 {}
 Result:=TouchDeviceTableCount;
end;

{==============================================================================}

function TouchDeviceGetDefault:PTouchDevice; inline;
{Get the current default Touch device}
begin
 {}
 Result:=TouchDeviceDefault;
end;

{==============================================================================}

function TouchDeviceSetDefault(Touch:PTouchDevice):LongWord; 
{Set the current default Touch device}
begin
 {}
 Result:=ERROR_INVALID_PARAMETER;
 
 {Check Touch}
 if Touch = nil then Exit;
 if Touch.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {Acquire the Lock}
 if CriticalSectionLock(TouchDeviceTableLock) = ERROR_SUCCESS then
  begin
   try
    {Check Touch}
    if TouchDeviceCheck(Touch) <> Touch then Exit;
    
    {Set Touch Default}
    TouchDeviceDefault:=Touch;
    
    {Return Result}
    Result:=ERROR_SUCCESS;
   finally
    {Release the Lock}
    CriticalSectionUnlock(TouchDeviceTableLock);
   end;
  end
 else
  begin
   Result:=ERROR_CAN_NOT_COMPLETE;
  end;
end;

{==============================================================================}

function TouchDeviceCheck(Touch:PTouchDevice):PTouchDevice;
{Check if the supplied Touch device is in the Touch device table}
var
 Current:PTouchDevice;
begin
 {}
 Result:=nil;
 
 {Check Touch}
 if Touch = nil then Exit;
 if Touch.Device.Signature <> DEVICE_SIGNATURE then Exit;
 
 {Acquire the Lock}
 if CriticalSectionLock(TouchDeviceTableLock) = ERROR_SUCCESS then
  begin
   try
    {Get Touch}
    Current:=TouchDeviceTable;
    while Current <> nil do
     begin
      {Check Touch}
      if Current = Touch then
       begin
        Result:=Touch;
        Exit;
       end;
      
      {Get Next}
      Current:=Current.Next;
     end;
   finally
    {Release the Lock}
    CriticalSectionUnlock(TouchDeviceTableLock);
   end;
  end;
end;

{==============================================================================}

procedure TouchLog(Level:LongWord;Touch:PTouchDevice;const AText:String);
var
 WorkBuffer:String;
begin
 {}
 {Check Level}
 if Level < TOUCH_DEFAULT_LOG_LEVEL then Exit;
 
 WorkBuffer:='';
 {Check Level}
 if Level = TOUCH_LOG_LEVEL_DEBUG then
  begin
   WorkBuffer:=WorkBuffer + '[DEBUG] ';
  end
 else if Level = TOUCH_LOG_LEVEL_ERROR then
  begin
   WorkBuffer:=WorkBuffer + '[ERROR] ';
  end;
 
 {Add Prefix}
 WorkBuffer:=WorkBuffer + 'Touch: ';
 
 {Check Touch}
 if Touch <> nil then
  begin
   WorkBuffer:=WorkBuffer + TOUCH_NAME_PREFIX + IntToStr(Touch.TouchId) + ': ';
  end;

 {Output Logging}  
 LoggingOutputEx(LOGGING_FACILITY_TOUCH,LogLevelToLoggingSeverity(Level),'Touch',WorkBuffer + AText);
end;

{==============================================================================}

procedure TouchLogInfo(Touch:PTouchDevice;const AText:String); inline;
begin
 {}
 TouchLog(TOUCH_LOG_LEVEL_INFO,Touch,AText);
end;

{==============================================================================}

procedure TouchLogError(Touch:PTouchDevice;const AText:String); inline;
begin
 {}
 TouchLog(TOUCH_LOG_LEVEL_ERROR,Touch,AText);
end;

{==============================================================================}

procedure TouchLogDebug(Touch:PTouchDevice;const AText:String); inline;
begin
 {}
 TouchLog(TOUCH_LOG_LEVEL_DEBUG,Touch,AText);
end;

{==============================================================================}
{==============================================================================}

initialization
 TouchInit;

{==============================================================================}
 
finalization
 {Nothing}

{==============================================================================}
{==============================================================================}

end.
