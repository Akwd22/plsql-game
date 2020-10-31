SET AUTOCOMMIT ON;

/* DDL pour faire la liaison entre le SGBD et la console externe (linker) */
-- Table qui permet de transmettre un évènement au linker
-- TODO : documenter events
DROP TABLE IOLinker_Events;
CREATE TABLE IOLinker_Events (
    Num         NUMBER PRIMARY KEY,
    Event       VARCHAR2(16),                     -- Nom de l'event
    Param1      VARCHAR2(16), Param2 VARCHAR2(16) -- Paramètres
);

DROP SEQUENCE EventNum_Seq;
CREATE SEQUENCE EventNum_Seq;
INSERT INTO IOLinker_Events VALUES (EventNum_Seq.NEXTVAL, 'none', NULL, NULL);
    
-- Table qui permet de transmettre quelque chose à afficher à l'écran
DROP TABLE IOLinker_Output;
CREATE TABLE IOLinker_Output (
    LineNb NUMBER PRIMARY KEY
);

BEGIN
    FOR i IN 1 .. 199 LOOP
        EXECUTE IMMEDIATE 'ALTER TABLE IOLinker_Output ADD x' || i || ' NUMBER(3,0)';
    END LOOP;
END;
/

-- Table qui permet de récupérer la touche appuyée transmise par le linker
DROP TABLE IOLinker_Input;
CREATE TABLE IOLinker_Input (KeyName VARCHAR2(16));

/* Package */
-- Interface (partie publique)
CREATE OR REPLACE PACKAGE Console_API AS
    hasInput BOOLEAN DEFAULT FALSE; -- Indique si une touche a été transmise par le linker
    
    PROCEDURE AskRefresh;
    PROCEDURE SetCursorPos(x IN NUMBER, y IN NUMBER);
    PROCEDURE ClearScreen;
    PROCEDURE DrawFrame(x1 IN NUMBER, y1 IN NUMBER, x2 IN NUMBER, y2 IN NUMBER, isDouble IN BOOLEAN);
    PROCEDURE WriteAt(x IN NUMBER, y IN NUMBER, str NVARCHAR2);
    PROCEDURE EraseZone(x1 IN NUMBER, y1 IN NUMBER, x2 IN NUMBER, y2 IN NUMBER);
    FUNCTION GetInput RETURN IOLinker_Input.KeyName%TYPE;
    PROCEDURE AskInput;
END;
/

-- Implémentation
CREATE OR REPLACE PACKAGE BODY Console_API AS
    /* Membres privés */
    TYPE TCols IS VARRAY(199) OF NCHAR; -- Colonnes de la console (unicode)
    TYPE TLines IS VARRAY(59) OF TCols; -- Lignes de la console
    scrn TLines; -- Représente l'écran de la console
    
    /* Membres publics */
    -- Transmet l'affichage au linker
    PROCEDURE AskRefresh IS
        a RAW(1);
        b BINARY_INTEGER;
        c VARCHAR2(32767);
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE IOLinker_Output'; -- Vider la table

        FOR y IN 1 .. 59 LOOP
            INSERT INTO IOLinker_Output (LineNb) VALUES (y);
            c := 'UPDATE IOLinker_Output SET LineNb = LineNb';
        
            FOR x IN 1 .. 199 LOOP
                IF scrn(y)(x) IS NULL THEN
                    c := c || ', x' || x || ' = NULL';
                ELSE
                    a := UTL_I18N.STRING_TO_RAW(scrn(y)(x), 'US8PC437');
                    b := UTL_RAW.CAST_TO_BINARY_INTEGER(a);
                    c := c || ', x' || x || ' = ' || b;
                END IF; 
            END LOOP;
            
            c := c || ' WHERE LineNb = ' || y;
            EXECUTE IMMEDIATE c;
        END LOOP;
        
        INSERT INTO IOLinker_Events VALUES (EventNum_SEQ.NEXTVAL, 'print', NULL, NULL); -- Notifier le linker
    END;
    
    -- Changer la position du curseur
    PROCEDURE SetCursorPos(x IN NUMBER, y IN NUMBER) IS
    BEGIN
        INSERT INTO IOLinker_Events VALUES (EventNum_SEQ.NEXTVAL, 'cursor', x, y); -- Notifier le linker
    END;
    
    -- Effacer l'écran
    PROCEDURE ClearScreen IS
    BEGIN
        FOR y IN 1 .. 59 LOOP
            scrn(y).DELETE;
            scrn(y).EXTEND(199);
        END LOOP;
    END;
    
    PROCEDURE DrawFrame(x1 IN NUMBER, y1 IN NUMBER, x2 IN NUMBER, y2 IN NUMBER, isDouble IN BOOLEAN) IS
        TYPE TMap IS TABLE OF NCHAR INDEX BY VARCHAR2(4);
        c TMap; -- Caractères de bordure
    BEGIN
        IF isDouble THEN
            c('CHG') := NCHR(9556); -- Coin supérieur gauche
            c('CHD') := NCHR(9559); -- Coin supérieur droit
            c('CBG') := NCHR(9562); -- Coin inférieur gauche
            c('CBD') := NCHR(9565); -- Coin inférieur droit
            c('H')   := NCHR(9552); -- Horizontal
            c('V')   := NCHR(9553); -- Vertical
        ELSE
            c('CHG') := NCHR(9484); -- Coin supérieur gauche
            c('CHD') := NCHR(9488); -- Coin supérieur droit
            c('CBG') := NCHR(9492); -- Coin inférieur gauche
            c('CBD') := NCHR(9496); -- Coin inférieur droit
            c('H')   := NCHR(9472); -- Horizontal
            c('V')   := NCHR(9474); -- Vertical
        END IF;
    
        -- Haut du cadre
        scrn(y1)(x1) := c('CHG');
        FOR x IN x1+1 .. x2-1 LOOP
            scrn(y1)(x) := c('H');
        END LOOP;
        scrn(y1)(x2) := c('CHD');
        
        -- Bas du cadre
        scrn(y2)(x1) := c('CBG');
        FOR x IN x1+1 .. x2-1 LOOP
            scrn(y2)(x) := c('H');
        END LOOP;
        scrn(y2)(x2) := c('CBD');
        
        -- Gauche du cadre
        FOR y IN y1+1 .. y2-1 LOOP
            scrn(y)(x1) := c('V');
        END LOOP;
        
        -- Droite du cadre
        FOR y IN y1+1 .. y2-1 LOOP
            scrn(y)(x2) := c('V');
        END LOOP;
        
        -- Effacer l'intérieur du cadre
        FOR y IN y1+1 .. y2-1 LOOP
            FOR x IN x1+1 .. x2-1 LOOP
                scrn(y)(x) := NULL;
            END LOOP;
        END LOOP;
    END;
    
    -- Écrire à une position
    PROCEDURE WriteAt(x IN NUMBER, y IN NUMBER, str NVARCHAR2) IS
        j NUMBER := 1; -- Position dans la chaîne
    BEGIN
        FOR i IN x .. x+LENGTH(str) LOOP
            scrn(y)(i) := SUBSTR(str, j, 1); -- Ajoute le caractère à l'écran
            j := j + 1;
        END LOOP;
    END;
    
    -- Effacer une zone
    PROCEDURE EraseZone(x1 IN NUMBER, y1 IN NUMBER, x2 IN NUMBER, y2 IN NUMBER) IS
    BEGIN
        FOR y IN y1 .. y2 LOOP
            FOR x IN x1 .. x2 LOOP
                scrn(y)(x) := NULL;
            END LOOP;
        END LOOP;
    END;
    
    -- Demander au linker de capturer et de transmettre la touche
    PROCEDURE AskInput AS
    BEGIN
        INSERT INTO IOLinker_Events VALUES (EventNum_SEQ.NEXTVAL, 'input', NULL, NULL);
    END;
    
    -- Retourner la touche appuyée
    -- Retourne NULL si aucune touche
    /*
    FUNCTION GetInput RETURN IOLinker_Input.KeyName%TYPE AS
        inputName IOLinker_Input.KeyName%TYPE;
    BEGIN
        IF hasInput THEN
            SELECT KeyName INTO inputName FROM IOLinker_Input; -- Récupére la touche
            DELETE FROM IOLinker_Input WHERE KeyName = inputName; -- Supprime la touche de la table
            hasInput := FALSE; -- Réinitialise l'état
            RETURN inputName;
        ELSE
            RETURN NULL;
        END IF;
    END;
    */
    
    FUNCTION GetInput RETURN IOLinker_Input.KeyName%TYPE AS
        inputName IOLinker_Input.KeyName%TYPE;
        CURSOR cur IS SELECT KeyName FROM IOLinker_Input;
    BEGIN
        OPEN cur;
        FETCH cur INTO inputName;
        CLOSE cur;
        
        IF inputName IS NOT NULL THEN
            DELETE FROM IOLinker_Input WHERE KeyName = inputName; -- Supprime la touche de la table
            RETURN inputName;
        ELSE
            RETURN NULL;
        END IF;
    END;

-- Initialisation des attributs
-- Note : cette partie s'exécute lorsque le package est référencé pour la 1ère fois
BEGIN
    scrn := TLines(TCols()); -- Initialise la 1ère case du tableau
    scrn(1).EXTEND(scrn(1).LIMIT); -- Étendre les colonnes au max. de la 1ère ligne
    scrn.EXTEND(scrn.LIMIT-1, 1); -- Étendre les lignes au max. en recopiant pour chaque ligne le contenu de la 1ère ligne
END;
/

-- Trigger déclenché lorsque le linker a transmis une touche pour notifier PL/SQL
DROP TRIGGER NewInput_TRG;
/*
CREATE OR REPLACE TRIGGER NewInput_TRG BEFORE INSERT ON IOLinker_Input
BEGIN
    Console_API.hasInput := TRUE;
END;
/
*/