# Invoke-PSThread

## SYNOPSIS

Enables the ability to leverage multithreading within powershell whilst reducing the complexity to get started.

## SYNTAX

### Runspace (Default)

```
Invoke-PSThread -RunspaceDefinition <System.Management.Automation.ScriptBlock> [-ApartmentState <System.Threading.ApartmentState>] [-AssemblyList <System.Management.Automation.Runspaces.SessionStateAssemblyEntry[]>] [-Confirm <System.Management.Automation.SwitchParameter>] [-ContinueOnError <System.Management.Automation.SwitchParameter>] [-FunctionList <System.Management.Automation.FunctionInfo[]>] [-ModuleList <System.Management.Automation.PSModuleInfo[]>] [-Runspace <System.Management.Automation.SwitchParameter>] [-RunspaceParameters <System.Collections.Hashtable>] [-SynchronizedHashtable <System.Management.Automation.PSVariable>] [-ThreadOption <System.Management.Automation.Runspaces.PSThreadOptions>] [-VariableList <System.Management.Automation.PSVariable[]>] [-WaitForAvailableRunspace <System.Management.Automation.SwitchParameter>] [-WhatIf <System.Management.Automation.SwitchParameter>] [<CommonParameters>]
```

### RunspacePool

```
Invoke-PSThread -InputObjectList <System.Object[]> -RunspaceDefinition <System.Management.Automation.ScriptBlock> [-ApartmentState <System.Threading.ApartmentState>] [-AssemblyList <System.Management.Automation.Runspaces.SessionStateAssemblyEntry[]>] [-Confirm <System.Management.Automation.SwitchParameter>] [-ContinueOnError <System.Management.Automation.SwitchParameter>] [-FunctionList <System.Management.Automation.FunctionInfo[]>] [-MaximumRunspaces <System.UInt32>] [-ModuleList <System.Management.Automation.PSModuleInfo[]>] [-RunspaceParameters <System.Collections.Hashtable>] [-RunspacePool <System.Management.Automation.SwitchParameter>] [-SynchronizedHashtable <System.Management.Automation.PSVariable>] [-ThreadOption <System.Management.Automation.Runspaces.PSThreadOptions>] [-VariableList <System.Management.Automation.PSVariable[]>] [-WaitForAvailableRunspace <System.Management.Automation.SwitchParameter>] [-WhatIf <System.Management.Automation.SwitchParameter>] [<CommonParameters>]
```

### Await

```
Invoke-PSThread -ThreadList <System.Management.Automation.PSObject[]> [-Await <System.Management.Automation.SwitchParameter>] [-Confirm <System.Management.Automation.SwitchParameter>] [-ContinueOnError <System.Management.Automation.SwitchParameter>] [-LoopDuration <System.TimeSpan>] [-LoopTimeout <System.TimeSpan>] [-WaitForAvailableRunspace <System.Management.Automation.SwitchParameter>] [-WhatIf <System.Management.Automation.SwitchParameter>] [<CommonParameters>]
```

## DESCRIPTION

This function aims to remove the enormous complexity out of multithreading within powershell.
See the fully working examples below.


## EXAMPLES

### Example 1: EXAMPLE 1

```
Create a runspace
```

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
 $InvokePSThreadParameters.RunspaceParameters = [Ordered]@{}
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





### Example 2: EXAMPLE 2

```
Create a runspace pool, submit all jobs to the pool, and the pool will manage their execution.
```

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

                                      Write-Verbose -Message "Attempting to begin thread ID `"$($ThreadID)`".
Please Wait..." -Verbose

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
 $InvokePSThreadParameters.RunspaceParameters = [Ordered]@{}
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





### Example 3: EXAMPLE 3

```
Create a runspace pool, submit all jobs to the pool, and the pool will manage their execution. The function will be executed a second time to wait until all jobs have been completed, return their output, and cleanup.
```

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

                                      Write-Verbose -Message "Attempting to begin thread ID `"$($ThreadID)`".
Please Wait..." -Verbose

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
 $InvokePSThreadParameters.RunspaceParameters = [Ordered]@{}
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






## PARAMETERS

### -ApartmentState

A valid apartment state that will be used to create each thread within the runspace.

```yaml
Type: System.Threading.ApartmentState
Parameter Sets: RunspacePool, Runspace
Aliases: AS
Accepted values: 

Required: True (None) False (RunspacePool, Runspace)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -AssemblyList

A list of one or more additional assemblies that will be loaded into the inital session state, and made available to each thread.

```yaml
Type: System.Management.Automation.Runspaces.SessionStateAssemblyEntry[]
Parameter Sets: RunspacePool, Runspace
Aliases: AL
Accepted values: 

Required: True (None) False (RunspacePool, Runspace)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -Await

Strictly places this function into "Await" mode.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: Await
Aliases: AW
Accepted values: 

Required: True (None) False (Await)
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -Confirm

{{ Fill Confirm Description }}

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: cf
Accepted values: 

Required: True (None) False (All)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -ContinueOnError

Ignore errors.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: COE
Accepted values: 

Required: True (None) False (All)
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -FunctionList

A list of one or more additional functions that will be loaded into the inital session state, and made available to each thread.

```yaml
Type: System.Management.Automation.FunctionInfo[]
Parameter Sets: RunspacePool, Runspace
Aliases: FL
Accepted values: 

Required: True (None) False (RunspacePool, Runspace)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -InputObjectList

A list of one or more objects to submit to the runspace pool.
The runspace pool will create a job for each item and process them in a queue fashion (As new runspaces become available) until the list has been completed.

```yaml
Type: System.Object[]
Parameter Sets: RunspacePool
Aliases: IOL
Accepted values: 

Required: True (RunspacePool) False (None)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -LoopDuration

A valid timespan that will be used for designating how often to recheck the status of running threads.

```yaml
Type: System.TimeSpan
Parameter Sets: Await
Aliases: LD
Accepted values: 

Required: True (None) False (Await)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -LoopTimeout

A valid timespan that will be used for designating the maximum time allowed to monitor running threads.

```yaml
Type: System.TimeSpan
Parameter Sets: Await
Aliases: LT
Accepted values: 

Required: True (None) False (Await)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -MaximumRunspaces

The maximum runspaces available to the runspace pool.
By default, the value will be set to double the amount of logical processors available to the current device.

```yaml
Type: System.UInt32
Parameter Sets: RunspacePool
Aliases: MR
Accepted values: 

Required: True (None) False (RunspacePool)
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -ModuleList

A list of one or more additional modules that will be loaded into the inital session state, and made available to each thread.

```yaml
Type: System.Management.Automation.PSModuleInfo[]
Parameter Sets: RunspacePool, Runspace
Aliases: ML
Accepted values: 

Required: True (None) False (RunspacePool, Runspace)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -Runspace

Strictly places this function into "Runspace" mode.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: Runspace
Aliases: RS
Accepted values: 

Required: True (None) False (Runspace)
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -RunspaceDefinition

A valid scriptblock that will be executed by either a single thread within the runspace, or by each thread within the runspace pool.

```yaml
Type: System.Management.Automation.ScriptBlock
Parameter Sets: RunspacePool, Runspace
Aliases: RD
Accepted values: 

Required: True (RunspacePool, Runspace) False (None)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -RunspaceParameters

A valid hashtable containing the key-value pairs for the additional parameters to be passed to each thread.
If the order of the parameters needs to be preserved, use an ordered hashtable instead.

```yaml
Type: System.Collections.Hashtable
Parameter Sets: RunspacePool, Runspace
Aliases: RSP
Accepted values: 

Required: True (None) False (RunspacePool, Runspace)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -RunspacePool

Strictly places this function into "RunspacePool" mode.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: RunspacePool
Aliases: RP
Accepted values: 

Required: True (None) False (RunspacePool)
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -SynchronizedHashtable

A valid variable object that contains the synchronized hashtable.
This is primarily used to share data between the main thread, and any additional threads that are created.

```yaml
Type: System.Management.Automation.PSVariable
Parameter Sets: RunspacePool, Runspace
Aliases: SHT
Accepted values: 

Required: True (None) False (RunspacePool, Runspace)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -ThreadList

A list of one ore more objects that were returned in the output from a previous call of this function.
The runspaces in this list will be monitored until they have completed.

```yaml
Type: System.Management.Automation.PSObject[]
Parameter Sets: Await
Aliases: TL
Accepted values: 

Required: True (Await) False (None)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -ThreadOption

A valid thread option that will be used to create each thread within the runspace.

```yaml
Type: System.Management.Automation.Runspaces.PSThreadOptions
Parameter Sets: RunspacePool, Runspace
Aliases: TO
Accepted values: 

Required: True (None) False (RunspacePool, Runspace)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -VariableList

A list of one or more additional variables that will be loaded into the inital session state, and made available to each thread.

```yaml
Type: System.Management.Automation.PSVariable[]
Parameter Sets: RunspacePool, Runspace
Aliases: VL
Accepted values: 

Required: True (None) False (RunspacePool, Runspace)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -WaitForAvailableRunspace

If there are no more available runspaces, the function will wait to submit any additional jobs to teh runspace pool as runspaces become available.
This will drastically increase the time it takes to process the runspace pool.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: WFAR
Accepted values: 

Required: True (None) False (All)
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```

### -WhatIf

{{ Fill WhatIf Description }}

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: wi
Accepted values: 

Required: True (None) False (All)
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
DontShow: False
```


### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## NOTES

Any useful tidbits


## RELATED LINKS

[] (https://davewyatt.wordpress.com/2014/04/29/more-potential-use-cases-for-thread-safe-variable-access-in-powershell-events/)

[] (https://davewyatt.wordpress.com/2014/04/29/more-potential-use-cases-for-thread-safe-variable-access-in-powershell-events/)

[] (https://www.codeproject.com/Tips/895840/Multi-Threaded-PowerShell-Cookbook)

[] (https://www.linkedin.com/pulse/multithreading-powershell-scripts-alexey/)

[] (https://xkln.net/blog/multithreading-in-powershell--running-a-specific-number-of-threads/)

[] (https://markw.dev/#:~:text=There%20are%20two%20ways%20we,other%20is%20by%20using%20splatting.&text=The%20important%20part%20here%20is,plural)%20instead%20of%20AddParameter()%20.)

