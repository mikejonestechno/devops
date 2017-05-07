Feature: Archive largest log files

For a directory of source\data log files, 
sort these logs by size and select the largest 500 files,
and compress them to a .zip file saved in the destination directory


Scenario: Select and archive the largest files

Given the source directory contains files of different size
 When I run archive-script.ps1
 Then the archive contains the largest files
