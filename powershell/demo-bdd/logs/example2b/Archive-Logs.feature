Feature: Archive largest log files

For a directory of source\data log files, 
sort these logs by size and select the largest 500 files,
and compress them to a .zip file saved in the destination directory


Scenario: Select and archive the largest files

Given the source directory contains the following files

    | Size | Name         |
    | 4    | medium       |
    | 6    | extralarge   |
    | 2    | tiny         |
    | 7    | xxlarge      |
    | 3    | small        |
    | 8    | monster      |
    | 1    | teeny        |
    | 5    | large        |

 When I run archive-script.ps1

 Then the archive contains exactly these files

    | Size | Name         |
    | 4    | medium       |
    | 5    | large        |
    | 6    | extralarge   |
    | 7    | xxlarge      |
    | 8    | monster      |
