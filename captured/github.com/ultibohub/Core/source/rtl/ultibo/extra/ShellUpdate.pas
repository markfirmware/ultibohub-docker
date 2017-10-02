{
Ultibo Update Shell extension unit.

Copyright (C) 2015 - SoftOz Pty Ltd.

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

 

Shell Update
============

}

{$mode delphi} {Default to Delphi compatible syntax}
{$H+}          {Default to AnsiString}
{$inline on}   {Allow use of Inline procedures}

unit ShellUpdate;

interface

uses GlobalConfig,GlobalConst,GlobalTypes,Platform,Threads,Devices,FileSystem,SysUtils,Classes,Ultibo,UltiboClasses,UltiboUtils,Shell,HTTP;

//To Do //Look for:

//--

{==============================================================================}
{Global definitions}
{$INCLUDE ..\core\GlobalDefines.inc}

{==============================================================================}
const
 {Shell Update specific constants}
 SHELL_UPDATE_HTTP_SEPARATOR = '/';  
 SHELL_UPDATE_HTTP_PROTOCOL = 'http://';
 
 SHELL_UPDATE_EXTENSION_TMP = '.tmp';
 SHELL_UPDATE_EXTENSION_BAK = '.bak';
 
 {Shell Update Command constants}
 SHELL_UPDATE_COMMAND_UPDATE = 'UPDATE';
 SHELL_UPDATE_COMMAND_WGET   = 'WGET';

 {Shell Update Action constants}
 SHELL_UPDATE_ACTION_CHECK   = 'CHECK';
 SHELL_UPDATE_ACTION_GET     = 'GET';
 SHELL_UPDATE_ACTION_SET     = 'SET';

 {Shell Update Item constants}
 SHELL_UPDATE_ITEM_ALL            = 'ALL';
 SHELL_UPDATE_ITEM_KERNEL         = 'KERNEL';
 SHELL_UPDATE_ITEM_CONFIG         = 'CONFIG';
 SHELL_UPDATE_ITEM_COMMAND        = 'COMMAND';
 
 SHELL_UPDATE_ITEM_HTTP_SERVER    = 'SERVER';
 SHELL_UPDATE_ITEM_HTTP_PATH      = 'REMOTE';
 SHELL_UPDATE_ITEM_LOCAL_PATH     = 'LOCAL';
 SHELL_UPDATE_ITEM_KERNEL_IMAGE   = 'IMAGE';
 SHELL_UPDATE_ITEM_KERNEL_CONFIG  = 'CONFIG';
 SHELL_UPDATE_ITEM_KERNEL_COMMAND = 'COMMAND';
 
 {Shell Update Parameter constants}
 SHELL_UPDATE_PARAMETER_REBOOT      = 'R';
 SHELL_UPDATE_PARAMETER_FORCE       = 'F';

{==============================================================================}
{type}
 {Shell Update specific types}
 
{==============================================================================}
type
 {Shell Update specific clases}
 TShellUpdate = class(TShellCommand)
 public
  {}
  constructor Create;
 private
  {Internal Variables}
 
  {Internal Methods}
  function GetLocal(const AName:String):String;
  function GetRemote(const AName:String):String;
 protected
  {Internal Variables}

  {Internal Methods}
  
  function UpdateGet(AShell:TShell;ASession:TShellSession;const ALocal,ARemote:String;AForce:Boolean;var AUpdate:Boolean):Boolean;
  function UpdateCheck(AShell:TShell;ASession:TShellSession;const ALocal,ARemote:String;AForce:Boolean;var AUpdate:Boolean):Boolean;
 public
  {Public Properties}

  {Public Methods}
  function DoHelp(AShell:TShell;ASession:TShellSession):Boolean; override;
  function DoInfo(AShell:TShell;ASession:TShellSession):Boolean; override;
  function DoCommand(AShell:TShell;ASession:TShellSession;AParameters:TStrings):Boolean; override;
 end;
 
 //TShellWGET = class(TShellCommand) //To Do //Simple WGET 
  
{==============================================================================}
var
 {Shell Update specific variables}
 SHELL_UPDATE_HTTP_SERVER:String;    {Name or IP of http server for updates (eg 192.168.0.1)}
 SHELL_UPDATE_HTTP_PATH:String;      {URL path on http server for updates (eg /updates/)}
 SHELL_UPDATE_LOCAL_PATH:String;     {Local path for updates (eg C:\)}
 SHELL_UPDATE_KERNEL_IMAGE:String;   {Name of the kernel image file for updates (eg kernel.img)}
 SHELL_UPDATE_KERNEL_CONFIG:String;  {Name of the kernel config file for updates (eg config.txt)}
 SHELL_UPDATE_KERNEL_COMMAND:String; {Name of the kernel command file for updates (eg cmdline.txt)}

{==============================================================================}
{Initialization Functions}
procedure ShellUpdateInit;

{==============================================================================}
{Shell Update Functions}
 
{==============================================================================}
{Shell Update Helper Functions}
 
{==============================================================================}
{==============================================================================}

implementation

{==============================================================================}
{==============================================================================}
var
 {Shell Update specific variables}
 ShellUpdateInitialized:Boolean;
 
{==============================================================================}
{==============================================================================}
{TShellUpdate}
constructor TShellUpdate.Create;
begin
 {}
 inherited Create;

 Name:=SHELL_UPDATE_COMMAND_UPDATE;
 Flags:=SHELL_COMMAND_FLAG_INFO or SHELL_COMMAND_FLAG_HELP;
end;

{==============================================================================}

function TShellUpdate.GetLocal(const AName:String):String;
begin
 {}
 Result:='';
 
 {Check Name}
 if Length(AName) = 0 then Exit;
 
 {Get Local}
 Result:=SHELL_UPDATE_LOCAL_PATH + AName;
end;

{==============================================================================}

function TShellUpdate.GetRemote(const AName:String):String;
var
 WorkBuffer:String;
begin
 {}
 Result:='';
 
 {Check Name}
 if Length(AName) = 0 then Exit;
 
 {Get Path}
 WorkBuffer:=SHELL_UPDATE_HTTP_PATH;
 if Length(WorkBuffer) = 0 then WorkBuffer:=SHELL_UPDATE_HTTP_SEPARATOR;
 
 {Get Remote}
 Result:=SHELL_UPDATE_HTTP_PROTOCOL + SHELL_UPDATE_HTTP_SERVER + AddLeadingChar(WorkBuffer,SHELL_UPDATE_HTTP_SEPARATOR) + AName;
end;

{==============================================================================}

function TShellUpdate.UpdateGet(AShell:TShell;ASession:TShellSession;const ALocal,ARemote:String;AForce:Boolean;var AUpdate:Boolean):Boolean;
var
 TempName:String;
 BackupName:String;
 FileStream:TFSFileStream;
 
 HTTPClient:THTTPClient;
begin
 {}
 Result:=False;
 
 {Check Update}
 if UpdateCheck(AShell,ASession,ALocal,ARemote,AForce,AUpdate) then
  begin
   if AUpdate then
    begin
     {Get Temp Name}
     TempName:=ChangeFileExt(ALocal,SHELL_UPDATE_EXTENSION_TMP);
     AShell.DoOutput(ASession,'  Saving update to temporary file ' + TempName); 
     
     {Check Temp File}
     if FSFileExists(TempName) then
      begin
       AShell.DoOutput(ASession,'  Deleting existing temporary file ' + TempName); 
       
       {Temp Backup File}
       FSFileSetAttr(TempName,faNone);
       if not FSDeleteFile(TempName) then Exit;
      end;
     
     {Create Client}
     HTTPClient:=THTTPClient.Create;
     try
      {Set Receive Size}
      HTTPClient.ReceiveSize:=SIZE_2M; //To Do //This doesn't work until after Connect (Add to TWinsockTCPClient)
      try
       {Create Temp File}
       FileStream:=TFSFileStream.Create(TempName,fmCreate);
       try
        {GET Request}
        if HTTPClient.GetStream(ARemote,FileStream) then
         begin
          {Check Status}
          case HTTPClient.ResponseStatus of
           HTTP_STATUS_OK:begin
             AUpdate:=True;
             
             {Set Date/Time}
             FSFileSetDate(FileStream.Handle,FileTimeToFileDate(RoundFileTime(HTTPDateToFileTime(HTTPClient.GetResponseHeader(HTTP_ENTITY_HEADER_LAST_MODIFIED)))));
            end;
           else
            begin
             AUpdate:=False;
             
             AShell.DoOutput(ASession,'  HTTP GET request not successful (Status=' + HTTPStatusToString(HTTPClient.ResponseStatus) + ' Reason=' + HTTPClient.ResponseReason + ')'); 
             AShell.DoOutput(ASession,''); 
            end;
          end;
         end
        else
         begin
          AUpdate:=False;
          
          AShell.DoOutput(ASession,'  HTTP GET request failed (Status=' + HTTPStatusToString(HTTPClient.ResponseStatus) + ' Reason=' + HTTPClient.ResponseReason + ')'); 
          AShell.DoOutput(ASession,''); 
         end;     
       finally
        FileStream.Free;
       end;
      except
       AUpdate:=False;
       
       AShell.DoOutput(ASession,'  Failed to create temporary file ' + TempName);
       AShell.DoOutput(ASession,''); 
      end;      
     finally
      HTTPClient.Free;
     end;
  
     if AUpdate then
      begin
       {Check Local File}
       if FSFileExists(ALocal) then
        begin
         {Get Backup Name}
         BackupName:=ChangeFileExt(ALocal,SHELL_UPDATE_EXTENSION_BAK);
         
         AShell.DoOutput(ASession,'  Saving file ' + ALocal +  ' to backup file ' + BackupName); 
         
         {Check Backup File}
         if FSFileExists(BackupName) then
          begin
           AShell.DoOutput(ASession,'  Deleting existing backup file ' + BackupName); 
           
           {Delete Backup File}
           FSFileSetAttr(BackupName,faNone);
           if not FSDeleteFile(BackupName) then Exit;
          end;
         
         {Rename Local File}
         if not FSRenameFile(ALocal,BackupName) then Exit;
        end;
       
       AShell.DoOutput(ASession,'  Saving temporary file ' + TempName +  ' to ' + ALocal); 
       
       {Rename Temporary File}
       if not FSRenameFile(TempName,ALocal) then Exit;
       
       AShell.DoOutput(ASession,''); 
       AShell.DoOutput(ASession,'  Successfully updated ' + ALocal); 
      end;
    
     AShell.DoOutput(ASession,''); 
    end;
  end;
 
 {Return Result}
 Result:=True; 
end;

{==============================================================================}

function TShellUpdate.UpdateCheck(AShell:TShell;ASession:TShellSession;const ALocal,ARemote:String;AForce:Boolean;var AUpdate:Boolean):Boolean;
var
 LocalSize:Int64;
 RemoteSize:Int64;
 LocalTime:TDateTime;
 RemoteTime:TDateTime;
 LocalExists:Boolean;
 RemoteExists:Boolean;
 SearchRec:TFileSearchRec;
 
 HTTPClient:THTTPClient;
begin
 {}
 Result:=False;
 
 {Set Update}
 AUpdate:=False;
 
 {Check Paths}
 if (Length(ALocal) <> 0) and (Length(ARemote) <> 0) then
  begin
   {Local File} 
   LocalExists:=False;
   
   AShell.DoOutput(ASession,' Local file is ' + ALocal);
   
   {Find First}
   if FSFindFirstEx(ALocal,SearchRec) = 0 then
    begin
     LocalExists:=True;

     {Get Size/Time}
     TULargeInteger(LocalSize).HighPart:=SearchRec.FindData.nFileSizeHigh;
     TULargeInteger(LocalSize).LowPart:=SearchRec.FindData.nFileSizeLow;
     LocalTime:=FileTimeToDateTime(SearchRec.FindData.ftLastWriteTime);
     
     AShell.DoOutput(ASession,'  Size: ' + IntToStr(LocalSize)); 
     AShell.DoOutput(ASession,'  Modified: ' + DateTimeToStr(LocalTime)); 
     AShell.DoOutput(ASession,''); 
     
     FSFindCloseEx(SearchRec);
    end
   else
    begin
     AShell.DoOutput(ASession,'  File does not exist'); 
     AShell.DoOutput(ASession,''); 
    end;  
  
   {Remote File}
   RemoteExists:=False;
   
   AShell.DoOutput(ASession,' Remote file is ' + ARemote);
   
   {Create Client}
   HTTPClient:=THTTPClient.Create;
   try
    {HEAD Request}
    if HTTPClient.Head(ARemote) then
     begin
      {Check Status}
      case HTTPClient.ResponseStatus of
       HTTP_STATUS_OK:begin
         RemoteExists:=True;
         
         {Get Size/Time}
         RemoteSize:=HTTPClient.ResponseContentSize;
         RemoteTime:=FileTimeToDateTime(RoundFileTime(HTTPDateToFileTime(HTTPClient.GetResponseHeader(HTTP_ENTITY_HEADER_LAST_MODIFIED))));

         AShell.DoOutput(ASession,'  Size: ' + IntToStr(RemoteSize)); 
         AShell.DoOutput(ASession,'  Modified: ' + DateTimeToStr(RemoteTime)); 
         AShell.DoOutput(ASession,''); 
        end;
       else
        begin
         AShell.DoOutput(ASession,'  HTTP HEAD request not successful (Status=' + HTTPStatusToString(HTTPClient.ResponseStatus) + ' Reason=' + HTTPClient.ResponseReason + ')'); 
         AShell.DoOutput(ASession,''); 
        end;
      end;
     end
    else
     begin
      AShell.DoOutput(ASession,'  HTTP HEAD request failed (Status=' + HTTPStatusToString(HTTPClient.ResponseStatus) + ' Reason=' + HTTPClient.ResponseReason + ')'); 
      AShell.DoOutput(ASession,''); 
     end;     
   finally
    HTTPClient.Free;
   end;

   if LocalExists and RemoteExists then
    begin
     if (AForce) then
      begin
       AUpdate:=True;
       
       AShell.DoOutput(ASession,'  Forcing update'); 
      end
     else if (LocalSize <> RemoteSize) or (LocalTime <> RemoteTime) then
      begin
       AUpdate:=True;
       
       AShell.DoOutput(ASession,'  Update is available'); 
      end
     else
      begin         
       AShell.DoOutput(ASession,'  No update available'); 
      end; 
    end
   else if LocalExists and not(RemoteExists) then
    begin
     AShell.DoOutput(ASession,'  No update available'); 
    end
   else if not(LocalExists) and RemoteExists then
    begin
     AUpdate:=True;
     
     AShell.DoOutput(ASession,'  Update is available'); 
    end
   else
    begin
     AShell.DoOutput(ASession,'  No update available'); 
    end;
   
   AShell.DoOutput(ASession,''); 
  end;
  
 {Return Result}
 Result:=True; 
end;

{==============================================================================}

function TShellUpdate.DoHelp(AShell:TShell;ASession:TShellSession):Boolean; 
begin
 {}
 Result:=False;
 
 {Check Shell}
 if AShell = nil then Exit;
 
 {Do Help}
 AShell.DoOutput(ASession,'Get or display available kernel updates from a http server');
 AShell.DoOutput(ASession,'');
 AShell.DoOutput(ASession,' ' + Name + ' CHECK <ITEM>      (Display available kernel item updates and information)');
 AShell.DoOutput(ASession,' ' + Name + ' GET <ITEM>        (Get a kernel item update from a http server)');
 AShell.DoOutput(ASession,' ' + Name + ' SET <PARAMETER>   (Set kernel item update parameters)');
 AShell.DoOutput(ASession,'');
 AShell.DoOutput(ASession,'   Check/Get Items:');
 AShell.DoOutput(ASession,'    ALL     - Get or check all items');
 AShell.DoOutput(ASession,'    KERNEL  - Get or check the kernel image');
 AShell.DoOutput(ASession,'    CONFIG  - Get or check the kernel config file');
 AShell.DoOutput(ASession,'    COMMAND - Get or check the kernel command file');
 AShell.DoOutput(ASession,'');
 AShell.DoOutput(ASession,'   Set Parameters:');
 AShell.DoOutput(ASession,'    SERVER  - Set the name or IP of the http URL');
 AShell.DoOutput(ASession,'    REMOTE  - Set the remote path of the http URL');
 AShell.DoOutput(ASession,'    LOCAL   - Set the local path for updates');
 AShell.DoOutput(ASession,'    IMAGE   - Set the name of the kernel image file');
 AShell.DoOutput(ASession,'    CONFIG  - Set the name of the kernel config file');
 AShell.DoOutput(ASession,'    COMMAND - Set the name of the kernel command file');
 AShell.DoOutput(ASession,'');
 AShell.DoOutput(ASession,'   Optional Parameters:');
 AShell.DoOutput(ASession,'    /R      - Reboot after successfully getting new kernel items');
 AShell.DoOutput(ASession,'    /F      - Force an update even if available items are unchanged');
 AShell.DoOutput(ASession,'');
 AShell.DoOutput(ASession,'   Examples:');
 AShell.DoOutput(ASession,'    ' + Name + ' GET KERNEL');
 AShell.DoOutput(ASession,'    ' + Name + ' CHECK CONFIG');
 AShell.DoOutput(ASession,'    ' + Name + ' GET ALL /R');
 AShell.DoOutput(ASession,'    ' + Name + ' SET SERVER 192.168.0.1');
 AShell.DoOutput(ASession,'');
 AShell.DoOutput(ASession,'   ' + Name + ' with no parameters is equivalent to CHECK ALL');
 AShell.DoOutput(ASession,'   ' + Name + ' GET is equivalent to GET KERNEL');
 AShell.DoOutput(ASession,'');
 
 {Return Result}
 Result:=True;
end;
 
{==============================================================================}

function TShellUpdate.DoInfo(AShell:TShell;ASession:TShellSession):Boolean; 
begin
 {}
 Result:=False;
 
 {Check Shell}
 if AShell = nil then Exit;
 
 {Do Info}
 Result:=AShell.DoOutput(ASession,'Get or display available kernel updates from a http server');
end;

{==============================================================================}

function TShellUpdate.DoCommand(AShell:TShell;ASession:TShellSession;AParameters:TStrings):Boolean; 
var 
 Item:String;
 Action:String;
 Force:Boolean;
 Reboot:Boolean;
 Update:Boolean;
 Updated:Boolean;
 Parameter:String;
begin
 {}
 Result:=False;
 
 {Check Shell}
 if AShell = nil then Exit;

 {Check Parameters}
 if AParameters = nil then Exit;
 
 {Get Action}
 Action:=AShell.ParameterIndex(0,AParameters);
 
 {Check Action}
 if (Length(Action) = 0) or (Uppercase(Action) = SHELL_UPDATE_ACTION_CHECK) then
  begin
   AShell.DoOutput(ASession,'Update Check');
   AShell.DoOutput(ASession,'------------');
   AShell.DoOutput(ASession,'');
   AShell.DoOutput(ASession,' Current parameters:');
   AShell.DoOutput(ASession,'  HTTP server:         ' + SHELL_UPDATE_HTTP_SERVER);
   AShell.DoOutput(ASession,'  Remote path:         ' + SHELL_UPDATE_HTTP_PATH);
   AShell.DoOutput(ASession,'  Local path:          ' + SHELL_UPDATE_LOCAL_PATH);
   AShell.DoOutput(ASession,'  Kernel image file:   ' + SHELL_UPDATE_KERNEL_IMAGE);
   AShell.DoOutput(ASession,'  Kernel config file:  ' + SHELL_UPDATE_KERNEL_CONFIG);
   AShell.DoOutput(ASession,'  Kernel command file: ' + SHELL_UPDATE_KERNEL_COMMAND);
   AShell.DoOutput(ASession,'');
   
   {Get Item}
   Item:=AShell.ParameterIndex(1,AParameters);
   
   {Get Options}
   Update:=False;
   
   {Check Item}
   if (Length(Item) = 0) or (Uppercase(Item) = SHELL_UPDATE_ITEM_ALL) then
    begin
     AShell.DoOutput(ASession,' Checking all items');
     AShell.DoOutput(ASession,''); 
     
     {Check KERNEL_IMAGE}
     if not UpdateCheck(AShell,ASession,GetLocal(SHELL_UPDATE_KERNEL_IMAGE),GetRemote(SHELL_UPDATE_KERNEL_IMAGE),False,Update) then Exit;

     {Check KERNEL_CONFIG}
     if not UpdateCheck(AShell,ASession,GetLocal(SHELL_UPDATE_KERNEL_CONFIG),GetRemote(SHELL_UPDATE_KERNEL_CONFIG),False,Update) then Exit;

     {Check KERNEL_COMMAND}
     if not UpdateCheck(AShell,ASession,GetLocal(SHELL_UPDATE_KERNEL_COMMAND),GetRemote(SHELL_UPDATE_KERNEL_COMMAND),False,Update) then Exit;
     
     {Return Result}
     Result:=True;
    end
   else if Uppercase(Item) = SHELL_UPDATE_ITEM_KERNEL then 
    begin
     AShell.DoOutput(ASession,' Checking kernel image file');
     AShell.DoOutput(ASession,''); 

     {Check KERNEL_IMAGE}
     Result:=UpdateCheck(AShell,ASession,GetLocal(SHELL_UPDATE_KERNEL_IMAGE),GetRemote(SHELL_UPDATE_KERNEL_IMAGE),False,Update);
    end
   else if Uppercase(Item) = SHELL_UPDATE_ITEM_CONFIG then 
    begin
     AShell.DoOutput(ASession,' Checking kernel config file');
     AShell.DoOutput(ASession,''); 
     
     {Check KERNEL_CONFIG}
     Result:=UpdateCheck(AShell,ASession,GetLocal(SHELL_UPDATE_KERNEL_CONFIG),GetRemote(SHELL_UPDATE_KERNEL_CONFIG),False,Update);
    end
   else if Uppercase(Item) = SHELL_UPDATE_ITEM_COMMAND then 
    begin
     AShell.DoOutput(ASession,' Checking kernel command file');
     AShell.DoOutput(ASession,''); 
     
     {Check KERNEL_COMMAND}
     Result:=UpdateCheck(AShell,ASession,GetLocal(SHELL_UPDATE_KERNEL_COMMAND),GetRemote(SHELL_UPDATE_KERNEL_COMMAND),False,Update);
    end
   else
    begin
     {Show Error}
     Result:=AShell.DoError(ASession);
    end;
  end
 else if Uppercase(Action) = SHELL_UPDATE_ACTION_GET then
  begin
   AShell.DoOutput(ASession,'Update Get');
   AShell.DoOutput(ASession,'----------');
   AShell.DoOutput(ASession,'');
   AShell.DoOutput(ASession,' Current parameters:');
   AShell.DoOutput(ASession,'  HTTP server:         ' + SHELL_UPDATE_HTTP_SERVER);
   AShell.DoOutput(ASession,'  Remote path:         ' + SHELL_UPDATE_HTTP_PATH);
   AShell.DoOutput(ASession,'  Local path:          ' + SHELL_UPDATE_LOCAL_PATH);
   AShell.DoOutput(ASession,'  Kernel image file:   ' + SHELL_UPDATE_KERNEL_IMAGE);
   AShell.DoOutput(ASession,'  Kernel config file:  ' + SHELL_UPDATE_KERNEL_CONFIG);
   AShell.DoOutput(ASession,'  Kernel command file: ' + SHELL_UPDATE_KERNEL_COMMAND);
   AShell.DoOutput(ASession,'');
  
   {Get Item}
   Item:=AShell.ParameterIndex(1,AParameters);
   
   {Get Options}
   Force:=AShell.ParameterExists(SHELL_UPDATE_PARAMETER_FORCE,AParameters);
   Reboot:=AShell.ParameterExists(SHELL_UPDATE_PARAMETER_REBOOT,AParameters);
   Update:=False;
   
   {Check Item}
   if Uppercase(Item) = SHELL_UPDATE_ITEM_ALL then
    begin
     AShell.DoOutput(ASession,' Getting all items');
     AShell.DoOutput(ASession,''); 

     Updated:=False;
     
     {Get KERNEL_IMAGE}
     if not UpdateGet(AShell,ASession,GetLocal(SHELL_UPDATE_KERNEL_IMAGE),GetRemote(SHELL_UPDATE_KERNEL_IMAGE),Force,Update) then Exit;
     if not Updated then Updated:=Update;
     
     {Get KERNEL_CONFIG}
     if not UpdateGet(AShell,ASession,GetLocal(SHELL_UPDATE_KERNEL_CONFIG),GetRemote(SHELL_UPDATE_KERNEL_CONFIG),Force,Update) then Exit;
     if not Updated then Updated:=Update;
     
     {Get KERNEL_COMMAND}
     if not UpdateGet(AShell,ASession,GetLocal(SHELL_UPDATE_KERNEL_COMMAND),GetRemote(SHELL_UPDATE_KERNEL_COMMAND),Force,Update) then Exit;
     if not Updated then Updated:=Update;
     
     {Return Result}
     Result:=True;
     
     {Check Reboot}
     if Result and Updated and Reboot then
      begin
       {Flush Cache}
       //To Do
       
       {Restart System}
       SystemRestart(1000);
      end;
    end
   else if (Length(Item) = 0) or (Uppercase(Item) = SHELL_UPDATE_ITEM_KERNEL) then 
    begin
     AShell.DoOutput(ASession,' Getting kernel image file');
     AShell.DoOutput(ASession,''); 

     {Get KERNEL_IMAGE}
     Result:=UpdateGet(AShell,ASession,GetLocal(SHELL_UPDATE_KERNEL_IMAGE),GetRemote(SHELL_UPDATE_KERNEL_IMAGE),Force,Update);

     {Check Reboot}
     if Result and Update and Reboot then
      begin
       {Flush Cache}
       //To Do
       
       {Restart System}
       SystemRestart(1000);
      end;
    end
   else if Uppercase(Item) = SHELL_UPDATE_ITEM_CONFIG then 
    begin
     AShell.DoOutput(ASession,' Getting kernel config file');
     AShell.DoOutput(ASession,''); 

     {Get KERNEL_CONFIG}
     Result:=UpdateGet(AShell,ASession,GetLocal(SHELL_UPDATE_KERNEL_CONFIG),GetRemote(SHELL_UPDATE_KERNEL_CONFIG),Force,Update);

     {Check Reboot}
     if Result and Update and Reboot then
      begin
       {Flush Cache}
       //To Do
       
       {Restart System}
       SystemRestart(1000);
      end;
    end
   else if Uppercase(Item) = SHELL_UPDATE_ITEM_COMMAND then 
    begin
     AShell.DoOutput(ASession,' Getting kernel command file');
     AShell.DoOutput(ASession,''); 

     {Get KERNEL_COMMAND}
     Result:=UpdateGet(AShell,ASession,GetLocal(SHELL_UPDATE_KERNEL_COMMAND),GetRemote(SHELL_UPDATE_KERNEL_COMMAND),Force,Update);

     {Check Reboot}
     if Result and Update and Reboot then
      begin
       {Flush Cache}
       //To Do
       
       {Restart System}
       SystemRestart(1000);
      end;
    end
   else
    begin
     {Show Error}
     Result:=AShell.DoError(ASession);
    end;
  end
 else if Uppercase(Action) = SHELL_UPDATE_ACTION_SET then
  begin
   {Get Item}
   Item:=AShell.ParameterIndex(1,AParameters);
   
   {Check Item}
   if Uppercase(Item) = SHELL_UPDATE_ITEM_HTTP_SERVER then
    begin
     {Get Parameter}
     Parameter:=AShell.ParameterIndex(2,AParameters);
  
     {Set HTTP_SERVER}
     AShell.DoOutput(ASession,'Setting HTTP server to ' + Parameter);
     SHELL_UPDATE_HTTP_SERVER:=Parameter;
   
     {Return Result}
     Result:=True;
    end
   else if Uppercase(Item) = SHELL_UPDATE_ITEM_HTTP_PATH then 
    begin
     {Get Parameter}
     Parameter:=AShell.ParameterIndex(2,AParameters);
  
     {Set HTTP_PATH}
     AShell.DoOutput(ASession,'Setting remote path to ' + Parameter);
     SHELL_UPDATE_HTTP_PATH:=Parameter;
   
     {Return Result}
     Result:=True;
    end
   else if Uppercase(Item) = SHELL_UPDATE_ITEM_LOCAL_PATH then 
    begin
     {Get Parameter}
     Parameter:=AShell.ParameterIndex(2,AParameters);
  
     {Set LOCAL_PATH}
     AShell.DoOutput(ASession,'Setting local path to ' + Parameter);
     SHELL_UPDATE_LOCAL_PATH:=Parameter;
   
     {Return Result}
     Result:=True;
    end
   else if Uppercase(Item) = SHELL_UPDATE_ITEM_KERNEL_IMAGE then 
    begin
     {Get Parameter}
     Parameter:=AShell.ParameterIndex(2,AParameters);
  
     {Set KERNEL_IMAGE}
     AShell.DoOutput(ASession,'Setting kernel image file name to ' + Parameter);
     SHELL_UPDATE_KERNEL_IMAGE:=Parameter;
   
     {Return Result}
     Result:=True;
    end
   else if Uppercase(Item) = SHELL_UPDATE_ITEM_KERNEL_CONFIG then 
    begin
     {Get Parameter}
     Parameter:=AShell.ParameterIndex(2,AParameters);
  
     {Set KERNEL_CONFIG}
     AShell.DoOutput(ASession,'Setting kernel config file name to ' + Parameter);
     SHELL_UPDATE_KERNEL_CONFIG:=Parameter;
   
     {Return Result}
     Result:=True;
    end
   else if Uppercase(Item) = SHELL_UPDATE_ITEM_KERNEL_COMMAND then 
    begin
     {Get Parameter}
     Parameter:=AShell.ParameterIndex(2,AParameters);
  
     {Update KERNEL_COMMAND}
     AShell.DoOutput(ASession,'Setting kernel command file name to ' + Parameter);
     
     SHELL_UPDATE_KERNEL_COMMAND:=Parameter;
   
     {Return Result}
     Result:=True;
    end
   else
    begin
     {Show Error}
     Result:=AShell.DoError(ASession);
    end;
  end
 else
  begin
   {Show Error}
   Result:=AShell.DoError(ASession);
  end;  
end;
 
{==============================================================================}
{==============================================================================}
{Initialization Functions}
procedure ShellUpdateInit;
var
 WorkBuffer:String;
begin
 {}
 {Check Initialized}
 if ShellUpdateInitialized then Exit;
 
 {Register FileSystem Commands}
 ShellRegisterCommand(TShellUpdate.Create);
 
 {Setup Defaults}
 SHELL_UPDATE_HTTP_SERVER:='127.0.0.1';
 SHELL_UPDATE_HTTP_PATH:='/';
 SHELL_UPDATE_LOCAL_PATH:='C:\';
 SHELL_UPDATE_KERNEL_IMAGE:=KERNEL_NAME;  
 SHELL_UPDATE_KERNEL_CONFIG:=KERNEL_CONFIG; 
 SHELL_UPDATE_KERNEL_COMMAND:=KERNEL_COMMAND;
 
 {Check Environment Variables}
 {SHELL_UPDATE_HTTP_SERVER}
 WorkBuffer:=SysUtils.GetEnvironmentVariable('SHELL_UPDATE_HTTP_SERVER');
 if Length(WorkBuffer) <> 0 then SHELL_UPDATE_HTTP_SERVER:=WorkBuffer;
  
 {SHELL_UPDATE_HTTP_PATH}
 WorkBuffer:=SysUtils.GetEnvironmentVariable('SHELL_UPDATE_HTTP_PATH');
 if Length(WorkBuffer) <> 0 then SHELL_UPDATE_HTTP_PATH:=WorkBuffer;

 {SHELL_UPDATE_LOCAL_PATH}
 WorkBuffer:=SysUtils.GetEnvironmentVariable('SHELL_UPDATE_LOCAL_PATH');
 if Length(WorkBuffer) <> 0 then SHELL_UPDATE_LOCAL_PATH:=WorkBuffer;

 {SHELL_UPDATE_KERNEL_IMAGE}
 WorkBuffer:=SysUtils.GetEnvironmentVariable('SHELL_UPDATE_KERNEL_IMAGE');
 if Length(WorkBuffer) <> 0 then SHELL_UPDATE_KERNEL_IMAGE:=WorkBuffer;

 {SHELL_UPDATE_KERNEL_CONFIG}
 WorkBuffer:=SysUtils.GetEnvironmentVariable('SHELL_UPDATE_KERNEL_CONFIG');
 if Length(WorkBuffer) <> 0 then SHELL_UPDATE_KERNEL_CONFIG:=WorkBuffer;

 {SHELL_UPDATE_KERNEL_COMMAND}
 WorkBuffer:=SysUtils.GetEnvironmentVariable('SHELL_UPDATE_KERNEL_COMMAND');
 if Length(WorkBuffer) <> 0 then SHELL_UPDATE_KERNEL_COMMAND:=WorkBuffer;
 
 ShellUpdateInitialized:=True;
end;
 
{==============================================================================}
{==============================================================================}
{Shell Update Functions}
 
{==============================================================================}
{==============================================================================}
{Shell Update Helper Functions}
 
{==============================================================================}
{==============================================================================}

initialization
 ShellUpdateInit;

{==============================================================================}
 
finalization
 {Nothing}

{==============================================================================}
{==============================================================================}
 
end.
  