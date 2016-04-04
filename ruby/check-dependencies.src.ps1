# NOTE: expect that this is preceded by source command:
# . check-functions.src.ps1
#

$sassVsnExpected_ = "3.1.3" | Extract-Version
$sassVsnMax_ = "3.1.4" | Extract-Version
$chunkypngVsnExpected_ = "1.2.1" | Extract-Version
$chunkypngVsnMax_ = "1.2.2" | Extract-Version
$fssmVsnExpected_ = "0.2.7" | Extract-Version
$fssmVsnMax_ = "0.2.8" | Extract-Version
$compassVsnExpected_ = "0.11.3" | Extract-Version
$compassVsnMax_ = "0.11.4" | Extract-Version

# Capture gem packages
#
$rcmd = "gem"
$rargs = "list" -split " "
[System.Collections.ArrayList]$gems = Invoke-Expression "$rcmd $rargs"


# Check whether sass installed
#
$min = $sassVsnExpected_
$max = $sassVsnMax_
If (-not ("sass" |
        Is-GemInstalled -IsAtLeast $min -IsLessThan $max -GemList $gems)) {
    $errcode = 4
    Exit
}

# Check whether chunky_png installed
#
$min = $chunkypngVsnExpected_
$max = $chunkypngVsnMax_
If (-not ("chunky_png" |
        Is-GemInstalled -IsAtLeast $min -IsLessThan $max -GemList $gems)) {
    $errcode = 4
    Exit
}

# Check whether fssm installed
#
$min = $fssmVsnExpected_
$max = $fssmVsnMax_
If (-not ("fssm" |
        Is-GemInstalled -IsAtLeast $min -IsLessThan $max -GemList $gems)) {
    $errcode = 4
    Exit
}

# Check whether compass installed
#
$min = $compassVsnExpected_
$max = $compassVsnMax_
If (-not ("compass" |
        Is-GemInstalled -IsAtLeast $min -IsLessThan $max -GemList $gems)) {
    $errcode = 4
    Exit
}

# Check whether bundler installed
#
If (-not ("bundler" | Is-GemInstalled -GemList $gems)) {
    $errcode = 4
    Exit
}
