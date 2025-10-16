# Prompt for input
$inputId = Read-Host "Enter a GUID or Entra ID SID (S-1-12-1-...)"

# Helper validation functions
function Is-Guid($str) {
    try {
        [Guid]::Parse($str) | Out-Null
        return $true
    } catch {
        return $false
    }
}

function Is-EntraSid($str) {
    return $str -match '^S-1-12-1-(?:\d+-){3}\d+$'
}

# Conversion functions
function Convert-GuidToSid($guidStr) {
    $guid = [Guid]::Parse($guidStr)
    $bytes = $guid.ToByteArray()
    $parts = New-Object 'UInt32[]' 4
    [Buffer]::BlockCopy($bytes, 0, $parts, 0, 16)
    return "S-1-12-1-" + ($parts -join '-')
}

function Convert-SidToGuid($sidStr) {
    $prefix = "S-1-12-1-"
    if (-not $sidStr.StartsWith($prefix)) {
        throw "Input is not in Entra ID SID format (S-1-12-1-...)."
    }
    $numStr = $sidStr.Substring($prefix.Length)
    $nums = $numStr.Split('-')
    if ($nums.Count -ne 4) {
        throw "Entra ID SID should have 4 numeric components after 'S-1-12-1-'."
    }
    $array = [UInt32[]] $nums
    $bytes = New-Object 'Byte[]' 16
    [Buffer]::BlockCopy($array, 0, $bytes, 0, 16)
    return [Guid] $bytes
}

# Determine input type and perform conversion
try {
    if (Is-Guid $inputId) {
        $converted = Convert-GuidToSid $inputId
        Write-Output "GUID to SID: $converted"
    }
    elseif (Is-EntraSid $inputId) {
        $converted = Convert-SidToGuid $inputId
        Write-Output "SID to GUID: $converted"
    }
    else {
        Write-Output "Error: '$inputId' is not a valid GUID or Entra ID SID format."
    }
} catch {
    Write-Output "Error: $($_.Exception.Message)"
}