unit Connection; // Unit qui s'occupe de gérer la connexion avec le SGBD

{$codepage UTF8}

interface
uses SQLdb, OracleConnection;

var
  con : TOracleConnection;
  trans : TSQLTransaction;
  query : TSQLQuery;

procedure CloseCon();
function OpenCon() : Boolean;
procedure StartMain();

implementation
uses SysUtils;

// Fermer la connexion avec le SGBD
procedure CloseCon();
begin
  con.Close();
  query.Free();
  trans.Free();
  con.Free();

  writeln('Déconnecté.');
end;

// Ouvrir la connexion avec le SGBD
// Retourne vrai si connexion effectuée
function OpenCon() : Boolean;
begin
  con   := TOracleConnection.Create(nil);
  trans := TSQLTransaction.Create(nil);
  query := TSQLQuery.Create(nil);

  try
    writeln('Tentative de connexion avec Oracle Database...');

    // Informations de connexion
    con.hostname := 'localhost';
    con.username := 'skyiut';
    con.password := 'skyiut';
    con.databasename := 'XE';

    con.transaction := trans;
    query.database := con;
    con.open();
    trans.Active := true;

    OpenCon := true;
    writeln('Connecté.');
  except
    // Erreur de connexion (mauvais login, hors-ligne...)
    on e : Exception do
    begin
      OpenCon := false;
      writeln('Erreur de connexion - ', e.message);
      CloseCon();
    end;
  end;
end;

// Démarre le programme
procedure StartMain();
begin
  con.ExecuteDirect('begin main(); end;');
end;

end.
