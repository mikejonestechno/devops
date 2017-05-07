Feature: Archive largest log files

For a directory of source\data log files, 
sort these logs by size and select the largest 500 files,
and compress them to a .zip file saved in the destination directory


Scenario: Archive a folder of 499 files
Given the source directory contains 499 files
 When I run Archive-Log.ps1
 Then the archive contains 499 files

Scenario: Archive a folder of 500 files
 Given the source directory contains 500 files
 When I run Archive-Log.ps1
 Then the archive contains 500 files

Scenario: Archive a folder of 501 files
Given the source directory contains 501 files
 When I run Archive-Log.ps1
 Then the archive contains 500 files
