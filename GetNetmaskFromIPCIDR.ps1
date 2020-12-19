$FILE = "C:\Users\adam\Desktop\IPS.txt"

$IPFILE = Import-Csv -Path $FILE -header IP

foreach ($IP in $IPFILE) {
    $IPName = $IP.IP

    $IPNetMask = $IPName -split '\d*.\d*.\d*.\d*(/\d{1,3})'

    Write-Output $IPNetMask | out-file C:\Users\adam\Desktop\NewIP.txt -Append -Force -NoClobber
    }