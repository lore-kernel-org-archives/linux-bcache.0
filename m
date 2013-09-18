From: Carsten Aulbert <Carsten.Aulbert-l1a6w7hxd2yELgA04lAiVw@public.gmane.org>
Subject: Re: running iozone on bcache0 device yields wrongly read data
Date: Wed, 18 Sep 2013 06:34:21 +0200
Message-ID: <52392D4D.3020506@aei.mpg.de>
References: <5238AAE5.8000800@aei.mpg.de> <20130917204059.GB32037@kmo-pixel>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070807050603000702080006"
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130917204059.GB32037@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms070807050603000702080006
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi

On 09/17/2013 10:40 PM, Kent Overstreet wrote:
> What's your setup? Are you running md, lvm? What filesystem?

Very basic, no md or LVM involved. /dev/sda2 is the backing device and
/dev/sdb is the cache device. On top of bcache0 I'm running xfs:

# parted -s /dev/sda p
Model: ATA Hitachi HDP72505 (scsi)
Disk /dev/sda: 500GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End     Size    Type     File system     Flags
 1      1049kB  10.5GB  10.5GB  primary  xfs             boot
 2      10.5GB  499GB   489GB   primary
 3      499GB   500GB   1049MB  primary  linux-swap(v1)

# parted -s /dev/sdb p
Error: /dev/sdb: unrecognised disk label

# grep bcache /proc/mounts
/dev/bcache0 /srv xfs rw,relatime,attr2,inode64,noquota 0 0

# bcache-super-show /dev/sda2
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 7B66B1004B52FD9A [match]
sb.version              1 [backing device]

dev.uuid                3a131733-7d54-4feb-bf8c-62d6fbdbf935
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.data.first_sector   16
dev.data.cache_mode     1 [writeback]
dev.data.cache_state    1 [clean]

cset.uuid               2a108307-bab9-42dd-b072-10eeb0c13dd8


# bcache-super-show /dev/sdb
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 88965AD15D35A500 [match]
sb.version              3 [cache device]

dev.uuid                ffb6fc80-1dca-42d4-a951-cddee6af689e
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.cache.first_sector  1024
dev.cache.cache_sectors 62498816
dev.cache.total_sectors 62499840
dev.cache.discard       no
dev.cache.pos           0

cset.uuid               2a108307-bab9-42dd-b072-10eeb0c13dd8

Does this help?

cheers

Carsten


--------------ms070807050603000702080006
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIE8DCC
BOwwggPUoAMCAQICAk/QMA0GCSqGSIb3DQEBBQUAMDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQK
EwpHZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0EwHhcNMTMwNTA2MTU1OTM4WhcNMTQw
NjA1MTU1OTM4WjA9MRMwEQYDVQQKEwpHZXJtYW5HcmlkMQwwCgYDVQQLEwNBRUkxGDAWBgNV
BAMTD0NhcnN0ZW4gQXVsYmVydDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJzM
vu6K/4EHUx/JuCoansTOW8cSyuPbvElm7IfuuEfXHJ1/m/Lbkv/C7oA+0Pvk4WCOLBx1OVUk
4vVZ0Lq6G9ekTgeZVaqFvHXKlFdUvdp3b5/nlAGc3z7GaDG/F6LdI5Iu374cTdeSvkuNseRg
KZP6Qq4GIMAZZ2hv1JC/xDxZs/59ACuL0IsjmdZPEiR8uiF01ZejehmdFiPJJP8at+PJgnoW
hW21Gh72CYI3CjvfB37Q5fUOqF1gMsfJmsJokwYfLLy8BcWbmP5BQ8IOL42F2RsuPTctnnbS
hhYj73Qyp4/Mxzeg1r34ZevEqM1pX6ceW7I/7Aos8HmhbcW71KMCAwEAAaOCAfswggH3MAwG
A1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgSwMB0GA1UdDgQWBBTeMPDcRbuXT/FdxHmf8kNH
EWVOVjAfBgNVHSMEGDAWgBTGdckorNEL/Dz/ubUe0187gGISNDAlBgNVHREEHjAcgRpDYXJz
dGVuLkF1bGJlcnRAYWVpLm1wZy5kZTAcBgNVHRIEFTATgRFncmlka2EtY2FAa2l0LmVkdTA1
BgNVHR8ELjAsMCqgKKAmhiRodHRwOi8vZ3JpZC5memsuZGUvY2EvZ3JpZGthLWNybC5kZXIw
KAYDVR0gBCEwHzAPBg0rBgEEAZQ2qywBAQEIMAwGCiqGSIb3TAUCAgEwEQYJYIZIAYb4QgEB
BAQDAgWgME4GCWCGSAGG+EIBDQRBFj9DZXJ0aWZpY2F0ZSBpc3N1ZWQgdW5kZXIgQ1AvQ1BT
IHYuIDEuOCBhdCBodHRwOi8vZ3JpZC5memsuZGUvY2EwJAYJYIZIAYb4QgECBBcWFWh0dHA6
Ly9ncmlkLmZ6ay5kZS9jYTAzBglghkgBhvhCAQgEJhYkaHR0cDovL2dyaWQuZnprLmRlL2Nh
L2dyaWRrYS1jcHMucGRmMDMGCWCGSAGG+EIBAwQmFiRodHRwOi8vZ3JpZC5memsuZGUvY2Ev
Z3JpZGthLWNybC5kZXIwDQYJKoZIhvcNAQEFBQADggEBALkdDvMzLkK1EpFkRPxEA4GpbYyy
5p59V9057HT/QUYvD7rO5KiayiRoDqgKeDW59Fek1N5W0d2IuN+j+VWLDqlBI1THd33F3Dqc
08Me/q6OkpHDjhCDnuH353n2gyxnsmXEEMozhx4onJbX0N3kZxjgNKEiP9R+zOq6Qq+CgKFS
O5w/wdtCTQ5Tpfr/n90KWYwVQ2er5dnKowu6j9YIj/dD8jJGk3T13rgzdnRzWtSQhjP8YIRf
ql08NsUgDShjNiBo289K7fpBNdVLGNI/pIA8P1ratofCGBPvMdjp+cjhulQX5//qS1ctP0ux
8MhY3kBMGynLkwibH5MiLfVSip0xggLOMIICygIBATA8MDYxCzAJBgNVBAYTAkRFMRMwEQYD
VQQKEwpHZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAk/QMAkGBSsOAwIaBQCgggFn
MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEzMDkxODA0MzQy
MVowIwYJKoZIhvcNAQkEMRYEFGijL4eu831qFCMJw+WNv2Q2uq5OMEsGCSsGAQQBgjcQBDE+
MDwwNjELMAkGA1UEBhMCREUxEzARBgNVBAoTCkdlcm1hbkdyaWQxEjAQBgNVBAMTCUdyaWRL
YS1DQQICT9AwTQYLKoZIhvcNAQkQAgsxPqA8MDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpH
ZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAk/QMGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEA
WE0vn6KAauIhKtFLOq9uU27f2sf8OKUdNXUibTCHfuSHIwlh1yziPQ3ACxcGFBE1IMsj+mBc
9gCuqFoaGBQTDFY9Yn172/qEBW2xAWC9eJMfJ41cn/gMlgZWFw4qQLrjuAC8MAbR/20Ky02I
DleUx+9HrVZR/Uv+7sq87e2nSZt868rXXu7knVsR3HwHDJsn/horkcAcayxLWBQPf7r7F6QN
VJy18k7Lyywf4v1fsdsGVTBFAueUSI8N+zVL6HjDqlt4KX/Lq0LDaIuM0TCgzdh97R01p8wE
4Ap0YO0aW7w6jVdRChBFcOX4eYS9MhlJHWbb/zTTHzlGL+W0S1IQeQAAAAAAAA==
--------------ms070807050603000702080006--
