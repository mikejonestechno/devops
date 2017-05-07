Feature: Archive largest log files

For a directory of source\data log files, 
sort these logs by size and select the largest 500 files,
and compress them to a .zip file saved in the destination directory


Scenario: Select and archive the largest files

Given the source directory contains files of different size
 When I run archive-script.ps1
 Then the archive contains the largest files


Scenario: Select and archive recent files

Given the source directory contains a sub directory for each days logs based on UTC
When I run Archive-Log.ps1
Then the archive contains only the files modified between 11pm yesterday and 11pm today based on local time
