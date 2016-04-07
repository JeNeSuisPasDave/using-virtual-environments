# NOTE: expect that this is preceded by source command:
# . check-functions.src.ps1
#

$sassVsnExpected_ = "3.4.21" | Extract-Version
$sassVsnMax_ = "3.5.0" | Extract-Version
$ffiVsnExpected_ = "1.9.10" | Extract-Version
$ffiVsnMax_ = "1.9.11" | Extract-Version
$rbinotifyVsnExpected_ = "0.9.7" | Extract-Version
$rbinotifyVsnMax_ = "0.9.8" | Extract-Version
$rbfseventVsnExpected_ = "0.9.7" | Extract-Version
$rbfseventVsnMax_ = "0.9.8" | Extract-Version
$compassimportonceVsnExpected_ = "1.0.5" | Extract-Version
$compassimportonceVsnMax_ = "1.0.6" | Extract-Version
$multijsonVsnExpected_ = "1.11.2" | Extract-Version
$multijsonVsnMax_ = "1.11.3" | Extract-Version
$compasscoreVsnExpected_ = "1.0.3" | Extract-Version
$compasscoreVsnMax_ = "1.0.4" | Extract-Version
$chunkypngVsnExpected_ = "1.3.5" | Extract-Version
$chunkypngVsnMax_ = "1.3.6" | Extract-Version
$compassVsnExpected_ = "1.0.3" | Extract-Version
$compassVsnMax_ = "1.1.0" | Extract-Version

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

# Check whether ffi installed
#
$min = $ffiVsnExpected_
$max = $ffiVsnMax_
If (-not ("ffi" |
        Is-GemInstalled -IsAtLeast $min -IsLessThan $max -GemList $gems)) {
    $errcode = 4
    Exit
}

# Check whether rb-inotify installed
#
$min = $rbinotifyVsnExpected_
$max = $rbinotifyVsnMax_
If (-not ("rb-inotify" |
        Is-GemInstalled -IsAtLeast $min -IsLessThan $max -GemList $gems)) {
    $errcode = 4
    Exit
}

# Check whether rb-fsevent installed
#
$min = $rbfseventVsnExpected_
$max = $rbfseventVsnMax_
If (-not ("rb-fsevent" |
        Is-GemInstalled -IsAtLeast $min -IsLessThan $max -GemList $gems)) {
    $errcode = 4
    Exit
}
# Check whether compass-import-once installed
#
$min = $compassimportonceVsnExpected_
$max = $compassimportonceVsnMax_
If (-not ("compass-import-once" |
        Is-GemInstalled -IsAtLeast $min -IsLessThan $max -GemList $gems)) {
    $errcode = 4
    Exit
}

# Check whether multi_json installed
#
$min = $multijsonVsnExpected_
$max = $multijsonVsnMax_
If (-not ("multi_json" |
        Is-GemInstalled -IsAtLeast $min -IsLessThan $max -GemList $gems)) {
    $errcode = 4
    Exit
}

# Check whether compass-core installed
#
$min = $compasscoreVsnExpected_
$max = $compasscoreVsnMax_
If (-not ("compass-core" |
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
