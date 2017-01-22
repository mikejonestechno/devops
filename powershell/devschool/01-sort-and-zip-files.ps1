# PowerShell for beginner training facilitator prompt sheet

# Challenge: Zip up the largest 5 files in c:\temp\demo1 to c:\temp\top5demo.zip

# encourage exploring this path...

dir

dir | sort 

dir | sort length

dir | sort length -Descending

dir | sort length -Descending | select -first 5



dir c:\temp\demo1 -file | sort length -Descending | select -first 5 | Compress-Archive -DestinationPath c:\temp\top5demo.zip

# Try this on the 1,000 files in c:\temp\demo2 and zip the largest 500 files


# additional coaching

# dir is an alias
cls
help dir
# CTRL pageup to see the cmdlet is get-child item

Get-ChildItem c:\temp\demo1 -file | Sort-Object length -Descending | Select-Object -first 5 | Compress-Archive -DestinationPath c:\temp\top5demo.zip


# something more interesting
Get-EventLog -LogName Application -Newest 10 | where EntryType -eq Error | select TimeWritten, source, message | ConvertTo-Html | Out-File c:\temp\errorlog.html
# get-eventlog takes list of computernames as a parameter