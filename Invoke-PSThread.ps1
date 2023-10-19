## Microsoft Function Naming Convention: http://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx

#region Function Invoke-PSThread
Function Invoke-PSThread
    {
        <#
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

          #Do some additional code here

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
        #>
        
        [CmdletBinding(ConfirmImpact = 'Low', DefaultParameterSetName = 'Runspace', HelpURI = '', SupportsShouldProcess = $True, PositionalBinding = $True)]
       
        Param
          (        
              [Parameter(Mandatory=$False, ParameterSetName = 'Runspace')]
              [Alias('RS')]
              [Switch]$Runspace,

              [Parameter(Mandatory=$False, ParameterSetName = 'RunspacePool')]
              [Alias('RP')]
              [Switch]$RunspacePool,

              [Parameter(Mandatory=$False, ParameterSetName = 'Await')]
              [Alias('AW')]
              [Switch]$Await,

              [Parameter(Mandatory=$True, ParameterSetName = 'Runspace')]
              [Parameter(Mandatory=$True, ParameterSetName = 'RunspacePool')]
              [ValidateNotNullOrEmpty()]
              [Alias('RD')]
              [ScriptBlock]$RunspaceDefinition,

              [Parameter(Mandatory=$False, ParameterSetName = 'Runspace')]
              [Parameter(Mandatory=$False, ParameterSetName = 'RunspacePool')]
              [ValidateNotNullOrEmpty()]
              [Alias('RSP')]
              [System.Collections.Specialized.OrderedDictionary]$RunspaceParameters,

              [Parameter(Mandatory=$True, ParameterSetName = 'RunspacePool')]
              [ValidateNotNullOrEmpty()]
              [Alias('IOL')]
              [System.Object[]]$InputObjectList,
  
              [Parameter(Mandatory=$False, ParameterSetName = 'Runspace')]
              [Parameter(Mandatory=$False, ParameterSetName = 'RunspacePool')]
              [ValidateNotNullOrEmpty()]
              [Alias('SHT')]
              [System.Management.Automation.PSVariable]$SynchronizedHashtable,

              [Parameter(Mandatory=$False, ParameterSetName = 'Runspace')]
              [Parameter(Mandatory=$False, ParameterSetName = 'RunspacePool')]
              [Alias('AL')]
              [System.Management.Automation.Runspaces.SessionStateAssemblyEntry[]]$AssemblyList,

              [Parameter(Mandatory=$False, ParameterSetName = 'Runspace')]
              [Parameter(Mandatory=$False, ParameterSetName = 'RunspacePool')]
              [Alias('FL')]
              [System.Management.Automation.FunctionInfo[]]$FunctionList,

              [Parameter(Mandatory=$False, ParameterSetName = 'Runspace')]
              [Parameter(Mandatory=$False, ParameterSetName = 'RunspacePool')]
              [Alias('ML')]
              [System.Management.Automation.PSModuleInfo[]]$ModuleList,

              [Parameter(Mandatory=$False, ParameterSetName = 'Runspace')]
              [Parameter(Mandatory=$False, ParameterSetName = 'RunspacePool')]
              [Alias('VL')]
              [System.Management.Automation.PSVariable[]]$VariableList,

              [Parameter(Mandatory=$True, ParameterSetName = 'Await')]
              [ValidateNotNullOrEmpty()]
              [Alias('TL')]
              [System.Management.Automation.PSObject[]]$ThreadList,

              [Parameter(Mandatory=$False, ParameterSetName = 'Await')]
              [ValidateNotNullOrEmpty()]
              [Alias('TO')]
              [System.TimeSpan]$LoopTimeout,

              [Parameter(Mandatory=$False, ParameterSetName = 'Await')]
              [ValidateNotNullOrEmpty()]
              [Alias('LD')]
              [System.TimeSpan]$LoopDuration,

              [Parameter(Mandatory=$False)]
              [Alias('WFAR')]
              [Switch]$WaitForAvailableRunspace,
                                            
              [Parameter(Mandatory=$False)]
              [Alias('COE')]
              [Switch]$ContinueOnError
          )
                    
        Begin
          {

              
              Try
                {
                    $DateTimeLogFormat = 'dddd, MMMM dd, yyyy @ hh:mm:ss.FFF tt'  ###Monday, January 01, 2019 @ 10:15:34.000 AM###
                    [ScriptBlock]$GetCurrentDateTimeLogFormat = {(Get-Date).ToString($DateTimeLogFormat)}
                    $DateTimeMessageFormat = 'MM/dd/yyyy HH:mm:ss.FFF'  ###03/23/2022 11:12:48.347###
                    [ScriptBlock]$GetCurrentDateTimeMessageFormat = {(Get-Date).ToString($DateTimeMessageFormat)}
                    $DateFileFormat = 'yyyyMMdd'  ###20190403###
                    [ScriptBlock]$GetCurrentDateFileFormat = {(Get-Date).ToString($DateFileFormat)}
                    $DateTimeFileFormat = 'yyyyMMdd_HHmmss'  ###20190403_115354###
                    [ScriptBlock]$GetCurrentDateTimeFileFormat = {(Get-Date).ToString($DateTimeFileFormat)}
                    $TextInfo = (Get-Culture).TextInfo
                    $LoggingDetails = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'    
                      $LoggingDetails.Add('LogMessage', $Null)
                      $LoggingDetails.Add('WarningMessage', $Null)
                      $LoggingDetails.Add('ErrorMessage', $Null)
                    $CommonParameterList = New-Object -TypeName 'System.Collections.Generic.List[String]'
                      $CommonParameterList.AddRange([System.Management.Automation.PSCmdlet]::CommonParameters)
                      $CommonParameterList.AddRange([System.Management.Automation.PSCmdlet]::OptionalCommonParameters)

                    [ScriptBlock]$ErrorHandlingDefinition = {
                                                                Param
                                                                  (
                                                                      [Int16]$Severity,
                                                                      [Boolean]$ContinueOnError
                                                                  )
                                                                                                                
                                                                $ExceptionPropertyDictionary = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                                                  $ExceptionPropertyDictionary.Add('Message', $_.Exception.Message)
                                                                  $ExceptionPropertyDictionary.Add('Category', $_.Exception.ErrorRecord.FullyQualifiedErrorID)
                                                                  $ExceptionPropertyDictionary.Add('Script', [System.IO.Path]::GetFileName($_.InvocationInfo.ScriptName))
                                                                  $ExceptionPropertyDictionary.Add('LineNumber', $_.InvocationInfo.ScriptLineNumber)
                                                                  $ExceptionPropertyDictionary.Add('LinePosition', $_.InvocationInfo.OffsetInLine)
                                                                  $ExceptionPropertyDictionary.Add('Code', $_.InvocationInfo.Line.Trim())

                                                                $ExceptionMessageList = New-Object -TypeName 'System.Collections.Generic.List[String]'

                                                                ForEach ($ExceptionProperty In $ExceptionPropertyDictionary.GetEnumerator())
                                                                  {
                                                                      $ExceptionMessageList.Add("[$($ExceptionProperty.Key): $($ExceptionProperty.Value)]")
                                                                  }

                                                                $LogMessageParameters = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                                                  $LogMessageParameters.Message = $ExceptionMessageList -Join ' '
                                                                  $LogMessageParameters.Verbose = $True
                              
                                                                Switch ($Severity)
                                                                  {
                                                                      {($_ -in @(1))} {Write-Verbose @LogMessageParameters}
                                                                      {($_ -in @(2))} {Write-Warning @LogMessageParameters}
                                                                      {($_ -in @(3))} {Write-Error @LogMessageParameters}
                                                                  }

                                                                Switch ($ContinueOnError)
                                                                  {
                                                                      {($_ -eq $False)}
                                                                        {                  
                                                                            Throw
                                                                        }
                                                                  }
                                                            }
                    
                    #Determine the date and time we executed the function
                      $FunctionStartTime = (Get-Date)
                    
                    [String]$FunctionName = $MyInvocation.MyCommand
                    [System.IO.FileInfo]$InvokingScriptPath = $MyInvocation.PSCommandPath
                    [System.IO.DirectoryInfo]$InvokingScriptDirectory = $InvokingScriptPath.Directory.FullName
                    [System.IO.FileInfo]$FunctionPath = "$($InvokingScriptDirectory.FullName)\Functions\$($FunctionName).ps1"
                    [System.IO.DirectoryInfo]$FunctionDirectory = "$($FunctionPath.Directory.FullName)"
                    
                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Function `'$($FunctionName)`' is beginning. Please Wait..."
                    Write-Verbose -Message ($LoggingDetails.LogMessage)
              
                    #Define Default Action Preferences
                      $ErrorActionPreference = 'Stop'
                      
                    [String[]]$AvailableScriptParameters = (Get-Command -Name ($FunctionName)).Parameters.GetEnumerator() | Where-Object {($_.Value.Name -inotin $CommonParameterList)} | ForEach-Object {"-$($_.Value.Name):$($_.Value.ParameterType.Name)"}
                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Available Function Parameter(s) = $($AvailableScriptParameters -Join ', ')"
                    Write-Verbose -Message ($LoggingDetails.LogMessage)

                    [String[]]$SuppliedScriptParameters = $PSBoundParameters.GetEnumerator() | ForEach-Object {Try {"-$($_.Key):$($_.Value.GetType().Name)"} Catch {"Uknown:Unknown"}}
                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Supplied Function Parameter(s) = $($SuppliedScriptParameters -Join ', ')"
                    Write-Verbose -Message ($LoggingDetails.LogMessage)

                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Execution of $($FunctionName) began on $($FunctionStartTime.ToString($DateTimeLogFormat))"
                    Write-Verbose -Message ($LoggingDetails.LogMessage)
                                        
                    #Create an object that will contain the functions output.
                      $OutputObjectList = New-Object -TypeName 'System.Collections.Generic.List[System.Management.Automation.PSObject]'

                    #Determine the parameter set name
                      $ParameterSetName = $PSCmdlet.ParameterSetName

                      $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Parameter Set Name: $($ParameterSetName)" 
                      Write-Verbose -Message ($LoggingDetails.LogMessage)
                }
              Catch
                {
                    $ErrorHandlingDefinition.Invoke(2, $ContinueOnError.IsPresent)
                }
              Finally
                {
                    
                }
          }

        Process
          {           
              Try
                {  
                    Switch (($PSBoundParameters.ContainsKey('SynchronizedHashtable') -eq $True) -and ($Null -ine $SynchronizedHashtable.Value) -and ($SynchronizedHashtable.Value -is [System.Collections.Hashtable]) -and ($SynchronizedHashtable.Value.IsSynchronized -eq $False))
                      {
                          {($_ -eq $True)}
                            {
                                $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - The specified hashtable is not synchronized." 
                                Write-Warning -Message ($LoggingDetails.LogMessage)

                                $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Example: `$SynchronizedHashtable = [System.Collections.Hashtable]::Synchronized(@{})" 
                                Write-Warning -Message ($LoggingDetails.LogMessage)

                                Return
                            }
                      }
                    
                    $InitialSessionStateObjectDictionary = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                      $InitialSessionStateObjectDictionary.Assemblies = $AssemblyList
                      $InitialSessionStateObjectDictionary.Functions = $FunctionList
                      $InitialSessionStateObjectDictionary.Modules = $ModuleList
                      $InitialSessionStateObjectDictionary.Variables = $VariableList

                    Switch ($InitialSessionStateObjectDictionary.Keys.Count -gt 0)
                      {
                          {($_ -eq $True)}
                            {
                                $InitialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()

                                ForEach ($InitialSessionStateObject In $InitialSessionStateObjectDictionary.GetEnumerator())
                                  {
                                      $InitialSessionStateObjectList = $InitialSessionStateObject.Value
                          
                                      $InitialSessionStateObjectListCount = ($InitialSessionStateObjectList | Measure-Object).Count

                                      Switch ($InitialSessionStateObjectListCount -gt 0)
                                        {
                                            {($_ -eq $True)}
                                              {
                                                  Switch ($InitialSessionStateObject.Key)
                                                    {
                                                        {($_ -iin @('Assemblies'))}
                                                          {
                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to import $($InitialSessionStateObjectListCount) $($InitialSessionStateObject.Key.ToLower()) into the initial session state. Please Wait..." 
                                                              Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                          }
                                                        
                                                        {($_ -iin @('Functions'))}
                                                          {
                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to import $($InitialSessionStateObjectListCount) $($InitialSessionStateObject.Key.ToLower()) into the initial session state. Please Wait..." 
                                                              Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                          }

                                                        {($_ -iin @('Modules'))}
                                                          {
                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to import $($InitialSessionStateObjectListCount) $($InitialSessionStateObject.Key.ToLower()) into the initial session state. Please Wait..." 
                                                              Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                          }

                                                        {($_ -iin @('Variables'))}
                                                          {
                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to import $($InitialSessionStateObjectListCount) $($InitialSessionStateObject.Key.ToLower()) into the initial session state. Please Wait..." 
                                                              Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                          }
                                                    }
                                                  
                                                  $InitialSessionStateObjectType = $InitialSessionStateObject.Key.TrimEnd('s').ToLower()

                                                  For ($InitialSessionStateObjectListIndex = 0; $InitialSessionStateObjectListIndex -lt $InitialSessionStateObjectListCount; $InitialSessionStateObjectListIndex++)
                                                    {
                                                        $InitialSessionStateObjectListItem = $InitialSessionStateObjectList[$InitialSessionStateObjectListIndex]

                                                        Switch ($InitialSessionStateObject.Key)
                                                          {
                                                              {($_ -iin @('Assemblies'))}
                                                                {
                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to add a session state assembly entry for `"$($InitialSessionStateObjectListItem.Name)`". Please Wait... [File Name: $($InitialSessionStateObjectListItem.FileName)]" 
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage)
      
                                                                    $Null = $InitialSessionState.Assemblies.Add($InitialSessionStateObjectListItem)
                                                                }
                                                              
                                                              {($_ -iin @('Functions'))}
                                                                {
                                                                    $SessionStateFunctionEntry = New-Object -TypeName 'System.Management.Automation.Runspaces.SessionStateFunctionEntry' -ArgumentList @($InitialSessionStateObjectListItem.Name, $InitialSessionStateObjectListItem.Definition)

                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to add a session state $($InitialSessionStateObjectType) entry for `"$($InitialSessionStateObjectListItem.Name)`". Please Wait..." 
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage)
      
                                                                    $Null = $InitialSessionState.Commands.Add($SessionStateFunctionEntry)
                                                                }

                                                              {($_ -iin @('Modules'))}
                                                                {
                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to add a session state $($InitialSessionStateObjectType) entry for `"$($InitialSessionStateObjectListItem.Name)`". Please Wait..." 
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage)
      
                                                                    $Null = $InitialSessionState.ImportPSModulesFromPath($InitialSessionStateObjectListItem.ModuleBase)
                                                                }

                                                              {($_ -iin @('Variables'))}
                                                                {
                                                                    $SessionStateVariableEntry = New-Object -TypeName 'System.Management.Automation.Runspaces.SessionStateVariableEntry' -ArgumentList @($InitialSessionStateObjectListItem.Name, $InitialSessionStateObjectListItem.Value, $InitialSessionStateObjectListItem.Description)

                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to add a session state $($InitialSessionStateObjectType) entry for `"$($InitialSessionStateObjectListItem.Name)`". Please Wait..." 
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage)

                                                                    $Null = $InitialSessionState.Variables.Add($SessionStateVariableEntry)
                                                                }
                                                          }
                                                    }
                                              }
                                        }
                                  }
                            }
                      }
                    
                    Switch ($ParameterSetName)
                      {
                          {($_ -iin @('Runspace'))}
                            {                                
                                $ConfigurationTable = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'    
                                  $ConfigurationTable.Runspace = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace($Host, $InitialSessionState)   
                                  $ConfigurationTable.Runspace.ThreadOptions = [System.Management.Automation.Runspaces.PSThreadOptions]::ReuseThread
                                  $ConfigurationTable.Runspace.ApartmentState = [System.Threading.ApartmentState]::MTA

                                $ConfigurationTable.Thread = [System.Management.Automation.PowerShell]::Create()

                                $Null = $ConfigurationTable.Thread.Runspace = $ConfigurationTable.Runspace   
                                
                                $Null = $ConfigurationTable.Runspace.Open()

                                $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to add the runspace definition to the runspace. Please Wait..." 
                                Write-Verbose -Message ($LoggingDetails.LogMessage)
                                
                                $Null = $ConfigurationTable.Thread.AddScript($RunspaceDefinition, $True)
                                
                                Switch ($True)
                                  {
                                      {($PSBoundParameters.ContainsKey('SynchronizedHashtable') -eq $True) -and ($Null -ine $SynchronizedHashtable.Value) -and ($SynchronizedHashtable.Value -is [System.Collections.Hashtable]) -and ($SynchronizedHashtable.Value.IsSynchronized -eq $True)}
                                        {
                                            $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to attach the synchronized hashtable variable of `"$($SynchronizedHashtable.Name)`" into the runspace. Please Wait..." 
                                            Write-Verbose -Message ($LoggingDetails.LogMessage)

                                            $Null = $ConfigurationTable.Thread.AddParameter($SynchronizedHashtable.Name, $SynchronizedHashtable.Value)
                                        }

                                      {($Null -ine $RunspaceParameters)}
                                        {
                                            ForEach ($RunspaceParameter In $RunspaceParameters.GetEnumerator())
                                              {
                                                  #$LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to add the value for parameter `"$($RunspaceParameter.Key)`" into the runspace. Please Wait..." 
                                                  #Write-Verbose -Message ($LoggingDetails.LogMessage)

                                                  $Null = $ConfigurationTable.Thread.AddParameter($RunspaceParameter.Key, $RunspaceParameter.Value)
                                              }
                                        }
                                  }
                                
                                $OutputObjectProperties = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                  $OutputObjectProperties.Number = 1
                                  $OutputObjectProperties.Thread = $ConfigurationTable.Thread
                                  $OutputObjectProperties.Input = New-Object 'System.Management.Automation.PSDataCollection[System.Management.Automation.PSObject]'
                                  $OutputObjectProperties.Output = New-Object 'System.Management.Automation.PSDataCollection[System.Management.Automation.PSObject]'
                                  $OutputObjectProperties.Status = $OutputObjectProperties.Thread.BeginInvoke($OutputObjectProperties.Input, $OutputObjectProperties.Output)
                                                                
                                $OutputObject = New-Object -TypeName 'System.Management.Automation.PSObject' -Property ($OutputObjectProperties)
                                
                                $OutputObjectList.Add($OutputObject)
                            }

                          {($_ -iin @('RunspacePool'))}
                            {                                
                                $ProcessorInfoPropertyName = 'NumberOfLogicalProcessors'
                                
                                $ProcessorInfo = Get-CIMInstance -Namespace 'Root\CIMv2' -ClassName 'Win32_Processor' -Property ($ProcessorInfoPropertyName) -Verbose:$False

                                $ConfigurationTable = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                  $ConfigurationTable.MinimumRunspaces = 1
                                  $ConfigurationTable.MaximumRunspaces = ($ProcessorInfo | Measure-Object -Property ($ProcessorInfoPropertyName) -Sum).Sum
                                  $ConfigurationTable.RunspacePool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool($ConfigurationTable.MinimumRunspaces, $ConfigurationTable.MaximumRunspaces, $InitialSessionState, $Host)
                                    $ConfigurationTable.RunspacePool.ThreadOptions = [System.Management.Automation.Runspaces.PSThreadOptions]::ReuseThread
                                    $ConfigurationTable.RunspacePool.ApartmentState = [System.Threading.ApartmentState]::MTA

                                $Null = $ConfigurationTable.RunspacePool.Open()
 
                                $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to open a new runspace pool. Please Wait... [Minimum Runspaces: $($ConfigurationTable.RunspacePool.GetMinRunspaces())] [Maximum Runspaces: $($ConfigurationTable.RunspacePool.GetMaxRunspaces())]" 
                                Write-Verbose -Message ($LoggingDetails.LogMessage)
                                
                                $InputObjectListCounter = 1
                                
                                $InputObjectListCount = ($InputObjectList | Measure-Object).Count

                                Switch ($InputObjectListCount -gt 0)
                                  {
                                      {($_ -eq $True)}
                                        {
                                            For ($InputObjectListIndex = 0; $InputObjectListIndex -lt $InputObjectListCount; $InputObjectListIndex++)
                                              {
                                                  Try
                                                    {
                                                        $InputObjectListItem = $InputObjectList[$InputObjectListIndex]

                                                        Switch ($Null -ine $InputObjectListItem)
                                                          {
                                                              {($_ -eq $True)}
                                                                {
                                                                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to create a new runspace for input object list item $($InputObjectListCounter) of $($InputObjectListCount). Please Wait... [InputObjectType: $($InputObjectListItem.GetType().Name)]" 
                                                                    Write-Verbose -Message ($LoggingDetails.LogMessage)

                                                                    $ConfigurationTable.RunspacePoolThread = [System.Management.Automation.PowerShell]::Create()
                                            
                                                                    $Null = $ConfigurationTable.RunspacePoolThread.RunspacePool = $ConfigurationTable.RunspacePool
                                
                                                                    $Null = $ConfigurationTable.RunspacePoolThread.AddScript($RunspaceDefinition, $True)

                                                                    $Null = $ConfigurationTable.RunspacePoolThread.AddParameter('InputObjectListItem', $InputObjectListItem)
                                
                                                                    Switch ($True)
                                                                      {
                                                                          {($PSBoundParameters.ContainsKey('SynchronizedHashtable') -eq $True) -and ($Null -ine $SynchronizedHashtable.Value) -and ($SynchronizedHashtable.Value -is [System.Collections.Hashtable]) -and ($SynchronizedHashtable.Value.IsSynchronized -eq $True)}
                                                                            {
                                                                                #$LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to attach the synchronized variable table to the runspace pool thread. Please Wait..." 
                                                                                #Write-Verbose -Message ($LoggingDetails.LogMessage)

                                                                                $Null = $ConfigurationTable.RunspacePoolThread.AddParameter($SynchronizedHashtable.Name, $SynchronizedHashtable.Value)
                                                                            }
                                                              
                                                                          {($Null -ine $RunspaceParameters)}
                                                                            {
                                                                                ForEach ($RunspaceParameter In $RunspaceParameters.GetEnumerator())
                                                                                  {
                                                                                      #$LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Attempting to add the value for parameter `"$($RunspaceParameter.Key)`" into the runspace. Please Wait..." 
                                                                                      #Write-Verbose -Message ($LoggingDetails.LogMessage)

                                                                                      $Null = $ConfigurationTable.RunspacePoolThread.AddParameter($RunspaceParameter.Key, $RunspaceParameter.Value)
                                                                                  } 
                                                                            }
                                                                      }
                                
                                                                    $OutputObjectProperties = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                                                      $OutputObjectProperties.Number = $InputObjectListCounter
                                                                      $OutputObjectProperties.Thread = $ConfigurationTable.RunspacePoolThread
                                                                      $OutputObjectProperties.Input = New-Object 'System.Management.Automation.PSDataCollection[System.Management.Automation.PSObject]'
                                                                      $OutputObjectProperties.Output = New-Object 'System.Management.Automation.PSDataCollection[System.Management.Automation.PSObject]'
                                                                      $OutputObjectProperties.Status = $OutputObjectProperties.Thread.BeginInvoke($OutputObjectProperties.Input, $OutputObjectProperties.Output)
                                                                                        
                                                                    $OutputObject = New-Object -TypeName 'System.Management.Automation.PSObject' -Property ($OutputObjectProperties)
                                
                                                                    $OutputObjectList.Add($OutputObject)

                                                                    Switch ($WaitForAvailableRunspace.IsPresent)
                                                                      {
                                                                          {($_ -eq $True)}
                                                                            {
                                                                                Do
                                                                                  {
                                                                                      #$LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Waiting for an available runspace. Please Wait... [Available Runspaces: $($ConfigurationTable.RunspacePool.GetAvailableRunspaces())]" 
                                                                                      #Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                          
                                                                                      $Null = Start-Sleep -Milliseconds 1500
                                                                                  } 
                                                                                While ($ConfigurationTable.RunspacePool.GetAvailableRunspaces() -lt 1)
                                                                            }
                                                                      }
                                                                }

                                                              Default
                                                                {
                                                                    ###Invalid/Null input object list item. Skip.
                                                                }
                                                          }  
                                                    }
                                                  Catch
                                                    {
                                                        Throw
                                                    }
                                                  Finally
                                                    {
                                                        $InputObjectListCounter++
                                                    }
                                              }
                                        }
                                  }
                            }

                          {($_ -iin @('Await'))}
                            {
                                $Stopwatch = New-Object -TypeName 'System.Diagnostics.Stopwatch'
                                
                                $ThreadListCount = ($ThreadList | Measure-Object).Count

                                $OutputObjectProperties = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary'
                                  $OutputObjectProperties.TotalThreads = $ThreadListCount
                                  $OutputObjectProperties.CompletedThreadList = New-Object 'System.Management.Automation.PSDataCollection[System.Management.Automation.PSObject]'
                                  $OutputObjectProperties.CompletedThreadListCount = 0
                                  $OutputObjectProperties.CompletedThreadPercentage = 0
                                  $OutputObjectProperties.IncompleteThreadList = New-Object 'System.Management.Automation.PSDataCollection[System.Management.Automation.PSObject]'
                                  $OutputObjectProperties.IncompleteThreadListCount = 0
                                  $OutputObjectProperties.IncompleteThreadPercentage = 0
                                  $OutputObjectProperties.TimeElasped = $Stopwatch.Elapsed
                                
                                Switch ($ThreadListCount -gt 0)
                                  { 
                                      {($_ -eq $True)}
                                        {                                                                                        
                                            Switch ($True)
                                              {
                                                  {($Null -ieq $LoopDuration)}
                                                    {
                                                        [System.TimeSpan]$LoopDuration = [System.TimeSpan]::FromMilliseconds(15000)
                                                    }
                                              }
                                            
                                            $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Loop Timeout: $($LoopTimeout.Days) day(s), $($LoopTimeout.Hours) hour(s), $($LoopTimeout.Minutes) minute(s), $($LoopTimeout.Seconds) second(s), and $($LoopTimeout.Milliseconds) millisecond(s)"
                                            Write-Verbose -Message ($LoggingDetails.LogMessage)

                                            [DateTime]$LoopBeginDateTime = (Get-Date)
                                            
                                            $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Current Time: $($LoopBeginDateTime.ToString($DateTimeLogFormat))"
                                            Write-Verbose -Message ($LoggingDetails.LogMessage)
                                            
                                            [DateTime]$LoopTimeoutDateTime = ($LoopBeginDateTime).AddTicks($LoopTimeout.Ticks)

                                            $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Loop Timeout Time: $($LoopTimeoutDateTime.ToString($DateTimeLogFormat))"
                                            Write-Verbose -Message ($LoggingDetails.LogMessage)

                                            $Null = $Stopwatch.Start()

                                            :ThreadCompletionLoop Do
                                              {
                                                  $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Elasped Time: $($Stopwatch.Elapsed.Days) day(s), $($Stopwatch.Elapsed.Hours) hour(s), $($Stopwatch.Elapsed.Minutes) minute(s), $($Stopwatch.Elapsed.Seconds) second(s), and $($Stopwatch.Elapsed.Milliseconds) millisecond(s)"
                                                  Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                              
                                                  Switch ($True)
                                                    {
                                                        {($Null -ine $LoopTimeout) -and ($LoopTimeout.TotalMilliseconds -lt $Stopwatch.Elapsed.TotalMilliseconds)}
                                                          {
                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - The loop timeout has been met or exceeded. Terminating loop. Please Wait..."
                                                              Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                          
                                                              Break ThreadCompletionLoop
                                                          }

                                                        {($ThreadList.Status.IsCompleted -notcontains $False)}
                                                          {
                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - All $($ThreadListCount) background thread(s) have been completed. Terminating loop. Please Wait..."
                                                              Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                          
                                                              Break ThreadCompletionLoop
                                                          }

                                                        Default
                                                          {                                                                          
                                                              $MetricDictionary = New-Object -TypeName 'System.Collections.Specialized.OrderedDictionary' 
                                                                $MetricDictionary.CompletedThreadList = $ThreadList | Where-Object {($_.Status.IsCompleted -eq $True)}
                                                                $MetricDictionary.CompletedThreadListCount = ($MetricDictionary.CompletedThreadList | Measure-Object).Count
                                                                $MetricDictionary.IncompleteThreadList = $ThreadList | Where-Object {($_.Status.IsCompleted -eq $False)}
                                                                $MetricDictionary.IncompleteThreadListCount = ($MetricDictionary.IncompleteThreadList | Measure-Object).Count
  
                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Total Threads: $($ThreadListCount)"
                                                              Write-Verbose -Message ($LoggingDetails.LogMessage)

                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Completed Threads: $($MetricDictionary.CompletedThreadListCount)"
                                                              Write-Verbose -Message ($LoggingDetails.LogMessage)

                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Incomplete Threads: $($MetricDictionary.IncompleteThreadListCount)"
                                                              Write-Verbose -Message ($LoggingDetails.LogMessage)

                                                              $MetricDictionary.CompletedThreadPercentage = [System.Math]::Round((($MetricDictionary.CompletedThreadListCount / $ThreadListCount) * 100), 2)

                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Thread Completion Percentage: $($MetricDictionary.CompletedThreadPercentage)%"
                                                              Write-Verbose -Message ($LoggingDetails.LogMessage)

                                                              $MetricDictionary.IncompleteThreadPercentage = [System.Math]::Round((($MetricDictionary.IncompleteThreadListCount / $ThreadListCount) * 100), 2)

                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Thread Incompletion Percentage: $($MetricDictionary.IncompleteThreadPercentage)%"
                                                              Write-Verbose -Message ($LoggingDetails.LogMessage)

                                                              $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Checking again in: $($LoopDuration.Days) day(s), $($LoopDuration.Hours) hour(s), $($LoopDuration.Minutes) minute(s), $($LoopDuration.Seconds) second(s), and $($LoopDuration.Milliseconds) millisecond(s)"
                                                              Write-Verbose -Message ($LoggingDetails.LogMessage)
                                                                          
                                                              $Null = Start-Sleep -Milliseconds ($LoopDuration.TotalMilliseconds)
                                                          }
                                                    }
                                              }
                                            While ($True)

                                            $Null = $Stopwatch.Stop()

                                            $OutputObjectProperties.TotalThreads = $ThreadListCount 
                                            $OutputObjectProperties.CompletedThreadListCount = ($ThreadList | Where-Object {($_.Status.IsCompleted -eq $True)} | Measure-Object).Count
                                            $OutputObjectProperties.CompletedThreadPercentage = [System.Math]::Round((($OutputObjectProperties.CompletedThreadListCount / $OutputObjectProperties.TotalThreads) * 100), 2) 
                                            $OutputObjectProperties.IncompleteThreadListCount = ($ThreadList | Where-Object {($_.Status.IsCompleted -eq $False)} | Measure-Object).Count
                                            $OutputObjectProperties.IncompleteThreadPercentage = [System.Math]::Round((($OutputObjectProperties.IncompleteThreadListCount / $OutputObjectProperties.TotalThreads) * 100), 2)
                                            $OutputObjectProperties.TimeElasped = $Stopwatch.Elapsed

                                            Switch ($True)
                                              {
                                                  {($OutputObjectProperties.CompletedThreadListCount -gt 0)}
                                                    {
                                                        $OutputObjectProperties.CompletedThreadList = $ThreadList | Where-Object {($_.Status.IsCompleted -eq $True)}
                                                    }

                                                  {($OutputObjectProperties.IncompleteThreadListCount -gt 0)}
                                                    {
                                                        $OutputObjectProperties.IncompleteThreadList = $ThreadList | Where-Object {($_.Status.IsCompleted -eq $False)}
                                                    }
                                              }

                                            $Null = $Stopwatch.Reset()
                                        }
                                  }                         
                            }
                      }
                }
              Catch
                {
                    $ErrorHandlingDefinition.Invoke(2, $ContinueOnError.IsPresent)
                }
              Finally
                {
                    
                }
          }
        
        End
          {                                        
              Try
                {
                    #Determine the date and time the function completed execution
                      $FunctionEndTime = (Get-Date)

                      $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Execution of $($FunctionName) ended on $($FunctionEndTime.ToString($DateTimeLogFormat))"
                      Write-Verbose -Message ($LoggingDetails.LogMessage)

                    #Log the total script execution time  
                      $FunctionExecutionTimespan = New-TimeSpan -Start ($FunctionStartTime) -End ($FunctionEndTime)

                      $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Function execution took $($FunctionExecutionTimespan.Hours.ToString()) hour(s), $($FunctionExecutionTimespan.Minutes.ToString()) minute(s), $($FunctionExecutionTimespan.Seconds.ToString()) second(s), and $($FunctionExecutionTimespan.Milliseconds.ToString()) millisecond(s)"
                      Write-Verbose -Message ($LoggingDetails.LogMessage)
                    
                    $LoggingDetails.LogMessage = "$($GetCurrentDateTimeMessageFormat.Invoke()) - Function `'$($FunctionName)`' is completed."
                    Write-Verbose -Message ($LoggingDetails.LogMessage)
                }
              Catch
                {
                    $ErrorHandlingDefinition.Invoke(2, $ContinueOnError.IsPresent)
                }
              Finally
                {
                    Switch ($ParameterSetName)
                      {
                          {($_ -iin @('Await'))}
                            {
                                $OutputObject = New-Object -TypeName 'System.Management.Automation.PSObject' -Property ($OutputObjectProperties)

                                Write-Output -InputObject ($OutputObject)
                            }

                          Default
                            {
                                $OutputObjectList = $OutputObjectList.ToArray()

                                Write-Output -InputObject ($OutputObjectList)
                            }
                      }
                }
          }
    }
#endregion