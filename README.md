# Invoke-PSThread

## SYNOPSIS

Enables the ability to leverage multithreading within powershell whilst reducing the complexity to get started.

## SYNTAX

### Runspace (Default)

```
Invoke-PSThread -RunspaceDefinition <System.Management.Automation.ScriptBlock> [-ApartmentState <System.Threading.ApartmentState>] [-AssemblyList <System.Management.Automation.Runspaces.SessionStateAssemblyEntry[]>] [-ContinueOnError <System.Management.Automation.SwitchParameter>] [-FunctionList <System.Management.Automation.FunctionInfo[]>] [-ModuleList <System.Management.Automation.PSModuleInfo[]>] [-Runspace <System.Management.Automation.SwitchParameter>] [-RunspaceParameters <System.Collections.Hashtable>] [-SynchronizedHashtable <System.Management.Automation.PSVariable>] [-ThreadOption <System.Management.Automation.Runspaces.PSThreadOptions>] [-VariableList <System.Management.Automation.PSVariable[]>] [-WaitForAvailableRunspace <System.Management.Automation.SwitchParameter>] [<CommonParameters>]
```

### RunspacePool

```
Invoke-PSThread -InputObjectList <System.Object[]> -RunspaceDefinition <System.Management.Automation.ScriptBlock> [-ApartmentState <System.Threading.ApartmentState>] [-AssemblyList <System.Management.Automation.Runspaces.SessionStateAssemblyEntry[]>] [-ContinueOnError <System.Management.Automation.SwitchParameter>] [-FunctionList <System.Management.Automation.FunctionInfo[]>] [-MaximumRunspaces <System.UInt32>] [-ModuleList <System.Management.Automation.PSModuleInfo[]>] [-RunspaceParameters <System.Collections.Hashtable>] [-RunspacePool <System.Management.Automation.SwitchParameter>] [-SynchronizedHashtable <System.Management.Automation.PSVariable>] [-ThreadOption <System.Management.Automation.Runspaces.PSThreadOptions>] [-VariableList <System.Management.Automation.PSVariable[]>] [-WaitForAvailableRunspace <System.Management.Automation.SwitchParameter>] [<CommonParameters>]
```

### Await

```
Invoke-PSThread -ThreadList <System.Management.Automation.PSObject[]> [-Await <System.Management.Automation.SwitchParameter>] [-ContinueOnError <System.Management.Automation.SwitchParameter>] [-LoopDuration <System.TimeSpan>] [-LoopTimeout <System.TimeSpan>] [-WaitForAvailableRunspace <System.Management.Automation.SwitchParameter>] [<CommonParameters>]
```

## DESCRIPTION

This function aims to remove the enormous complexity out of multithreading within powershell.
See the fully working examples below.


## EXAMPLES

### Example 1


Create a runspace.

```
          [ScriptBlock]$RunspaceDefinition = {
                                                  Param
                                                    (
                                                        $SynchronizedHashtable
                                                    )
 
                                                  [System.Threading.Thread]::CurrentThread.Priority = [System.Threading.ThreadPriority]::Lowest
                                                                                                            
                                                  $SynchronizedHashtable.UIDefinitionContent = @'
<Window
                        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
                        WindowStartupLocation="CenterScreen"
                        Title="Example XAML Window"
                        ShowInTaskbar="True"
                        Topmost="True"
                        SizeToContent="WidthAndHeight"
                        Background="DeepSkyBlue"
                        ResizeMode="NoResize"
                        MaxWidth="720"
                        Width="600">

    <Border Padding="10">
        <StackPanel>
                <GroupBox Name="GROUPBOX_001" Header="Example Group Box" Margin="2,5,2,5" BorderBrush="Black" BorderThickness="1.4" FontWeight="DemiBold" FontSize="16" Background="Aqua">
                    <Grid Margin="0,10,0,10">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*" />
                        </Grid.ColumnDefinitions>

                        <Grid.RowDefinitions>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>

                        <Label Name="LBL_TXTBOX_001" Grid.Column="0" Grid.Row="0" Grid.ColumnSpan="1" Content="Example Label" FontSize="13" ToolTip="Example Tooltip"></Label>
                        <TextBox Name="TXTBOX_001" Grid.Column="1" Grid.Row="1" Grid.ColumnSpan="3" FontSize="16" IsReadOnly="False" Height="25" BorderBrush="Black" BorderThickness="0.8" HorizontalAlignment="Stretch" VerticalAlignment="Stretch" Margin="4,4,4,4"></TextBox>

                    </Grid>
                </GroupBox>

            <Grid Margin="0,10,0,10">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*" />
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*" />
                </Grid.ColumnDefinitions>

                <Grid.RowDefinitions>
                    <RowDefinition Height="*" />
                </Grid.RowDefinitions>

                <Button Name="BTN_OK" IsDefault="True" Grid.Column="1" Grid.ColumnSpan="1" MinWidth="90" Content="OK" HorizontalAlignment="Center" FontSize="17" Margin="5,0,5,0" Foreground="#000000" FontWeight="SemiBold" Background="#E1E1E1" BorderThickness="1.5"></Button>

                <Button Name="BTN_Cancel" IsCancel="True" Grid.Column="2" Grid.ColumnSpan="1" MinWidth="90" Content="Cancel" HorizontalAlignment="Center" FontSize="17" Margin="5,0,5,0" Foreground="#000000" FontWeight="SemiBold" IsDefault="True" Background="#E1E1E1" BorderThickness="1.5"></Button>

            </Grid>

        </StackPanel>

    </Border>

</Window>
'@
                                                                                                            
                                                                                                            $SynchronizedHashtable.UIDefinitionStringReader = New-Object -TypeName 'System.IO.StringReader' -ArgumentList @($SynchronizedHashtable.UIDefinitionContent)
                                                                                                            
                                                                                                            $SynchronizedHashtable.UIDefinitionXMLReader = [System.Xml.XmlReader]::Create($SynchronizedHashtable.UIDefinitionStringReader)   
                                                                                                            
                                                                                                            $SynchronizedHashtable.UIDefinitionXMLDocument = New-Object -TypeName 'System.XML.XMLDocument'
                                                                                                              $SynchronizedHashtable.UIDefinitionXMLDocument.LoadXML(($SynchronizedHashtable.UIDefinitionContent -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window' -replace 'x:Class="\S+"',''))
                                                                                                            
                                                                                                            $SynchronizedHashtable.UIWindow = [System.Windows.Markup.XAMLReader]::Load($SynchronizedHashtable.UIDefinitionXMLReader)
                                                                                                            
                                                                                                            $SynchronizedHashtable.UIControls = [Ordered]@{}
                                                                                                            
                                                                                                            $SynchronizedHashtable.UIDefinitionXMLDocument.SelectNodes("//*[@Name]") | ForEach-Object {$SynchronizedHashtable.UIControls.$($_.Name) = $SynchronizedHashtable.UIWindow.FindName($_.Name)}
                                                                                                             
                                                                                                            $SynchronizedHashtable.UIControls.BTN_OK.Add_Click({$Null = $SynchronizedHashtable.UIWindow.Close()})
                                                                                                            
                                                                                                            $Null = $SynchronizedHashtable.UIWindow.ShowDialog()
                                                                                                       }

          $SynchronizedHashtable = [System.Collections.Hashtable]::Synchronized(@{})

          $InvokePSThreadParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
	          $InvokePSThreadParameters.Runspace = $True
            $InvokePSThreadParameters.ApartmentState = [System.Threading.ApartmentState]::STA
	          $InvokePSThreadParameters.RunspaceDefinition = $RunspaceDefinition
            $InvokePSThreadParameters.SynchronizedHashtable = Get-Variable -Name 'SynchronizedHashtable' -ErrorAction SilentlyContinue
	          $InvokePSThreadParameters.AssemblyList = New-Object -TypeName 'System.Collections.Generic.List[System.Management.Automation.Runspaces.SessionStateAssemblyEntry]'
              $InvokePSThreadParameters.AssemblyList.Add('PresentationFramework')
              $InvokePSThreadParameters.AssemblyList.Add('System.Drawing')
              $InvokePSThreadParameters.AssemblyList.Add('System.Windows.Forms')
              $InvokePSThreadParameters.AssemblyList.Add('WindowsFormsIntegration')
            $InvokePSThreadParameters.FunctionList = Get-ChildItem -Path 'Function:' | Where-Object {($_.Name -iin @('Test'))}
	          $InvokePSThreadParameters.ModuleList = Get-Module | Where-Object {($_.Name -iin @('Test'))}
	          $InvokePSThreadParameters.VariableList = Get-Variable | Where-Object {($_.Name -iin @('Test'))}
	          $InvokePSThreadParameters.ContinueOnError = $False
	          $InvokePSThreadParameters.Verbose = $True

          $InvokePSThreadResult = Invoke-PSThread @InvokePSThreadParameters
                                                                    
          $TextBoxControlName = 'TXTBOX_001'
                                                                    
          $TextBoxUpdateInterval = [System.TimeSpan]::FromSeconds(5)
                                                                    
          $TextBoxUpdateList = New-Object -TypeName 'System.Collections.Generic.List[System.String]'
            $TextBoxUpdateList.Add('This is too legit!')
            $TextBoxUpdateList.Add('This is too legit to quit!')

          ForEach ($TextBoxUpdate In $TextBoxUpdateList)
            {
                $LogMessage = "Waiting for $($TextBoxUpdateInterval.TotalSeconds) second(s). Please Wait..."
                Write-Verbose -Message ($LogMessage) -Verbose
                                                                          
                $Null = Start-Sleep -Milliseconds ($TextBoxUpdateInterval.TotalMilliseconds)
                                                                          
                $LogMessage = "Attempting to update text box. Please Wait..."
                Write-Verbose -Message ($LogMessage) -Verbose
                                                                          
                $SynchronizedHashtable.UIWindow.Dispatcher.Invoke([Action]{$SynchronizedHashtable.UIControls.$($TextBoxControlName).Text = $TextBoxUpdate}, 'Normal')
            }
                                                                    
          $InvokePSThreadParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
	          $InvokePSThreadParameters.Await = $True
	          $InvokePSThreadParameters.ThreadList = $InvokePSThreadResult
	          $InvokePSThreadParameters.LoopTimeout = [System.TimeSpan]::FromHours(1)
	          $InvokePSThreadParameters.LoopDuration = [System.TimeSpan]::FromMilliseconds(15000)
	          $InvokePSThreadParameters.ContinueOnError = $False
	          $InvokePSThreadParameters.Verbose = $True

          $ThreadAwaitResult = Invoke-PSThread @InvokePSThreadParameters
```




### Example 2


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
```




### Example 3


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
```





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


### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## NOTES

Any useful tidbits


## RELATED LINKS

https://davewyatt.wordpress.com/2014/04/29/more-potential-use-cases-for-thread-safe-variable-access-in-powershell-events/

https://www.codeproject.com/Tips/895840/Multi-Threaded-PowerShell-Cookbook

https://www.linkedin.com/pulse/multithreading-powershell-scripts-alexey/

https://xkln.net/blog/multithreading-in-powershell--running-a-specific-number-of-threads/

https://markw.dev/#:~:text=There%20are%20two%20ways%20we,other%20is%20by%20using%20splatting.&text=The%20important%20part%20here%20is,plural)%20instead%20of%20AddParameter()%20

## SAMPLE LOG OUTPUT
```
VERBOSE: 10/22/2023 22:30:45.407 - Function 'Invoke-PSThread' is beginning. Please Wait...
VERBOSE: 10/22/2023 22:30:45.42 - Available Function Parameter(s) = -Runspace:SwitchParameter, -RunspacePool:SwitchParameter, -Await:SwitchParameter, -RunspaceDefinition:ScriptBlock, -RunspaceParameters:Hashtable, -InputObjectList:Object[], -SynchronizedHashtable:PSVariable, -AssemblyList:SessionStateAssemblyEntry[], -FunctionList:FunctionInfo[], -ModuleList:PSModuleInfo[], -VariableList:PSVariable[], -ApartmentState:ApartmentState, -ThreadOption:PSThreadOptions, -MaximumRunspaces:UInt32, -WaitForAvailableRunspace:SwitchParameter, -ThreadList:PSObject[], -LoopTimeout:TimeSpan, -LoopDuration:TimeSpan, -ContinueOnError:SwitchParameter
VERBOSE: 10/22/2023 22:30:45.435 - Supplied Function Parameter(s) = -RunspacePool:SwitchParameter, -InputObjectList:Object[], -RunspaceDefinition:ScriptBlock, -RunspaceParameters:Hashtable, -SynchronizedHashtable:PSVariable, Uknown:Unknown, Uknown:Unknown, Uknown:Unknown, -ContinueOnError:SwitchParameter, -Verbose:SwitchParameter
VERBOSE: 10/22/2023 22:30:45.452 - Execution of Invoke-PSThread began on Sunday, October 22, 2023 @ 10:30:45.406 PM
VERBOSE: 10/22/2023 22:30:45.457 - Parameter Set Name: RunspacePool
VERBOSE: 10/22/2023 22:30:45.532 - Attempting to open a new runspace pool. Please Wait... [Minimum Runspaces: 1] [Maximum Runspaces: 12]
VERBOSE: 10/22/2023 22:30:45.538 - Attempting to create a new runspace for input object list item 1 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: 10/22/2023 22:30:45.574 - Attempting to create a new runspace for input object list item 2 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: Attempting to begin thread ID "39468". Please Wait...
VERBOSE: Attempting to begin thread ID "39208". Please Wait...
VERBOSE: 10/22/2023 22:30:45.592 - Attempting to create a new runspace for input object list item 3 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: Attempting to begin thread ID "21168". Please Wait...
VERBOSE: 10/22/2023 22:30:45.614 - Attempting to create a new runspace for input object list item 4 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: Attempting to begin thread ID "23484". Please Wait...
VERBOSE: 10/22/2023 22:30:45.627 - Attempting to create a new runspace for input object list item 5 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: Attempting to begin thread ID "4192". Please Wait...
VERBOSE: 10/22/2023 22:30:45.647 - Attempting to create a new runspace for input object list item 6 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: Attempting to begin thread ID "15304". Please Wait...
VERBOSE: 10/22/2023 22:30:45.667 - Attempting to create a new runspace for input object list item 7 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: Attempting to begin thread ID "34308". Please Wait...
VERBOSE: 10/22/2023 22:30:45.7 - Attempting to create a new runspace for input object list item 8 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: Attempting to begin thread ID "38792". Please Wait...
VERBOSE: 10/22/2023 22:30:45.723 - Attempting to create a new runspace for input object list item 9 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: Attempting to begin thread ID "3636". Please Wait...
VERBOSE: 10/22/2023 22:30:45.747 - Attempting to create a new runspace for input object list item 10 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: Attempting to begin thread ID "30676". Please Wait...
VERBOSE: 10/22/2023 22:30:45.766 - Attempting to create a new runspace for input object list item 11 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: Attempting to begin thread ID "24804". Please Wait...
VERBOSE: 10/22/2023 22:30:45.794 - Attempting to create a new runspace for input object list item 12 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: Attempting to begin thread ID "24660". Please Wait...
VERBOSE: 10/22/2023 22:30:45.816 - Attempting to create a new runspace for input object list item 13 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: 10/22/2023 22:30:45.825 - Attempting to create a new runspace for input object list item 14 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: 10/22/2023 22:30:45.827 - Attempting to create a new runspace for input object list item 15 of 15. Please Wait... [InputObjectType: Process]
VERBOSE: 10/22/2023 22:30:45.83 - Execution of Invoke-PSThread ended on Sunday, October 22, 2023 @ 10:30:45.83 PM
VERBOSE: 10/22/2023 22:30:45.832 - Function execution took 0 hour(s), 0 minute(s), 0 second(s), and 423 millisecond(s)
VERBOSE: 10/22/2023 22:30:45.833 - Function 'Invoke-PSThread' is completed.
VERBOSE: 10/22/2023 22:30:45.845 - Function 'Invoke-PSThread' is beginning. Please Wait...
VERBOSE: 10/22/2023 22:30:45.854 - Available Function Parameter(s) = -Runspace:SwitchParameter, -RunspacePool:SwitchParameter, -Await:SwitchParameter, -RunspaceDefinition:ScriptBlock, -RunspaceParameters:Hashtable, -InputObjectList:Object[], -SynchronizedHashtable:PSVariable, -AssemblyList:SessionStateAssemblyEntry[], -FunctionList:FunctionInfo[], -ModuleList:PSModuleInfo[], -VariableList:PSVariable[], -ApartmentState:ApartmentState, -ThreadOption:PSThreadOptions, -MaximumRunspaces:UInt32, -WaitForAvailableRunspace:SwitchParameter, -ThreadList:PSObject[], -LoopTimeout:TimeSpan, -LoopDuration:TimeSpan, -ContinueOnError:SwitchParameter
VERBOSE: 10/22/2023 22:30:45.858 - Supplied Function Parameter(s) = -Await:SwitchParameter, -ThreadList:PSObject[], -LoopTimeout:TimeSpan, -LoopDuration:TimeSpan, -ContinueOnError:SwitchParameter, -Verbose:SwitchParameter
VERBOSE: 10/22/2023 22:30:45.859 - Execution of Invoke-PSThread began on Sunday, October 22, 2023 @ 10:30:45.84 PM
VERBOSE: 10/22/2023 22:30:45.861 - Parameter Set Name: Await
VERBOSE: 10/22/2023 22:30:45.898 - Loop Timeout: 0 day(s), 1 hour(s), 0 minute(s), 0 second(s), and 0 millisecond(s)
VERBOSE: 10/22/2023 22:30:45.9 - Current Time: Sunday, October 22, 2023 @ 10:30:45.9 PM
VERBOSE: 10/22/2023 22:30:45.902 - Loop Timeout Time: Sunday, October 22, 2023 @ 11:30:45.9 PM
VERBOSE: 10/22/2023 22:30:45.904 - Elasped Time: 0 day(s), 0 hour(s), 0 minute(s), 0 second(s), and 0 millisecond(s)
VERBOSE: 10/22/2023 22:30:45.922 - Total Threads: 15
VERBOSE: 10/22/2023 22:30:45.923 - Completed Threads: 0
VERBOSE: 10/22/2023 22:30:45.925 - Incomplete Threads: 15
VERBOSE: 10/22/2023 22:30:45.927 - Thread Completion Percentage: 0%
VERBOSE: 10/22/2023 22:30:45.929 - Thread Incompletion Percentage: 100%
VERBOSE: 10/22/2023 22:30:45.931 - Checking again in: 0 day(s), 0 hour(s), 0 minute(s), 15 second(s), and 0 millisecond(s)
VERBOSE: Attempting to begin thread ID "34308". Please Wait...
VERBOSE: Attempting to begin thread ID "3636". Please Wait...
VERBOSE: Attempting to begin thread ID "24660". Please Wait...
VERBOSE: 10/22/2023 22:31:00.945 - Elasped Time: 0 day(s), 0 hour(s), 0 minute(s), 15 second(s), and 41 millisecond(s)
VERBOSE: 10/22/2023 22:31:00.947 - Total Threads: 15
VERBOSE: 10/22/2023 22:31:00.948 - Completed Threads: 6
VERBOSE: 10/22/2023 22:31:00.948 - Incomplete Threads: 9
VERBOSE: 10/22/2023 22:31:00.949 - Thread Completion Percentage: 40%
VERBOSE: 10/22/2023 22:31:00.95 - Thread Incompletion Percentage: 60%
VERBOSE: 10/22/2023 22:31:00.951 - Checking again in: 0 day(s), 0 hour(s), 0 minute(s), 15 second(s), and 0 millisecond(s)
VERBOSE: 10/22/2023 22:31:15.958 - Elasped Time: 0 day(s), 0 hour(s), 0 minute(s), 30 second(s), and 54 millisecond(s)
VERBOSE: 10/22/2023 22:31:15.959 - All 15 background thread(s) have been completed. Terminating loop. Please Wait...
VERBOSE: 10/22/2023 22:31:15.969 - Execution of Invoke-PSThread ended on Sunday, October 22, 2023 @ 10:31:15.969 PM
VERBOSE: 10/22/2023 22:31:15.974 - Function execution took 0 hour(s), 0 minute(s), 30 second(s), and 128 millisecond(s)
VERBOSE: 10/22/2023 22:31:15.975 - Function 'Invoke-PSThread' is completed.
```

## SAMPLE OUTPUT:

```
TotalThreads               : 15
CompletedThreadList        : {@{Number=1; Thread=System.Management.Automation.PowerShell; 
                             Input=System.Management.Automation.PSDataCollection`1[System.Management.Automation.PSObject]; 
                             Output=System.Management.Automation.PSDataCollection`1[System.Management.Automation.PSObject]; 
                             Status=System.Management.Automation.PowerShellAsyncResult}, @{Number=2; Thread=System.Management.Automation.PowerShell; 
                             Input=System.Management.Automation.PSDataCollection`1[System.Management.Automation.PSObject]; 
                             Output=System.Management.Automation.PSDataCollection`1[System.Management.Automation.PSObject]; 
                             Status=System.Management.Automation.PowerShellAsyncResult}, @{Number=3; Thread=System.Management.Automation.PowerShell; 
                             Input=System.Management.Automation.PSDataCollection`1[System.Management.Automation.PSObject]; 
                             Output=System.Management.Automation.PSDataCollection`1[System.Management.Automation.PSObject]; 
                             Status=System.Management.Automation.PowerShellAsyncResult}, @{Number=4; Thread=System.Management.Automation.PowerShell; 
                             Input=System.Management.Automation.PSDataCollection`1[System.Management.Automation.PSObject]; 
                             Output=System.Management.Automation.PSDataCollection`1[System.Management.Automation.PSObject]; 
                             Status=System.Management.Automation.PowerShellAsyncResult}...}
CompletedThreadListCount   : 15
CompletedThreadPercentage  : 100
IncompleteThreadList       : {}
IncompleteThreadListCount  : 0
IncompleteThreadPercentage : 0
TimeElasped                : 00:00:30.0566619
```
