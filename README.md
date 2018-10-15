
# lastbootuptime_win

A fact and task for interacting with the last boot up time of a Windows machine.

## Description

This module does two things, provides a fact that contains the `LastBootUpTime` property of a Windows machine and a task to monitor the previously mentioned fact to determine if a system has rebooted.

## Setup

### The Fact

The module will have Windows machines generate two facts, one formatted datetime and one formatted raw. The generated fact is placed at `C:\ProgramData\PuppetLabs\facter\facts.d\lastbootuptime.json`.

|name|value|
|---|---|
|lastbootuptime|10/15/2018 12:44:42 PM|
|lastbootuptime_wmi|20181015124442.486606-360|

### The Task

The task queries the PuppetDB Nodes endpoint API and monitors for when the LastBootUpTime fact for a specific node changes. This task should be executed on a Windows machine running PowerShell v5 or greater.