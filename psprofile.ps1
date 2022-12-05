
$thisFilePath = $MyInvocation.MyCommand.Path

function profile {
    code $thisFilePath
}

function refresh-profile {
    . $PROFILE
}

function refresh-environmentvariables {

    foreach($level in "Machine","User") {
        [Environment]::GetEnvironmentVariables($level).GetEnumerator() `
        | % {
            # For Path variables, append the new values, if they're not already in there
            if($_.Name -eq 'Path') { 
                $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -split ';' | Select -unique) -join ';'
            }
            $_
        } `
        | Set-Content -Path { "Env:$($_.Name)" }
    }

    # Note:
    # It is not safe to delete any environment variables in current process that don't
    # exist in the System Environment Variable, because current process could have set
    # its own environment variables.
}