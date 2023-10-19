# Invoke-PSThread
          .SYNOPSIS
          Enables the ability to leverage multithreading within powershell whilst reducing the complexity to get started.
          
          .DESCRIPTION
          This function aims to remove the enormous complexity out of multithreading within powershell. See the fully working examples below.
          
          .PARAMETER Runspace
          Your parameter description

          .PARAMETER RunspacePool
          Your parameter description

          .PARAMETER Await
          Your parameter description

          .PARAMETER RunspaceDefinition
          Your parameter description

          .PARAMETER RunspaceParameters
          Your parameter description

          .PARAMETER InputObjectList
          Your parameter description

          .PARAMETER SynchronizedHashtable
          Your parameter description

          .PARAMETER AssemblyList
          Your parameter description

          .PARAMETER FunctionList
          Your parameter description

          .PARAMETER ModuleList
          Your parameter description

          .PARAMETER VariableList
          Your parameter description

          .PARAMETER ThreadList
          Your parameter description

          .PARAMETER LoopTimeout
          Your parameter description

          .PARAMETER LoopDuration
          Your parameter description

          .PARAMETER WaitForAvailableRunspace
          Your parameter description

          .PARAMETER ContinueOnError
          Your parameter description
          
          .EXAMPLE
          Create a runspace

          [ScriptBlock]$RunspaceDefinition = {
                                                  Param
                                                    (
                                                        $SynchronizedHashtable,
                                                        $Title,
                                                        $Message
                                                    )
                                    
                                                  $Null = Add-Type -AssemblyName 'System.Windows.Forms'
                                                  $Null = Add-Type -AssemblyName 'System.Drawing'

                                                  $Form = New-Object -TypeName 'System.Windows.Forms.Form'
                                                    $Form.Size = New-Object -TypeName 'System.Drawing.Size' -ArgumentList @(300,150)
                                                  
                                                  $TextBox = New-Object -TypeName 'System.Windows.Forms.RichTextBox'
                                                    $TextBox.Location = New-Object -TypeName 'System.Drawing.Point' -ArgumentList @(110,50)
                                                    $TextBox.BorderStyle = 0
                                                    $TextBox.BackColor = $Form.BackColor

                                                  $TextBox.Text = $Message

                                                  $Null = $Form.Controls.Add($TextBox)

                                                  $Null = $Form.ShowDialog() 
                                             }

          $SynchronizedHashtable = [System.Collections.Hashtable]::Synchronized(@{})
            $SynchronizedHashtable.ThreadIDList = New-Object -TypeName 'System.Collections.Generic.List[System.String]'

          $InvokePSThreadParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
	          $InvokePSThreadParameters.Runspace = $True
	          $InvokePSThreadParameters.RunspaceDefinition = $RunspaceDefinition
	          $InvokePSThreadParameters.RunspaceParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
              $InvokePSThreadParameters.RunspaceParameters.Title = "This is my UI title"
              $InvokePSThreadParameters.RunspaceParameters.Message = "This is my UI message.`r`nThis is the second line of my UI message.`r`nThis is the third line of my UI message."
            $InvokePSThreadParameters.SynchronizedHashtable = Get-Variable -Name 'SynchronizedHashtable' -ErrorAction SilentlyContinue
	          $InvokePSThreadParameters.FunctionList = Get-ChildItem -Path 'Function:' | Where-Object {($_.Name -iin @('Test'))}
	          $InvokePSThreadParameters.ModuleList = Get-Module | Where-Object {($_.Name -iin @('Test'))}
	          $InvokePSThreadParameters.VariableList = Get-Variable | Where-Object {($_.Name -iin @('Test'))}
	          $InvokePSThreadParameters.ContinueOnError = $False
	          $InvokePSThreadParameters.Verbose = $True

          $InvokePSThreadResult = Invoke-PSThread @InvokePSThreadParameters

          Write-Output -InputObject ($InvokePSThreadResult)

          .EXAMPLE
          Create a runspace pool, submit all jobs to the pool, and the pool will manage their execution.

          [ScriptBlock]$RunspaceDefinition = {
                                                Param
                                                  (
                                                      $InputObjectListItem,
                                                      $SynchronizedHashtable,
                                                      $AdditionalParameter1,
                                                      $AdditionalParameter2
                                                  ) 

                                                #Set thread priority
                                                  [System.Threading.Thread]::CurrentThread.Priority = [System.Threading.ThreadPriority]::Lowest
                                                
                                                $ThreadInfo = [System.Threading.Thread]::CurrentThread

                                                $ThreadID = [System.AppDomain]::GetCurrentThreadId()

                                                $SynchronizedHashtable.ThreadIDList.Add($ThreadID)

                                                Write-Verbose -Message "Attempting to begin thread ID `"$($ThreadID)`". Please Wait..." -Verbose

                                                $SynchronizedHashtable.Add("Thread$($ThreadID)", (Get-Date))
                                                
                                                Write-Output -InputObject ($InputObjectListItem)

                                                Write-Output -InputObject ($AdditionalParameter1)

                                                Write-Output -InputObject ($AdditionalParameter2)

                                                $Null = Start-Sleep -Seconds (Get-Random -Minimum 10 -Maximum 25)
                                            }

          $SynchronizedHashtable = [System.Collections.Hashtable]::Synchronized(@{})
            $SynchronizedHashtable.ThreadIDList = New-Object -TypeName 'System.Collections.Generic.List[System.String]'

          $InvokePSThreadParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
	          $InvokePSThreadParameters.RunspacePool = $True
            $InvokePSThreadParameters.InputObjectList = 1..15
	          $InvokePSThreadParameters.RunspaceDefinition = $RunspaceDefinition
	          $InvokePSThreadParameters.RunspaceParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
              $InvokePSThreadParameters.RunspaceParameters.AdditionalParameter1 = Get-Random -Minimum 0 -Maximum 10000
              $InvokePSThreadParameters.RunspaceParameters.AdditionalParameter2 = Get-Random -Minimum 0 -Maximum 10000
            $InvokePSThreadParameters.SynchronizedHashtable = Get-Variable -Name 'SynchronizedHashtable' -ErrorAction SilentlyContinue
	          $InvokePSThreadParameters.FunctionList = Get-ChildItem -Path 'Function:' | Where-Object {($_.Name -iin @('Test'))}
	          $InvokePSThreadParameters.ModuleList = Get-Module | Where-Object {($_.Name -iin @('Test'))}
	          $InvokePSThreadParameters.VariableList = Get-Variable | Where-Object {($_.Name -iin @('Test'))}
	          $InvokePSThreadParameters.ContinueOnError = $False
	          $InvokePSThreadParameters.Verbose = $True

          $InvokePSThreadResult = Invoke-PSThread @InvokePSThreadParameters

          Write-Output -InputObject ($InvokePSThreadResult)

          .EXAMPLE
          Create a runspace pool, submit all jobs to the pool, and the pool will manage their execution. The function will be executed a second time to wait until all jobs have been completed, return their output, and cleanup.

          [ScriptBlock]$RunspaceDefinition = {
                                                Param
                                                  (
                                                      $InputObjectListItem,
                                                      $SynchronizedHashtable,
                                                      $AdditionalParameter1,
                                                      $AdditionalParameter2
                                                  ) 

                                                #Set thread priority
                                                  [System.Threading.Thread]::CurrentThread.Priority = [System.Threading.ThreadPriority]::Lowest
                                                
                                                $ThreadInfo = [System.Threading.Thread]::CurrentThread

                                                $ThreadID = [System.AppDomain]::GetCurrentThreadId()

                                                $SynchronizedHashtable.ThreadIDList.Add($ThreadID)

                                                Write-Verbose -Message "Attempting to begin thread ID `"$($ThreadID)`". Please Wait..." -Verbose

                                                $SynchronizedHashtable.Add("Thread$($ThreadID)", (Get-Date))
                                                
                                                Write-Output -InputObject ($InputObjectListItem)

                                                Write-Output -InputObject ($AdditionalParameter1)

                                                Write-Output -InputObject ($AdditionalParameter2)

                                                $Null = Start-Sleep -Seconds (Get-Random -Minimum 10 -Maximum 25)
                                            }
          
          $SynchronizedHashtable = [System.Collections.Hashtable]::Synchronized(@{})
            $SynchronizedHashtable.ThreadIDList = New-Object -TypeName 'System.Collections.Generic.List[System.String]'

          $InvokePSThreadParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
	          $InvokePSThreadParameters.RunspacePool = $True
            $InvokePSThreadParameters.InputObjectList = Get-Process | Get-Random -Count 15
	          $InvokePSThreadParameters.RunspaceDefinition = $RunspaceDefinition
	          $InvokePSThreadParameters.RunspaceParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
              $InvokePSThreadParameters.RunspaceParameters.AdditionalParameter1 = Get-Random -Minimum 0 -Maximum 10000
              $InvokePSThreadParameters.RunspaceParameters.AdditionalParameter2 = Get-Random -Minimum 0 -Maximum 10000
            $InvokePSThreadParameters.SynchronizedHashtable = Get-Variable -Name 'SynchronizedHashtable' -ErrorAction SilentlyContinue
	          $InvokePSThreadParameters.FunctionList = Get-ChildItem -Path 'Function:' | Where-Object {($_.Name -iin @('Test'))}
	          $InvokePSThreadParameters.ModuleList = Get-Module | Where-Object {($_.Name -iin @('Test'))}
	          $InvokePSThreadParameters.VariableList = Get-Variable | Where-Object {($_.Name -iin @('Test'))}
	          $InvokePSThreadParameters.ContinueOnError = $False
	          $InvokePSThreadParameters.Verbose = $True

          $InvokePSThreadResult = Invoke-PSThread @InvokePSThreadParameters

          #Do some additional work here before beginning to wait for your runspace pool to be completed.

          $InvokePSThreadParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
	          $InvokePSThreadParameters.Await = $True
	          $InvokePSThreadParameters.ThreadList = $InvokePSThreadResult
	          $InvokePSThreadParameters.LoopTimeout = [System.TimeSpan]::FromHours(1)
	          $InvokePSThreadParameters.LoopDuration = [System.TimeSpan]::FromMilliseconds(15000)
	          $InvokePSThreadParameters.ContinueOnError = $False
	          $InvokePSThreadParameters.Verbose = $True

          $ThreadAwaitResult = Invoke-PSThread @InvokePSThreadParameters

          Write-Output -InputObject ($ThreadAwaitResult)

          .NOTES
          Any useful tidbits

          .LINK
          https://davewyatt.wordpress.com/2014/04/29/more-potential-use-cases-for-thread-safe-variable-access-in-powershell-events/

          .LINK
          https://davewyatt.wordpress.com/2014/04/29/more-potential-use-cases-for-thread-safe-variable-access-in-powershell-events/

          .LINK
          https://www.codeproject.com/Tips/895840/Multi-Threaded-PowerShell-Cookbook

          .LINK
          https://www.linkedin.com/pulse/multithreading-powershell-scripts-alexey/
          
          .LINK
          https://xkln.net/blog/multithreading-in-powershell--running-a-specific-number-of-threads/

          .LINK
          https://markw.dev/#:~:text=There%20are%20two%20ways%20we,other%20is%20by%20using%20splatting.&text=The%20important%20part%20here%20is,plural)%20instead%20of%20AddParameter()%20.
