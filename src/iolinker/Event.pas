unit Event; // Unit qui s'occupe de récupérer les évènements reçu par PLSQL

{$codepage UTF8}

interface

const
  EVENT_NONE   = 'none';   // Ne rien faire
  EVENT_PRINT  = 'print';  // Actualiser l'affichage
  EVENT_INPUT  = 'input';  // Capturer le clavier
  EVENT_CURSOR = 'cursor'; // Modifier la pos. du curseur

type
  TEvent = Record
    name   : String;
    param1 : String;
    param2 : String;
  end;

function GetEvent() : TEvent;

implementation
uses Connection, SysUtils;

// Retourner l'event actuel
function GetEvent() : TEvent;
var
  num   : String;
  event : TEvent;

begin
  event.name := EVENT_NONE;
  GetEvent := event;

  // Attrape les exceptions pour ne pas crasher car,
  // il peut y en avoir une si la table est modifiée au même moment
  try
    query.SQL.Text := 'SELECT * FROM IOLinker_Events ORDER BY Num';
    query.open();
    query.first();

    // Récupérer l'event s'il y en a un
    if not query.EOF then
    begin
      num          := query.Fields[0].AsString; // Champ 'Num'
      event.name   := query.Fields[1].AsString; // Champ 'Event'
      event.param1 := query.Fields[2].AsString; // Champ 'Param1'
      event.param2 := query.Fields[3].AsString; // Champ 'Param2'

      // Supprimer l'event de la table car on l'a récupéré
      con.ExecuteDirect('DELETE FROM IOLinker_Events WHERE Num = ' + #39 + num + #39);
      trans.Commit();
    end;

    query.close();
  except
  end;

  GetEvent := event; // Retourner l'event
end;

end.
