From: Arne Wiebalck <Arne.Wiebalck@cern.ch>
Subject: Re: [PATCH] bcache: amend writeback_rate documentation
Date: Wed, 25 Jun 2014 18:17:41 +0000
Message-ID: <141F1109-7E18-45FE-B8DE-F93F9EA0C304@cern.ch>
References: <1403086412-18310-1-git-send-email-Arne.Wiebalck@cern.ch>
 <CACHGV4+31Se0k6y6VDnN19H+LGDBa-BVAd79zW=+o=3NXPoabw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="Apple-Mail=_D5628D22-5092-431F-B483-D4B374515A59";
	protocol="application/pkcs7-signature"; micalg=sha1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cernmx11.cern.ch ([188.184.36.50]:55498 "EHLO CERNMX11.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaFYSRo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 25 Jun 2014 14:17:44 -0400
In-Reply-To: <CACHGV4+31Se0k6y6VDnN19H+LGDBa-BVAd79zW=+o=3NXPoabw@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Slava Pestov <sp@datera.io>
Cc: "<linux-bcache@vger.kernel.org>" <linux-bcache@vger.kernel.org>

--Apple-Mail=_D5628D22-5092-431F-B483-D4B374515A59
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi Slava,

I think using the same units for read and write would be an improvement, =
and I'd prefer bytes over sectors.

Thanks!
 Arne

--
Arne Wiebalck
CERN IT

On Jun 25, 2014, at 7:38 PM, Slava Pestov <sp@datera.io> wrote:

> Hi Arne,
>=20
> I looked at the latest code and the problem does not happen in our
> development branch. For release kernels, a better fix might be to
> actually change sysfs.c to read and write writeback_rate in units of
> bytes. This way it is simpler to document. What do you think?
>=20
> On Wed, Jun 18, 2014 at 3:13 AM, Arne Wiebalck <Arne.Wiebalck@cern.ch> =
wrote:
>> From: Arne Wiebalck <Arne.Wiebalck@cern.ch>
>>=20
>> The writeback_rate is displayed in bytes per sec, but needs to
>> be set in sectors per sec. This patch amends the documentation
>> accordingly.
>> ---
>> Documentation/bcache.txt | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/Documentation/bcache.txt b/Documentation/bcache.txt
>> index 32b6c31..5643751 100644
>> --- a/Documentation/bcache.txt
>> +++ b/Documentation/bcache.txt
>> @@ -268,9 +268,9 @@ writeback_percent
>>   the rate.
>>=20
>> writeback_rate
>> -  Rate in sectors per second - if writeback_percent is nonzero, =
background
>> +  Rate in bytes per second - if writeback_percent is nonzero, =
background
>>   writeback is throttled to this rate. Continuously adjusted by =
bcache but may
>> -  also be set by the user.
>> +  also be set by the user (in sectors per second).
>>=20
>> writeback_running
>>   If off, writeback of dirty data will not take place at all. Dirty =
data will
>> --
>> 1.8.3.2.634.g7a3187e
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe =
linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Apple-Mail=_D5628D22-5092-431F-B483-D4B374515A59
Content-Disposition: attachment; filename="smime.p7s"
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIINuDCCBi4w
ggUWoAMCAQICCmEPqkwAAAAAAAMwDQYJKoZIhvcNAQEFBQAwQTESMBAGCgmSJomT8ixkARkWAmNo
MRQwEgYKCZImiZPyLGQBGRYEY2VybjEVMBMGA1UEAxMMQ0VSTiBSb290IENBMB4XDTA2MTAwMzA5
MzYxM1oXDTE2MTAwMzA5NDYxM1owWTESMBAGCgmSJomT8ixkARkWAmNoMRQwEgYKCZImiZPyLGQB
GRYEY2VybjEtMCsGA1UEAxMkQ0VSTiBUcnVzdGVkIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwdFGqthhWlgUOSZ6C6hReNEVGzbjf2IQgxo7
/rOfOQHZH3krQPQ37fqFroEr46PrruymZ/U+QAzmESZQ4Z+nCfBhm7cEi0TIhihHd4cEPaPxawGR
T9Ck7BBk9za8TUljF6c/JodnIcmIrpbazEbSAS1KEXwETHDsTrQ7lJ+6SzDP4/oOwrHrgJx+tKsm
gOsFSbBEK4OYx1UYQpYS9OJQk2Sc0q4a/SCSu+xbN8ppmgV3WFytN8NW20n3NpCCWYPzo9rXmPRA
7a/c6mf+RV5gPCnUqeW6KUvix5kz9+X8/4SQV/fU12OPdRvtkqcC+PpiePK7bjMLQJEYwvchJrSz
AwIDAQABo4IDDjCCAwowDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUmMyS0EYwNoyw7ZgNclGp
R0zdviEwCwYDVR0PBAQDAgGGMBAGCSsGAQQBgjcVAQQDAgECMCMGCSsGAQQBgjcVAgQWBBT/Rljl
vgfrVK8GmAaYe+TbiXbJ7DBRBgNVHSAESjBIMEYGCisGAQQBYAoCAQEwODA2BggrBgEFBQcCARYq
aHR0cDovL2NhLmNlcm4uY2gvY2EvY3JsL3BvbGljeS9jcC1jcHMucGRmMBkGCSsGAQQBgjcUAgQM
HgoAUwB1AGIAQwBBMB8GA1UdIwQYMBaAFJgK9+w+7FnWHa2ZvLUBPt7spudQMIH8BgNVHR8EgfQw
gfEwge6ggeuggeiGLWh0dHA6Ly9jYS5jZXJuLmNoL2NhL2NybC9DRVJOJTIwUm9vdCUyMENBLmNy
bIaBtmxkYXA6Ly8vQ049Q0VSTiUyMFJvb3QlMjBDQSxDTj1jZXJucm9vdGNhLENOPUNEUCxDTj1Q
dWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWNl
cm4sREM9Y2g/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERp
c3RyaWJ1dGlvblBvaW50MIIBBAYIKwYBBQUHAQEEgfcwgfQwRAYIKwYBBQUHMAKGOGh0dHA6Ly9j
YS5jZXJuLmNoL2NhL2NybC9jZXJucm9vdGNhX0NFUk4lMjBSb290JTIwQ0EuY3J0MIGrBggrBgEF
BQcwAoaBnmxkYXA6Ly8vQ049Q0VSTiUyMFJvb3QlMjBDQSxDTj1BSUEsQ049UHVibGljJTIwS2V5
JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1jZXJuLERDPWNoP2NB
Q2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MA0GCSqG
SIb3DQEBBQUAA4IBAQAfEzvOeYohKndmJqnVdiCqZ38tSBxOOPsKUHW4UY1jBfYMXbnZ9keFQFlK
/g5X4aZPNBEHXw0eKpQVsMhEPWQrvx8T/f7GwtU+JNQhkgK9tnezmHxYzWgEC9MXZhfYzFSwMIF6
kSKllmUTnN35uF1EnT8+64daje+yEVcpmM34p8Fw125/WpKnRmwNp0YkUk6uMti6Y6vOTHttzIN5
P6elGoat8sadMqrVnaMNzG8hGUvSkYivYBs7msAPuwmXgLvIkXWPW+MDFs+x5Kzx75ZHv3c2WoKg
UxL5KZH9QqiR7t8P6YBfYW6SpzyGRi4QHN/iOLhXZ06R6aPljLEOn41JMIIHgjCCBmqgAwIBAgIK
G2rSugACAAJRYzANBgkqhkiG9w0BAQUFADBZMRIwEAYKCZImiZPyLGQBGRYCY2gxFDASBgoJkiaJ
k/IsZAEZFgRjZXJuMS0wKwYDVQQDEyRDRVJOIFRydXN0ZWQgQ2VydGlmaWNhdGlvbiBBdXRob3Jp
dHkwHhcNMTMxMDI3MTAyNjQyWhcNMTQxMDI3MTAyNjQyWjCBjjESMBAGCgmSJomT8ixkARkWAmNo
MRQwEgYKCZImiZPyLGQBGRYEY2VybjEWMBQGA1UECxMNT3JnYW5pYyBVbml0czEOMAwGA1UECxMF
VXNlcnMxETAPBgNVBAMTCHdpZWJhbGNrMQ8wDQYDVQQDEwY1NTg1MTAxFjAUBgNVBAMTDUFybmUg
V2llYmFsY2swggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCxYDn8A4EeRTjaXpd8IrE3
Z3r/Fch6OlueWx7+XOBmxjvwCOMYlLt7WQeowLORXz7aaVyofoZHqmZirNnOQgTpzs/6UQT6DrXr
bKFZUsoJ/07hsk4QQyxo2WxCMUpgAMMmx13L2erSb2sNwtYhS51Mz1hFFmjE3wiAqftJOEww9vHB
rjeR8tlH0ifD7oFgGIhfAsx9q79aW8YOAHIBUnyrK1W0pP9qp3+ZwuH6sUXyDvN9BjIiEIxeDcb+
9MtAiENXxWwNfpWGmOousEyRNwyjXCpaerDvYsgbeGo+WyckGWleGxVH6B7glokA71OuEzUxUTHz
pazGDDLxwaP36+bFAgMBAAGjggQUMIIEEDAdBgNVHQ4EFgQUMiRKoPIkk3aChfZ+QXzfNmTYkUYw
HwYDVR0jBBgwFoAUmMyS0EYwNoyw7ZgNclGpR0zdviEwggEyBgNVHR8EggEpMIIBJTCCASGgggEd
oIIBGYZHaHR0cDovL2NhLmNlcm4uY2gvY2EvY3JsL0NFUk4lMjBUcnVzdGVkJTIwQ2VydGlmaWNh
dGlvbiUyMEF1dGhvcml0eS5jcmyGgc1sZGFwOi8vL0NOPUNFUk4lMjBUcnVzdGVkJTIwQ2VydGlm
aWNhdGlvbiUyMEF1dGhvcml0eSxDTj1DRVJOUEtJLENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBT
ZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWNlcm4sREM9Y2g/Y2VydGlm
aWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50
MIIBLwYIKwYBBQUHAQEEggEhMIIBHTCBxQYIKwYBBQUHMAKGgbhsZGFwOi8vL0NOPUNFUk4lMjBU
cnVzdGVkJTIwQ2VydGlmaWNhdGlvbiUyMEF1dGhvcml0eSxDTj1BSUEsQ049UHVibGljJTIwS2V5
JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1jZXJuLERDPWNoP2NB
Q2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MFMGCCsG
AQUFBzAChkdodHRwOi8vY2EuY2Vybi5jaC9jYS9jcmwvQ0VSTiUyMFRydXN0ZWQlMjBDZXJ0aWZp
Y2F0aW9uJTIwQXV0aG9yaXR5LmNydDAOBgNVHQ8BAf8EBAMCBaAwPQYJKwYBBAGCNxUHBDAwLgYm
KwYBBAGCNxUIg73QCYLtjQ2G7Ysrgd71N4WA0GIehb+6A4TEzEwCAWQCAQowKQYDVR0lBCIwIAYI
KwYBBQUHAwIGCCsGAQUFBwMEBgorBgEEAYI3CgMEMCUGA1UdIAQeMBwwDAYKKwYBBAFgCgIBAjAM
BgoqhkiG90wFAgIBMDUGCSsGAQQBgjcVCgQoMCYwCgYIKwYBBQUHAwIwCgYIKwYBBQUHAwQwDAYK
KwYBBAGCNwoDBDBHBgNVHREEQDA+oCUGCisGAQQBgjcUAgOgFwwVYXJuZS53aWViYWxja0BjZXJu
LmNogRVBcm5lLldpZWJhbGNrQGNlcm4uY2gwRAYJKoZIhvcNAQkPBDcwNTAOBggqhkiG9w0DAgIC
AIAwDgYIKoZIhvcNAwQCAgCAMAcGBSsOAwIHMAoGCCqGSIb3DQMHMA0GCSqGSIb3DQEBBQUAA4IB
AQAp+9JprmqNFehFL9K03clXIOFOu6b74SXweYvfX6BEFYxGSxOuAR7Y3o4R/RXtqIBBHPVesYQv
O1n3QmByEN12zZMspsvyzVVZnXa0lxr8HGg9ALDLZAv5FGaDuivXe7K9ZNwBdDcXg5LygZNyoFHX
z4dyyAQr2N9k/3ll1nkJ+C4J38GZpUOiRmzfvS4I30//HFBMK6eKBh3urD+lJMKGDqhdrMLoMVCw
UFkT0Pj+swGhdR/dz/ANaXU433wws3nKGnWp4kea84QJtZCHYp+C87XYKYoZzs0BTxWEY29vhiw5
xCU2quiUWWNJZ7uWBjeqTOzyj0CfHtCrddsJjnOmMYIC4TCCAt0CAQEwZzBZMRIwEAYKCZImiZPy
LGQBGRYCY2gxFDASBgoJkiaJk/IsZAEZFgRjZXJuMS0wKwYDVQQDEyRDRVJOIFRydXN0ZWQgQ2Vy
dGlmaWNhdGlvbiBBdXRob3JpdHkCChtq0roAAgACUWMwCQYFKw4DAhoFAKCCAU8wGAYJKoZIhvcN
AQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwNjI1MTgxNzQ2WjAjBgkqhkiG9w0B
CQQxFgQUE+F7CaxRkYc1wI0ZLvTdG+BmirAwdgYJKwYBBAGCNxAEMWkwZzBZMRIwEAYKCZImiZPy
LGQBGRYCY2gxFDASBgoJkiaJk/IsZAEZFgRjZXJuMS0wKwYDVQQDEyRDRVJOIFRydXN0ZWQgQ2Vy
dGlmaWNhdGlvbiBBdXRob3JpdHkCChtq0roAAgACUWMweAYLKoZIhvcNAQkQAgsxaaBnMFkxEjAQ
BgoJkiaJk/IsZAEZFgJjaDEUMBIGCgmSJomT8ixkARkWBGNlcm4xLTArBgNVBAMTJENFUk4gVHJ1
c3RlZCBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eQIKG2rSugACAAJRYzANBgkqhkiG9w0BAQEFAASC
AQCdUIaf37wsVBx1murIoKN/OKLNWcehl/LS3exJtRZIGAPh66tcu/D6l3lXJ+DWfqQRf/UBKxO1
6Odc6CbCB70tYvnqheOvvXcQzieCUfcV4zBQw5d5wQ6DuYOdRLwoYo2pwD/oe05Th2iTgUNfHCRx
I725CI4+BiTyhFd+uDUxQcLEElW2YiM3dfF7r8C+z3DqqMCh+SFeOwcIiuM7ZVa3c02EN7S9GI24
WXbrnAFzlKyXXSNy4ybVqxp2UmbrkGXfA/b2Q7Csj0CVs1IwZVhlZ2vwKFdHt5wucn2pmO4GrWtg
C97ooLo/2dzGRnYWSVf1uQIbnpKaYQ9HuG5i70DJAAAAAAAA

--Apple-Mail=_D5628D22-5092-431F-B483-D4B374515A59--
