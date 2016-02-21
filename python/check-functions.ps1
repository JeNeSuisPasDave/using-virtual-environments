# Extract-Version
#
# A function to extract a version from a string. Extracts the
# first version string found.
#
Function Extract-Version {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory=$True,
      ValueFromPipeline=$True,
      Position=0)]
    [string]$Version
    )
  $vsn_regex = [regex] "([0-9]+)\.([0-9]+)\.([0-9]+)"
  $vsn_match = $vsn_regex.match($Version)
  if ($vsn_match.Success) {
    $vsn_str = $vsn_match.Groups[1].Value + "." +
      $vsn_match.Groups[2].Value + "." +
      $vsn_match.Groups[3].Value
    return $vsn_str -as [System.Version]
  }
  $vsn_regex = [regex] "([0-9]+)\.([0-9]+)"
  $vsn_match = $vsn_regex.match($Version)
  if ($vsn_match.Success) {
    $vsn_str = $vsn_match.Groups[1].Value + "." +
      $vsn_match.Groups[2].Value
    return $vsn_str -as [System.Version]
  }
  return $null
}

# Test-Version
#
# A function to compare version objects.
#
Function Test-Version {
  [CmdletBinding()]
  param(
    [Parameter(
      ParameterSetName="atleast",
      Mandatory=$True,
      ValueFromPipeline=$True,
      Position=0)]
    [Parameter(
      ParameterSetName="lessthan",
      Mandatory=$True,
      ValueFromPipeline=$True,
      Position=0)]
    [System.Version]$VersionToTest,

    [Parameter(ParameterSetName="atleast")]
    [System.Version]$IsAtLeast,

    [Parameter(ParameterSetName="lessthan")]
    [System.Version]$IsLessThan
  )
  If ($PSCmdlet.ParameterSetName -eq "atleast") {
    return ($VersionToTest -ge $IsAtLeast)
  }
  If ($PSCmdlet.ParameterSetName -eq "lessthan") {
    return ($VersionToTest -lt $IsLessThan)
  }
  return $False
}
