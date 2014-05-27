From: Peter Kieser <peter@kieser.ca>
Subject: Re: bad bcache performance - crappy SSD?
Date: Tue, 27 May 2014 13:13:30 -0700
Message-ID: <5384F1EA.2070402@kieser.ca>
References: <20140526221649.GI10209@teapot>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050907040901030807070402"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.pfak.org ([198.50.219.4]:53556 "EHLO mail.pfak.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbaE0UMz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 27 May 2014 16:12:55 -0400
In-Reply-To: <20140526221649.GI10209@teapot>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Matthias Ferdinand <bcache@mfedv.net>, linux-bcache@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050907040901030807070402
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

What filesystem are you running on top of bcache? There are issues with=20
XFS and barrier modes causing 100% util on the cache device.

-Peter

On 2014-05-26 3:16 PM, Matthias Ferdinand wrote:
> Hi,
>
> so far I have been unable to get an actual performance improvement out
> of bcache, and I suspect that my SSD is just crap. Any help or hint
> appreciated. What (SATA) SSDs have you been using successfully with
> bcache?
>
>
> My host system: Ubuntu 14.04 x64.
> kernels tried: Ubuntu stock (3.13.0-24), 3.14, 3.15-rc{5,6}.
>
> storage structure:
> 3xSATA (sda,sdb,sdc) =3D> md raid5 (md125) =3D> bcache0 =3D> LVM (dm-1)=

>
> benchmark: install linux kernel header package inside kvm guest
>
>          cache device not attached:            0:18 minutes
>      SSD cache device attached (writethrough): 3:27 minutes
>      SSD cache device attached (writeback):    3:25 minutes
>
> With attached cache device, the ssd seems very busy (iostat %util),
> while the raid members are not:
>
>      Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s =
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> (5) sdc               0.00    12.33    0.00   57.33     0.00    57.00  =
   1.99     0.06    1.07    0.00    1.07   0.79   4.53
> (5) sdb               0.33    12.00    0.33   57.00     2.67    54.33  =
   1.99     0.07    1.19    0.00    1.19   0.84   4.80
> (5) sda               0.00    11.33    0.00   57.00     0.00    51.67  =
   1.81     0.06    1.10    0.00    1.10   0.80   4.53
> (*) sdf               0.00     0.00    0.00   54.67     0.00    27.17  =
   0.99     0.98   18.05    0.00   18.05  17.95  98.13
>
>      (5) raid 5 member;  (*) SSD
>
>
> when I replace the SSD with a single SATA disk:
>      SATA cache device attached (writethrough): 0:19 minutes
>      SATA cache device attached (writeback):    0:13 minutes
>
>
> The SSD is an Intel 530, has current firmware and plenty of DISCARDed
> blocks.  Specs claim >=3D 13.000 incompressible writes/sec for the 120G=
B
> model, but the above data suggests it can handle just about 60.
>
>
>      =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
>      Device Model:     INTEL SSDSC2BW120A4
>      Serial Number:    CVDA3393028N1207GN
>      LU WWN Device Id: 5 5cd2e4 04b82aa5a
>      Firmware Version: DC32
>      User Capacity:    120,034,123,776 bytes [120 GB]
>      Sector Size:      512 bytes logical/physical
>      Rotation Rate:    Solid State Device
>      Device is:        Not in smartctl database [for details use: -P sh=
owall]
>      ATA Version is:   ACS-2 (minor revision not indicated)
>      SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
>      Local Time is:    Sat May 24 20:37:14 2014 CEST
>      SMART support is: Available - device has SMART capability.
>      SMART support is: Enabled
>
>
>
> Regards
> Matthias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--------------ms050907040901030807070402
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIINgDCC
BjQwggQcoAMCAQICASAwDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3
MTAyNDIxMDI1NVoXDTE3MTAyNDIxMDI1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMsohUWcASz7GfKrpTOM
KqANy9BV7V0igWdGxA8IU77L3aTxErQ+fcxtDYZ36Z6GH0YFn7fq5RADteP0AYzrCA+EQTfi
8q1+kA3m0nwtwXG94M5sIqsvs7lRP1aycBke/s5g9hJHryZ2acScnzczjBCAo7X1v5G3yw8M
DP2m2RCye0KfgZ4nODerZJVzhAlOD9YejvAXZqHksw56HzElVIoYSZ3q4+RJuPXXfIoyby+Y
2m1E+YzX5iCZXBx05gk6MKAW1vaw4/v2OOLy6FZH3XHHtOkzUreG//CsFnB9+uaYSlR65cdG
zTsmoIK8WH1ygoXhRBm98SD7Hf/r3FELNvUCAwEAAaOCAa0wggGpMA8GA1UdEwEB/wQFMAMB
Af8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBSuVYNv7DHKufcd+q9rMfPIHeOsuzAfBgNV
HSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRaMFgwJwYIKwYBBQUH
MAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYhaHR0cDovL3d3
dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20v
c2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBADqp
Jw3I07QWke9plNBpxUxcffc7nUrIQpJHDci91DFG7fVhHRkMZ1J+BKg5UNUxIFJ2Z9B90Mic
c/NXcs7kPBRdn6XGO/vPc87Y6R+cWS9Nc9+fp3Enmsm94OxOwI9wn8qnr/6o3mD4noP9Jphw
UPTXwHovjavRnhUQHLfo/i2NG0XXgTHXS2Xm0kVUozXqpYpAdumMiB/vezj1QHQJDmUdPYMc
p+reg9901zkyT3fDW/ivJVv6pWtkh6Pw2ytZT7mvg7YhX3V50Nv860cV11mocUVcqBLv0gcT
+HBDYtbuvexNftwNQKD5193A7zN4vG7CTYkXxytSjKuXrpEatEiFPxWgb84nVj25SU5q/r1X
hwby6mLhkbaXslkVtwEWT3Van49rKjlK4XrUKYYWtnfzq6aSak5u0Vpxd1rY79tWhD3EdCvO
hNz/QplNa+VkIsrcp7+8ZhP1l1b2U6MaxIVteuVMD3X0vziIwr7jxYae9FZjbxlpUemqXjcC
0QaFfN7qI0JsQMALL7iGRBg7K0CoOBzECdD3fuZil5kU/LP9cr1BK31U0Uy651bFnAMMMkqh
AChIbn0ei72VnbpSsrrSdF0BAGYQ8vyHae5aCg+H75dVCV33K6FuxZrf09yTz+Vx/PkdRUYk
XmZz/OTfyJXsUOUXrym6KvI2rYpccSk5MIIHRDCCBiygAwIBAgICJYcwDQYJKoZIhvcNAQEF
BQAwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJT
ZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBD
bGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTAeFw0xMjA4MjkyMzM0MjZa
Fw0xNDA4MzExMzE0MzFaMIGOMRkwFwYDVQQNExBpd3JteTFzNGhOaHZLMDQ0MQswCQYDVQQG
EwJDQTEZMBcGA1UECBMQQnJpdGlzaCBDb2x1bWJpYTESMBAGA1UEBxMJVmFuY291dmVyMRUw
EwYDVQQDEwxQZXRlciBLaWVzZXIxHjAcBgkqhkiG9w0BCQEWD3BldGVyQGtpZXNlci5jYTCC
ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOdZjqh64jWRFwTsYZZ0bKt5xOIxLlV4
jrN0wY5KMu5RotLfYnu53fCMGJVk1n8h4QFRDxGuQmE4ugw47rv7FMDWYPb7PisPAWbcbUlG
pmxhZB/avqpC8P2uuvJ0dsKsyNo8HeROfvrLkT6PSpYE35UXTLESoHSYkkyhcklVRf6ygChd
PKUMNhEAMH3ZGtsw8N24hSoiW6Sb3vqv4ZCZcLvlKRVjJtOyc2vbSw8ndc62EbFMFeP+AZOw
r7flFGQanYjfeXeeXV/29hstVPv88okwEpJCWdmSA1/gh5Yc6bjpQ7YuSxOVKP5UAl+Ehyld
XWIcWEcUoeuZ1XeSyRuwRmcCAwEAAaOCA6owggOmMAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSw
MB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQUKlB/4e9ZfesCCiNm
UHJOZibv8FAwHwYDVR0jBBgwFoAUrlWDb+wxyrn3HfqvazHzyB3jrLswGgYDVR0RBBMwEYEP
cGV0ZXJAa2llc2VyLmNhMIICIQYDVR0gBIICGDCCAhQwggIQBgsrBgEEAYG1NwECAjCCAf8w
LgYIKwYBBQUHAgEWImh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYB
BQUHAgEWKGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwgfcGCCsG
AQUFBwICMIHqMCcWIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MAMCAQEagb5U
aGlzIGNlcnRpZmljYXRlIHdhcyBpc3N1ZWQgYWNjb3JkaW5nIHRvIHRoZSBDbGFzcyAyIFZh
bGlkYXRpb24gcmVxdWlyZW1lbnRzIG9mIHRoZSBTdGFydENvbSBDQSBwb2xpY3ksIHJlbGlh
bmNlIG9ubHkgZm9yIHRoZSBpbnRlbmRlZCBwdXJwb3NlIGluIGNvbXBsaWFuY2Ugb2YgdGhl
IHJlbHlpbmcgcGFydHkgb2JsaWdhdGlvbnMuMIGcBggrBgEFBQcCAjCBjzAnFiBTdGFydENv
bSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTADAgECGmRMaWFiaWxpdHkgYW5kIHdhcnJhbnRp
ZXMgYXJlIGxpbWl0ZWQhIFNlZSBzZWN0aW9uICJMZWdhbCBhbmQgTGltaXRhdGlvbnMiIG9m
IHRoZSBTdGFydENvbSBDQSBwb2xpY3kuMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwu
c3RhcnRzc2wuY29tL2NydHUyLWNybC5jcmwwgY4GCCsGAQUFBwEBBIGBMH8wOQYIKwYBBQUH
MAGGLWh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9zdWIvY2xhc3MyL2NsaWVudC9jYTBCBggr
BgEFBQcwAoY2aHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc3ViLmNsYXNzMi5jbGll
bnQuY2EuY3J0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tLzANBgkqhkiG
9w0BAQUFAAOCAQEAvd8Wn0ZXlB3mV+fWae/hAFquDNjyWMJ29rJymKaGOOYTCiPdmDRJNV9R
k0YTP9+B06A0Vx6bbg+rZwIdv2k+GBSjCSb4T8IsawVphbbWMohFzxGzo36NaYZ/wCTcrlVv
oXmPFkEaOJzqQ1DAYetJTfDMIfkBeOZSJ9KmdLos1Z9fOc0nGq9ioy/6gIPGchsWuhrl3vxW
ej1MUPjVKn5wW967cPcLFnNLR1gxYB3fjptyHbJpRq/54rH2BMR0kicK9EyVUoDM35R6Ux6n
djaJmH1ZFcHVc+FmalNisvlIlGSWwnkyvpmyD25LSJ+BlfZEUHE8tcicdZPAqQ8f+Yo/dTGC
A9owggPWAgEBMIGTMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEr
MCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMv
U3RhcnRDb20gQ2xhc3MgMiBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAiWHMAkG
BSsOAwIaBQCgggIbMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8X
DTE0MDUyNzIwMTMzMFowIwYJKoZIhvcNAQkEMRYEFC+B5lAgqqunJb7ft8M4L0iPWFerMGwG
CSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAO
BggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgw
gaQGCSsGAQQBgjcQBDGBljCBkzCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29t
IEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2
BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDIgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENB
AgIlhzCBpgYLKoZIhvcNAQkQAgsxgZaggZMwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQQICJYcwDQYJKoZIhvcNAQEBBQAEggEAW5milJ5BkvnIifDi19yqprHSQoWpW95B
CiKFsL0NpZqoZsJAGqT8Mwvb62RUwCXWrsHSfLIH1FY1MQpm0wizq1+Y12JoOmiYsps1J9S+
LTcgnWlBrjNz/LLNVz6V5ZAHkBXDngY6AJ+R5y7mEZphVwOI/8eI1VKhPKsGENsVPjiuBFC2
X+nJ6MGA8NYawRNAiZ99Y4Y35LIgSaJmBqFJTW3iPfyyxJ7k1N8VKTAEW0NQjWWy8TW0u7Np
1v6d0KkA6ItT83HUFpLvSY4FYuQQRdH5vMB8WgCTmn9CXydN8U/Hc/08KAxItFUW+U4uqykj
DB/NuqFpfDjqtBHozwzCagAAAAAAAA==
--------------ms050907040901030807070402--
