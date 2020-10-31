<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the project](#about-the-project)
  * [Why?](#why)
  * [Built With](#built-with)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Usage](#usage)
* [Roadmap](#roadmap)

<!-- ABOUT THE PROJECT -->
## About The Project

This project is a console mini-game whose code is written in oriented-object PL/SQL. I haven't found the idea of the game yet, but I already made the linker between the DBMS and Windows console.

The linker is an independent program written in Pascal language. It sends inputs from the console to the DBMS, and it prints to the console data received from the DBMS.

### Why?

This project is really useless but I like making improbable things, so it's just for the challenge! (and learning more about PL/SQL and Oracle Database)

### Built With
**Game code:**
* Oriented-object PL/SQL
* Oracle DB 18c
  * Packages:
  * [DBMS_SCHEDULER](https://docs.oracle.com/database/121/ARPLS/d_sched.htm)
  * [UTL_I18N](https://docs.oracle.com/database/121/ARPLS/u_i18n.htm)
  * [UTL_RAW](https://docs.oracle.com/database/121/ARPLS/u_raw.htm)

**IO Linker:**
* Pascal language
  * Units:
  * Win32 API
  * SQLdb

<!-- GETTING STARTED -->
## Getting Started

A guide to know how to setup both the linker and the DBMS.

### Prerequisites

* Lazarus IDE, to build the linker
* Oracle DB 18c, to store the game code (I haven't tested others versions)

### Installation

**Note: currently, not all necessary source files are uploaded on the repository.**

~~DBMS-side:~~
* ~~Import and execute each PL/SQL script in the right order :~~
  * ~~This will create a dedicated user with necessary permissions for the game code; setup DDL; compile the game code~~

~~IO Linker:~~
~~1. Open the project in Lazarus IDE~~
~~2. In `Connection.pas`, set your connection infos~~
```pascal
    con.hostname := '?';
    con.username := '?';
    con.password := '?';
    con.databasename := '?';
```
~~3. Build the project~~

<!-- USAGE EXAMPLES -->
## Usage

Be sure that your DBMS is running, then launch the linker.
The game should start if the connection to the DBMS was successful.

<!-- ROADMAP -->
## Roadmap

Currently, are made:
* IO Linker
* DBMS-side:
  * Console API to handle received input and various printing functions

Game logic then gameplay have yet to be coded.
