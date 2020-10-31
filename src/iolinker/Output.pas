unit Output; // Unit qui s'occupe de gérer l'affichage dans la console

{$codepage UTF8}

interface

procedure Init();
procedure Print();
procedure SetCursor(x, y : Integer);

implementation
uses Windows, Connection;

// Effacer l'écran
procedure ClrScreen();
var
  stdOutputHandle : Cardinal;
  cursorPos       : TCoord;
  width, height   : Cardinal;
  nbChars         : Cardinal;
  textAttr	  : Byte;

begin
  stdOutputHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  cursorPos := GetLargestConsoleWindowSize(stdOutputHandle);
  width := cursorPos.x;
  height := cursorPos.y;
  cursorPos.x := 0;
  cursorPos.y := 0;
  TextAttr := $0;
  FillConsoleOutputCharacter(stdOutputHandle, ' ', width*height, cursorPos, nbChars);
  FillConsoleOutputAttribute(stdOutputHandle, TextAttr, width*height, cursorPos, nbChars);
  cursorPos.x := 0;
  cursorPos.y := 0;
  SetConsoleCursorPosition(stdOutputHandle, cursorPos);
end;

// Initialiser la console
procedure Init();
const
  CONSOLE_WIDTH  = 200;
  CONSOLE_HEIGHT = 60;

var
  con  : THandle;
  size : TCoord;
  rect : TSmallRect;
  wnd  : HWND;

begin
  ClrScreen();

  con    := GetStdHandle(STD_OUTPUT_HANDLE);
  size   := GetLargestConsoleWindowSize(con);
  size.x := CONSOLE_WIDTH;
  size.y := CONSOLE_HEIGHT;

  SetConsoleScreenBufferSize(con, size);

  rect.left   := -10;
  rect.top    := -10;
  rect.right  := size.x-11;
  rect.bottom := size.y-11;
  SetConsoleWindowInfo(con, true, rect);

  wnd := GetConsoleWindow();

  SetWindowPos(wnd, 0, 0, 0, 0, 0, SWP_NOSIZE);
end;

// Actualiser l'affichage dans la console
procedure Print();
var
  col : Integer;

begin
  ClrScreen();

  try
    query.SQL.Text := 'SELECT * FROM IOLinker_Output ORDER BY LineNb';
    query.open();
    query.first();

    // Pour chaque ligne ...
    while not (query.EOF) do
    begin
      // ... afficher chaque caractère
      for col := 1 to query.Fields.Count - 1 do
      begin
        write(Chr(query.Fields[col].AsInteger));
      end;

      query.next();
      writeln(); // Nouvelle ligne
    end;

    query.close();
  except
  end;
end;

// Modifier la position du curseur
procedure SetCursor(x, y : Integer);
var
  stdOutputHandle : Cardinal;
  cursorPos       : TCoord;

begin
  stdOutputHandle := GetStdHandle(STD_OUTPUT_HANDLE);

  cursorPos.x := x;
  cursorPos.y := y;
  SetConsoleCursorPosition(stdOutputHandle, cursorPos);
end;

end.
