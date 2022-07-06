<div id="top"></div>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h3 align="center">A mini-game in PL/SQL</h3>
  <!--
  <p align="center">
    <a href="#">View Demo</a>
  </p>
  -->
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#built-with">Built With</a></li>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

<div align="center">
  <!-- <img src="project-image.png"> -->
</div>
<br />

This project is a console mini-game whose code is written in oriented-object PL/SQL. I haven't found the idea of the game yet, but I already made the linker between the database and Windows console.

The linker is an independent program written in Pascal language. It sends inputs from the console to the database, and it prints to the console data received from the database.

### Why?

This project is really useless, but I like making improbable things, so it's just for the challenge! (and learning more about PL/SQL and Oracle Database).

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- BUILT WITH -->
## Built With

### Game Logic
- Oriented-object [PL/SQL](https://en.wikipedia.org/wiki/PL/SQL)
- [Oracle DB 18c](https://docs.oracle.com/en/database/oracle/oracle-database/18/)
  - Packages:
  - [DBMS_SCHEDULER](https://docs.oracle.com/database/121/ARPLS/d_sched.htm)
  - [UTL_I18N](https://docs.oracle.com/database/121/ARPLS/u_i18n.htm)
  - [UTL_RAW](https://docs.oracle.com/database/121/ARPLS/u_raw.htm)

### I/O Linker
- Pascal language
  - Units:
  - Win32 API
  - [SQLdb](https://wiki.freepascal.org/SQLdb_Tutorial1)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

A guide to know how to setup both the linker and the database.

### Prerequisites

- [Lazarus IDE](https://www.lazarus-ide.org/), to build the linker.
- [Oracle DB 18c](https://docs.oracle.com/en/database/oracle/oracle-database/18/), to run the game logic (not sure about other versions).

### Installation

> **Note: currently, not all necessary source files are uploaded on the repository.**

~~Database-side:~~
- ~~Import and execute each PL/SQL script in the right order:~~  
  ~~This will create a dedicated user with necessary permissions for the game code; setup database schema (table, etc.); and compile the game code.~~

~~I/O Linker:~~
1. ~~Open the project in Lazarus IDE.~~
2. ~~In `Connection.pas`, set your connection infos:~~
   ```pascal
   con.hostname := '?';
   con.username := '?';
   con.password := '?';
   con.databasename := '?';
   ```
3. ~~Build the project.~~

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage

Be sure that your database is running, then launch the linker.
The game should start if the connection to the database was successful.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

- [x] I/O Linker.
- [x] Database-side:
  - [x] Console API to handle received input and various printing functions.
- [ ] Game logic and gameplay.

<p align="right">(<a href="#top">back to top</a>)</p>
