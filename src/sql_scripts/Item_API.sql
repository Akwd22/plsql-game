SET AUTOCOMMIT ON;
SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER Logoff_TGR BEFORE LOGOFF ON SkyIUT.SCHEMA
BEGIN
    DBMS_SCHEDULER.STOP_JOB('job_main', TRUE);
END;
/

CREATE OR REPLACE PROCEDURE main AS
BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
       job_name     => 'job_main',
       job_type     => 'STORED_PROCEDURE',
       job_action   => 'game',
       enabled      => TRUE,
       auto_drop    => TRUE
    );
END;
/

CREATE OR REPLACE PROCEDURE game AS
    k IOLinker_Input.KeyName%TYPE;
BEGIN    
    Console_API.ClearScreen();
    Console_API.WriteAt(1,1,'Coucou');
    Console_API.DrawFrame(1,2,5,5,TRUE);
    Console_API.AskRefresh();
    
    Console_API.AskInput();
    
    COMMIT; -- Faire le commit maintenant sinon, il se fera jamais à cause de la boucle (le commit se faisant en sortant du bloc)
    
    WHILE TRUE LOOP
        NULL;
    END LOOP;
    
    Console_API.WriteAt(1,10,'OK');  
    Console_API.AskRefresh();
END;
/

/*
BEGIN DBMS_SCHEDULER.STOP_JOB('job_main', TRUE); END;

BEGIN game(); END;
*/

SELECT * FROM iolinker_events;
SELECT * FROM iolinker_input;