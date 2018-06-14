$StorageAccountName = "" 
$StorageAccountKey = "" 
$ContainerName = ""

$Context = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
$Blobs = Get-AzureStorageBlob -Context $Context -Container $ContainerName

foreach ($Blob in $Blobs) 
{  
    $Extn = [IO.Path]::GetExtension($Blob.Name)
    $ContentType = ""
    
    # For some reason it sets .js to "application/x-javascript". If there are any other wierd types of content
    # types missing altogether, add them below
    switch ($Extn) {
        ".json" { $ContentType = "application/json" }
        ".js" { $ContentType = "application/javascript" }
        ".svg" { $ContentType = "image/svg+xml" }
        Default { $ContentType = "" }
    }

    if ($ContentType -ne "") {
        $CloudBlockBlob = [Microsoft.WindowsAzure.Storage.Blob.CloudBlockBlob] $Blob.ICloudBlob
        
        $CloudBlockBlob.Properties.ContentType = $ContentType 
        $CloudBlockBlob.SetProperties()    
    }
}