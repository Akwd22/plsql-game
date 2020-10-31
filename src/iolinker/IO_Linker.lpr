program IO_Linker;

{$codepage UTF8}

uses
  Connection, Output, Event, Input, SysUtils, Windows;

// Permet de fermer la connexion en quittant l'application
function HandlerRoutine(dwCtrlType : DWORD) : WINBOOL; stdcall;
begin
  case dwCtrlType of
    CTRL_C_EVENT,
    CTRL_BREAK_EVENT,
    CTRL_CLOSE_EVENT,
    CTRL_LOGOFF_EVENT,
    CTRL_SHUTDOWN_EVENT :
      begin
        Connection.CloseCon();
        HandlerRoutine := True;
      end
  else
    HandlerRoutine := False
  end;
end;

var
  isConnected : Boolean;
  evt         : TEvent; // Évènement récupéré
  a : Integer;

begin
  isConnected := Connection.OpenCon();

  try
    if isConnected then
    begin
       SetConsoleCtrlHandler(@HandlerRoutine, true);
       Output.Init();
       Connection.StartMain();
    end;

    // Détecter en permanence les évènements reçu par PLSQL
    while isConnected do
    begin
      sleep(250);
      evt := Event.GetEvent();

      a := 0;
      //a := 5 DIV a;

      case evt.name of
        EVENT_PRINT  : Output.Print();  // Actualiser l'affichage de la console
        EVENT_INPUT  : Input.Capture(); // Capturer le clavier
        EVENT_CURSOR : Output.SetCursor(StrToInt(evt.param1), StrToInt(evt.param2)); // Modifier pos. curseur
      end;
    end;

    readln();
  finally
    Connection.CloseCon(); // Fermer la connexion en cas de crash inattendu
  end;
end.
