5p — Personal Portable Project Planning Paradise
================================================

Data Model
----------

+ People
+ Tasks

+ Customers
+ Milestones
+ Drones

## Items

Every item — person, task etc — is an item.

Each item has some common properties:

- id

Id has a consistent format across all items to make life easier, it the form 
> ID\__<timestamp>\__<random>

Also items may have
- name (short human-readable), used everywhere
- description 

### Person


Installation
------------

## Linux

All trivial

## Windows

Use Windows 10 or above

Enable ANSI control sequences:
In Regedit: HKCU\VirtualTerminalLevel = (DWORD)0x1

Use MinGW to compile LuaJIT

https://www.mingw-w64.org/downloads/#mingw-builds
https://luajit.org/install.html





