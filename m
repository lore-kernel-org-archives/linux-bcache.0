From: Patrick Zwahlen <paz@navixia.com>
Subject: RE: How important is bcache cache device in write-thru mode? (was
 Re: Tiered bcache)
Date: Tue, 28 Jan 2014 22:21:39 +0000
Message-ID: <8b2600931cad463fb934a5c25deeef93@navex1.navixia.local>
References: Patrick Zwahlen <paz@navixia.com>       "RE: How important is
 bcache cache device in write-thru mode? (was Re: Tiered bcache)" (Jan 21,
  6:44pm) <201401281420.s0SEK0sb008045@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_0069_01CF1C7F.B12DD930"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from 62-2-213-50.static.cablecom.ch ([62.2.213.50]:16112 "EHLO
	navfw1a.navixia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbaA1WV6 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 28 Jan 2014 17:21:58 -0500
Received: from navex1.navixia.local (navex1.navixia.local [172.29.96.60])
	by navfw1a.navixia.com (8.14.5/8.14.5) with ESMTP id s0SMLrPR008781
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=FAIL)
	for <linux-bcache@vger.kernel.org>; Tue, 28 Jan 2014 23:21:54 +0100
In-Reply-To: <201401281420.s0SEK0sb008045@wind.enjellic.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

------=_NextPart_000_0069_01CF1C7F.B12DD930
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

> -----Original Message-----
> From: Dr. Greg Wettstein [mailto:greg@wind.enjellic.com]
> Sent: mardi 28 janvier 2014 15:20
> To: Patrick Zwahlen; linux-bcache@vger.kernel.org
> Cc: scst-devel@lists.sourceforge.net
> Subject: RE: How important is bcache cache device in write-thru mode?
> (was Re: Tiered bcache)
> 
> Interestingly enough we have been working on infrastructure to support
> this type of model for some time.  Our primary focus is on
> accelerating SCST based storage targets and software defined storage
> (SDS) devices.
> 
> At one point in time we had entertained discussions with the SCST
> developers to pay for an implementation of RAM based block device
> cacheing in SCST itself, for a variety of reasons that didn't move
> forward.  We recognized early on that Kent's work with bcache was
> going to make that strategy irrelevant.
> 
> SCST using FILEIO is blindingly fast but I don't know of any serious
> storage architects that are going to trust 50-60 gigabytes of a
> database or filesystem to the Linux pagecache and associated vagaries
> of VM writeback behavior.  So the architectural question becomes how
> to take advantage of the fact that it is now tractable to provision
> commodity based storage targets with a quarter terrabyte of RAM and
> how to take advantage of this in a manner which protects data and
> provides deterministic performance characteristics.
> 
> So Izzy (our golden retriever) and I spent a lot of time down at our
> lake place over the holidays cross-country skiing and working on a
> hugepage backed block device driver.  We are in the process of putting
> the beta through various beatings and addressing some issues with the
> device model implementation.  We are hoping to have something to
> release in the next week or so before we leave for Colorado and some
> downhill skiing.
> 
> The goal for this driver is a block based interface to RAM for use as
> a cache set for bcache.  Since it sits directly on the physical
> hugepage allocator and associated page magazine the block devices can
> be dynamically configured, unlike the current RAM based block device,
> which also has the disadvantage of being implemented on top of page
> cache.  None of this should be construed as a gripe against the Linux
> VM but obviously one does not want memory pressure to start driving a
> high speed cache store out onto disk.

Our initial idea with btier and bcache was to use both SSD and DRAM. I
understand that you focus on DRAM only.

However, I also understand that at some point we might be able to mix
several cachesets so we can dream of a kind of tiered cache implemented
entirely within bcache.

> 
> This model is obviously dependent on solid behavior of bcache in
> write-through mode.  We are testing aggressively against 3.10.x and
> haven't tipped it over it but we will turn up the pressure on that and
> see if it gives.  I'm pretty confident there is enough community and
> commercial interest in all this to get the bugs beaten out pretty
> thoroughly, provided people report them back.... :-)
> 
> We will copy both the bcache and SCST lists when we have something up
> on the FTP site as it would seem to be of interest to both
> communities.

Regards, - Patrick -

------=_NextPart_000_0069_01CF1C7F.B12DD930
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

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
xCZU7wO94CTLVBowHQYDVR0OBBYEFImCZ33EnSZwAEu0UEh83j2uBG59MA4GA1UdDwEB/wQEAwIB
BjAPBgNVHRMBAf8EBTADAQH/MBEGA1UdIAQKMAgwBgYEVR0gADBEBgNVHR8EPTA7MDmgN6A1hjNo
dHRwOi8vY3JsLnVzZXJ0cnVzdC5jb20vQWRkVHJ1c3RFeHRlcm5hbENBUm9vdC5jcmwwNQYIKwYB
BQUHAQEEKTAnMCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0GCSqGSIb3
DQEBBQUAA4IBAQABvJzjYyiw8zEBwt973WKgAZ0jMQ+cknNTUeofTPrWn8TKL2d+eDMPdBa5kYeR
9Yom+mRwANge+QsEYlCHk4HU2vUj2zS7hVa0cDRueIM3HoUcxREVkl+HF72sav3xwtHMiV+xfPA+
UfI183zsYJhrOivg79+zfYbrtRv1W+yifJgT1wBQudEtc94DeHThBYUxXsuauZ2UxrmUN3Vy3ET7
Z+jw+iUeUqfaJelH4KDHPKBOsQo2+3dIn++Xivu0/uOUFKiDvFwtP9JgcWDuwnGCDOmINuPaILSj
oGyqlku4gI51ykkH9jsUut/cBdmf2+Cy5k2geCbn5y1uf1/GHogVMIIFGjCCBAKgAwIBAgIQbRnq
pxlPajMi5iIyeqpx3jANBgkqhkiG9w0BAQUFADCBrjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVU
MRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3Jr
MSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VSRmly
c3QtQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBFbWFpbDAeFw0xMTA0MjgwMDAwMDBaFw0yMDA1
MzAxMDQ4MzhaMIGTMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAw
DgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE5MDcGA1UEAxMwQ09N
T0RPIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkoSEW0tXmNReL4uk4UDIo1NYX2Zl8TJO958yfVXQeExVt0KU
4PkncQfFxmmkuTLE8UAakMwnVmJ/F7Vxaa7lIBvky2NeYMqiQfZq4aP/uN8fSG1lQ4wqLitjOHff
sReswtqCAtbUMmrUZ28gE49cNfrlVICv2HEKHTcKAlBTbJUdqRAUtJmVWRIx/wmi0kzcUtve4kAB
W0ho3cVKtODtJB86r3FfB+OsvxQ7sCVxaD30D9YXWEYVgTxoi4uDD216IVfmNLDbMn7jSuGlUnJk
JpFOpZIP/+CxYP0ab2hRmWONGoulzEKbm30iY9OpoPzOnpDfRBn0XFs1uhbzp5v/wQIDAQABo4IB
SzCCAUcwHwYDVR0jBBgwFoAUiYJnfcSdJnAAS7RQSHzePa4Ebn0wHQYDVR0OBBYEFHoTTgB0W8Z4
Y2QnwS/ioFu8ecV7MA4GA1UdDwEB/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQK
MAgwBgYEVR0gADBYBgNVHR8EUTBPME2gS6BJhkdodHRwOi8vY3JsLnVzZXJ0cnVzdC5jb20vVVRO
LVVTRVJGaXJzdC1DbGllbnRBdXRoZW50aWNhdGlvbmFuZEVtYWlsLmNybDB0BggrBgEFBQcBAQRo
MGYwPQYIKwYBBQUHMAKGMWh0dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9VVE5BZGRUcnVzdENsaWVu
dF9DQS5jcnQwJQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5jb20wDQYJKoZIhvcN
AQEFBQADggEBAIXWvnhXVW0zf0RS/kLVBqgBA4CK+w2y/Uq/9q9BSfUbWsXSrRtzbj7pJnzmTJjB
MCjfy/tCPKElPgp11tA9OYZm0aGbtU2bb68obB2v5ep0WqjascDxdXovnrqTecr+4pEeVnSy+I3T
4ENyG+2P/WA5IEf7i686ZUg8mD2lJb+972DgSeUWyOs/Q4Pw4O4NwdPNM1+b0L1garM7/vrUyTo8
H+2b/5tJM75CKTmD7jNpLoKdRU2oadqAGx490hpdfEeZpZsIbRKZhtZdVwcbpzC+S0lEuJB+ytF5
OOu0M/qgOl0mWJ5hVRi0IdWZ1eBDQEIwvuql55TSsP7zdfl/bucwggUfMIIEB6ADAgECAhAX3R0Y
7UBKukviAqwn1AAnMA0GCSqGSIb3DQEBBQUAMIGTMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGlt
aXRlZDE5MDcGA1UEAxMwQ09NT0RPIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVt
YWlsIENBMB4XDTEzMDcwMzAwMDAwMFoXDTE0MDcwMzIzNTk1OVowIDEeMBwGCSqGSIb3DQEJARYP
cGF6QG5hdml4aWEuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0F0TmZlMK9tI
OxjMw+RotD8HyeA/WMCh4WgkRErJKDA1clpy0rTE+e54cRsd1yYMRpzxFlPHBSu6wdwD3r1g/lNP
ArFhvr1azGCO0Jcq14fyNfv7SA+gyg2Fu1Oym1xZBFYECimMMrp7nRSTqRehQ8q4byidSqmFLTZa
6TwMOdKTqdIxewO/CH2bxIcrawASjQCHLmT6lOe+Ebec0bvg+W+t9nkGWQbXlXUMYcx5QAgAYy5T
utLVen4svpbNW2TzM2U+r8JvIBrZmPOIJ9c3OBAKrDyemESY/RPtFuU2qrG0M86T0yQYtOkNLs2N
FYnvSwOVdBpde8w8CLncCKvK6QIDAQABo4IB3zCCAdswHwYDVR0jBBgwFoAUehNOAHRbxnhjZCfB
L+KgW7x5xXswHQYDVR0OBBYEFIyO7UASW/goTcHarjyu85CPoczeMA4GA1UdDwEB/wQEAwIFoDAM
BgNVHRMBAf8EAjAAMCAGA1UdJQQZMBcGCCsGAQUFBwMEBgsrBgEEAbIxAQMFAjARBglghkgBhvhC
AQEEBAMCBSAwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAQEwKzApBggrBgEFBQcCARYdaHR0cHM6
Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwVwYDVR0fBFAwTjBMoEqgSIZGaHR0cDovL2NybC5jb21v
ZG9jYS5jb20vQ09NT0RPQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNybDCB
iAYIKwYBBQUHAQEEfDB6MFIGCCsGAQUFBzAChkZodHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9DT01P
RE9DbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQGCCsGAQUFBzABhhho
dHRwOi8vb2NzcC5jb21vZG9jYS5jb20wGgYDVR0RBBMwEYEPcGF6QG5hdml4aWEuY29tMA0GCSqG
SIb3DQEBBQUAA4IBAQBtGIlrhLZOI48oRZn08jrt6JDyLeBR5Z28lc/OmOGsHYtFHZFUhcs1xaYT
RqqMlmJQ3CfncYCwgqCsOqWsmtfQmB64vEUMECeZsnkA60dP72QqL0YcvWyh4l79mHX7F//0ftS+
4IogwH+PDmNzJDul/VffyI67OowAJu+NErlucYj6h5vPz3eUlQ0H2Decopv8jKI5QBEsv92ALbKC
fgFzyiLSpDY7GYy9hEy8ZOQ//0oxKuZGXJv3NAUXJd5+ZiOxx48ZqUazRVMgAFHH/jP5MxHSv90R
uk1o3QdvZYfI8etoJ0tdVQRIbJqDXJNy7dvEfIValfObvZWIzT15az7qMYIEQTCCBD0CAQEwgagw
gZMxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1Nh
bGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMTkwNwYDVQQDEzBDT01PRE8gQ2xpZW50
IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEBfdHRjtQEq6S+ICrCfUACcwCQYF
Kw4DAhoFAKCCAm0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQw
MTI4MjIyMTM3WjAjBgkqhkiG9w0BCQQxFgQULnimgCGhDkkl3IhSO03roV4W5ccwgZMGCSqGSIb3
DQEJDzGBhTCBgjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAoGCCqGSIb3DQMHMAsGCWCGSAFl
AwQBAjAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAhowCwYJYIZIAWUDBAID
MAsGCWCGSAFlAwQCAjALBglghkgBZQMEAgEwgbkGCSsGAQQBgjcQBDGBqzCBqDCBkzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxOTA3BgNVBAMTMENPTU9ETyBDbGllbnQgQXV0aGVudGlj
YXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIQF90dGO1ASrpL4gKsJ9QAJzCBuwYLKoZIhvcNAQkQ
AgsxgauggagwgZMxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAO
BgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMTkwNwYDVQQDEzBDT01P
RE8gQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEBfdHRjtQEq6S+IC
rCfUACcwDQYJKoZIhvcNAQEBBQAEggEAPBFJYSChuyahVcBwrm3JsXvKUPz3IVJoqAGMGO23VY97
Kjh5hlgptvTuJpwOV/YW0sXeD+UkwsDL+AlMe1xoXgywElYrFnu+IC4UnBTOPAbft3yoaRHMOOFe
KsGvRHEPjOj060Fx8pqr/J6ZNkzlA8HGMf2aZfmofGW+kX16L8ftAJnwEthoeY0cXzFQXgRq6GSm
m3dxqHiCXeveJZmyuY8J/LmkUMka9eWwYwuS8emk7ODcQ/UsOuZNJOe7WSh+xJiuNB13ctgfj4Vm
jf9+3E0Hn6JeUGwa6UQmZX7iY1TYjKrsKkuEwChj1jRGUD2QF07QegJA9f0k2oXx7wi5QwAAAAAA
AA==

------=_NextPart_000_0069_01CF1C7F.B12DD930--
