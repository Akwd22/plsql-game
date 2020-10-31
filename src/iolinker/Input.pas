unit Input; // Unit qui s'occupe de gérer la saisie du clavier

{$codepage UTF8}

interface

procedure Capture();

implementation
uses Keyboard, Connection;

// Capturer la saisie du clavier
procedure Capture();
var
  key : TKeyEvent;
  str : String;

begin
  // Capturer la saisie d'une touche
  InitKeyboard();
  key := GetKeyEvent();
  key := TranslateKeyEvent(key);
  str := KeyEventToString(key);
  DoneKeyboard();

  // Transmettre la saisie à PLSQL
  con.ExecuteDirect('INSERT INTO IOLinker_Input VALUES (' + #39 + str + #39 + ')');
  trans.Commit();
end;

end.
