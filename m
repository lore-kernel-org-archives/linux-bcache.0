From: Peter Kieser <peter@kieser.ca>
Subject: Re: [PATCH] bcache: Fix writeback_thread never writing back
 incomplete stripes.
Date: Tue, 29 Sep 2015 16:00:06 -0700
Message-ID: <560B17F6.1030200@kieser.ca>
References: <20150905111012.GA17180@suse.com>
 <20150916113206.GA16164@kmo-pixel>
 <CAO2mnozhTeuWwxsmQZor93xmyS5_r34YpGXy0ec=9vFCBGbO1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms010702050501040505050302"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAO2mnozhTeuWwxsmQZor93xmyS5_r34YpGXy0ec=9vFCBGbO1w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Denis Bychkov <manover@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>, Emmanuel Florac <eflorac@intellique.com>, Jiri Kosina <jkosina@suse.com>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-bcache@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010702050501040505050302
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

My question still stands:

Why are none of these patches submitted to mainline or backported to=20
stable kernels?

Thanks.

On 2015-09-16 2:08 PM, Denis Bychkov wrote:
> Hi Kent, Vojtech, list
>
> Your fix works perfectly, I can finally remove my patch that disables
> the partial_stripes_expensive branch and unleash the full bcache
> performance on my RAID-6 array. I was aware of this problem for some
> time now, but never got to learning the bcache codebase enough to find
> out why this happens with partial stripes write-back enabled, so I
> just disabled it to avoid CPU spinning. Thanks a lot to Vojtech for
> finding the reason and to you for the patch. I have quite a collection
> of stability patches for the mainline bcache. Would you please be kind
> to review them when convenient and merge upstream the ones you think
> are worth merging. It will be 4.4 merge window, I believe.
> Please find all the patches attached. All of them are rebased on
> mainline 4.2 kernel. If somebody needs the 4.1.x versions, please let
> me know.
>
>
> On Wed, Sep 16, 2015 at 7:32 AM, Kent Overstreet
> <kent.overstreet@gmail.com> wrote:
>> On Sat, Sep 05, 2015 at 01:10:12PM +0200, Vojtech Pavlik wrote:
>>> Fix writeback_thread never finishing writing back all dirty data in b=
cache when
>>> partial_stripes_expensive is set, and spinning, consuming 100% of CPU=
 instead.
>>>
>>> Signed-off-by: Vojtech Pavlik <vojtech@suse.com>
>>> ---
>>>
>>> This is a fix for the current upstream bcache, not the devel branch.
>>>
>>> If partial_stripes_expensive is set for a cache set, then writeback_t=
hread
>>> always attempts to write full stripes out back to the backing device =
first.
>>> However, since it does that based on a bitmap and not a simple linear=

>>> search, like the rest of the code of refill_dirty(), it changes the
>>> last_scanned pointer so that never points to 'end'. refill_dirty() th=
en
>>> never tries to scan from 'start', resulting in the writeback_thread
>>> looping, consuming 100% of CPU, but never making progress in writing =
out
>>> the incomplete dirty stripes in the cache.
>>>
>>> Scanning the tree after not finding enough full stripes fixes the iss=
ue.
>>>
>>> Incomplete dirty stripes are written to the backing device, the devic=
e
>>> eventually reaches a clean state if there is nothing dirtying data an=
d
>>> writeback_thread sleeps. This also fixes the problem of the cache dev=
ice
>>> not being possible to detach in the partial_stripes_expensive scenari=
o.
>> Good catch!
>>
>>> It may be more efficient to separate the last_scanned field for norma=
l and
>>> stripe scans instead.
>> Actually, I think I like your approach - I think it gives us the behav=
iour we
>> want, although it took some thinking to figure out why.
>>
>> One of the reasons for last_scanned is just to do writeback in LBA ord=
er and
>> avoid making the disks seek around - so, if refill_full_stripes() did =
just queue
>> up some IO at last_scanned, we do want to keep scanning from that posi=
tion for
>> non full stripes.
>>
>> But since (as you noted) last_scanned is never going to be >=3D end af=
ter calling
>> refill_full_strips() (if there were any full stripes) - really the cor=
rect thing
>> to do is loop around to the start if necessary so that we can successf=
ully scan
>> everything.
>>
>> The only inefficiency I see with your approach is that on the second s=
can, after
>> we've looped, we don't need to scan to the end of the disk - we only n=
eed to
>> scan up to where we initially started.
>>
>> But, another observation - if we change refill_dirty() so that it alwa=
ys scans
>> the entire keyspace if necessary, regardless of where last_scanned was=
 - well,
>> that really isn't specific to the refill_full_stripes() case - we can =
just
>> always do that.
>>
>> Can you give this patch a try?
>>
>> -- >8 --
>> Subject: [PATCH] bcache: Change refill_dirty() to always scan entire d=
isk if necessary
>>
>> Previously, it would only scan the entire disk if it was starting from=
 the very
>> start of the disk - i.e. if the previous scan got to the end.
>>
>> This was broken by refill_full_stripes(), which updates last_scanned s=
o that
>> refill_dirty was never triggering the searched_from_start path.
>>
>> But if we change refill_dirty() to always scan the entire disk if nece=
ssary,
>> regardless of what last_scanned was, the code gets cleaner and we fix =
that bug
>> too.
>>
>> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
>> ---
>>   drivers/md/bcache/writeback.c | 24 ++++++++++++++++--------
>>   1 file changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeba=
ck.c
>> index cdde0f32f0..08a52db38b 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -359,11 +359,13 @@ next:
>>          }
>>   }
>>
>> +/*
>> + * Returns true if we scanned the entire disk
>> + */
>>   static bool refill_dirty(struct cached_dev *dc)
>>   {
>>          struct keybuf *buf =3D &dc->writeback_keys;
>> -       struct bkey end =3D KEY(dc->disk.id, MAX_KEY_OFFSET, 0);
>> -       bool searched_from_start =3D false;
>> +       struct bkey start_pos, end =3D KEY(dc->disk.id, MAX_KEY_OFFSET=
, 0);
>>
>>          if (dc->partial_stripes_expensive) {
>>                  refill_full_stripes(dc);
>> @@ -371,14 +373,20 @@ static bool refill_dirty(struct cached_dev *dc)
>>                          return false;
>>          }
>>
>> -       if (bkey_cmp(&buf->last_scanned, &end) >=3D 0) {
>> -               buf->last_scanned =3D KEY(dc->disk.id, 0, 0);
>> -               searched_from_start =3D true;
>> -       }
>> -
>> +       start_pos =3D buf->last_scanned;
>>          bch_refill_keybuf(dc->disk.c, buf, &end, dirty_pred);
>>
>> -       return bkey_cmp(&buf->last_scanned, &end) >=3D 0 && searched_f=
rom_start;
>> +       if (bkey_cmp(&buf->last_scanned, &end) < 0)
>> +               return false;
>> +
>> +       /*
>> +        * If we get to the end start scanning again from the beginnin=
g, and
>> +        * only scan up to where we initially started scanning from:
>> +        */
>> +       buf->last_scanned =3D KEY(dc->disk.id, 0, 0);
>> +       bch_refill_keybuf(dc->disk.c, buf, &start_pos, dirty_pred);
>> +
>> +       return bkey_cmp(&buf->last_scanned, &start_pos) >=3D 0;
>>   }
>>
>>   static void bch_writeback(struct cached_dev *dc)
>> --
>> 2.5.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--=20
Peter Kieser
604.338.9294 / peter@kieser.ca



--------------ms010702050501040505050302
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DKswggY0MIIEHKADAgECAgEgMA0GCSqGSIb3DQEBBQUAMH0xCzAJBgNVBAYTAklMMRYwFAYD
VQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0
ZSBTaWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAe
Fw0wNzEwMjQyMTAyNTVaFw0xNzEwMjQyMTAyNTVaMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UE
ChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUg
U2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMiBQcmltYXJ5IEludGVybWVkaWF0
ZSBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDLKIVFnAEs+xny
q6UzjCqgDcvQVe1dIoFnRsQPCFO+y92k8RK0Pn3MbQ2Gd+mehh9GBZ+36uUQA7Xj9AGM6wgP
hEE34vKtfpAN5tJ8LcFxveDObCKrL7O5UT9WsnAZHv7OYPYSR68mdmnEnJ83M4wQgKO19b+R
t8sPDAz9ptkQsntCn4GeJzg3q2SVc4QJTg/WHo7wF2ah5LMOeh8xJVSKGEmd6uPkSbj113yK
Mm8vmNptRPmM1+YgmVwcdOYJOjCgFtb2sOP79jji8uhWR91xx7TpM1K3hv/wrBZwffrmmEpU
euXHRs07JqCCvFh9coKF4UQZvfEg+x3/69xRCzb1AgMBAAGjggGtMIIBqTAPBgNVHRMBAf8E
BTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUrlWDb+wxyrn3HfqvazHzyB3jrLsw
HwYDVR0jBBgwFoAUTgvvGqRAW6UXaYcwyjRoQ9BBrvIwZgYIKwYBBQUHAQEEWjBYMCcGCCsG
AQUFBzABhhtodHRwOi8vb2NzcC5zdGFydHNzbC5jb20vY2EwLQYIKwYBBQUHMAKGIWh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tL3Nmc2NhLmNydDBbBgNVHR8EVDBSMCegJaAjhiFodHRwOi8v
d3d3LnN0YXJ0c3NsLmNvbS9zZnNjYS5jcmwwJ6AloCOGIWh0dHA6Ly9jcmwuc3RhcnRzc2wu
Y29tL3Nmc2NhLmNybDCBgAYDVR0gBHkwdzB1BgsrBgEEAYG1NwECATBmMC4GCCsGAQUFBwIB
FiJodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kucGRmMDQGCCsGAQUFBwIBFihodHRw
Oi8vd3d3LnN0YXJ0c3NsLmNvbS9pbnRlcm1lZGlhdGUucGRmMA0GCSqGSIb3DQEBBQUAA4IC
AQA6qScNyNO0FpHvaZTQacVMXH33O51KyEKSRw3IvdQxRu31YR0ZDGdSfgSoOVDVMSBSdmfQ
fdDInHPzV3LO5DwUXZ+lxjv7z3PO2OkfnFkvTXPfn6dxJ5rJveDsTsCPcJ/Kp6/+qN5g+J6D
/SaYcFD018B6L42r0Z4VEBy36P4tjRtF14Ex10tl5tJFVKM16qWKQHbpjIgf73s49UB0CQ5l
HT2DHKfq3oPfdNc5Mk93w1v4ryVb+qVrZIej8NsrWU+5r4O2IV91edDb/OtHFddZqHFFXKgS
79IHE/hwQ2LW7r3sTX7cDUCg+dfdwO8zeLxuwk2JF8crUoyrl66RGrRIhT8VoG/OJ1Y9uUlO
av69V4cG8upi4ZG2l7JZFbcBFk91Wp+Payo5SuF61CmGFrZ386umkmpObtFacXda2O/bVoQ9
xHQrzoTc/0KZTWvlZCLK3Ke/vGYT9ZdW9lOjGsSFbXrlTA919L84iMK+48WGnvRWY28ZaVHp
ql43AtEGhXze6iNCbEDACy+4hkQYOytAqDgcxAnQ937mYpeZFPyz/XK9QSt9VNFMuudWxZwD
DDJKoQAoSG59Hou9lZ26UrK60nRdAQBmEPL8h2nuWgoPh++XVQld9yuhbsWa39Pck8/lcfz5
HUVGJF5mc/zk38iV7FDlF68puiryNq2KXHEpOTCCBm8wggVXoAMCAQICAlHLMA0GCSqGSIb3
DQEBBQUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UE
CxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRD
b20gQ2xhc3MgMiBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcNMTQwODE3MTAz
OTA5WhcNMTYwODE3MTM1NTMxWjCBjjEZMBcGA1UEDRMQSkhyOElnZDY4ZW1FMHlRejELMAkG
A1UEBhMCQ0ExGTAXBgNVBAgTEEJyaXRpc2ggQ29sdW1iaWExEjAQBgNVBAcTCVZhbmNvdXZl
cjEVMBMGA1UEAxMMUGV0ZXIgS2llc2VyMR4wHAYJKoZIhvcNAQkBFg9wZXRlckBraWVzZXIu
Y2EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC/zZi0sMysoRWvMFWODp+A9mrV
vozuJKsxo7d9hiE8RIcHnkdgHkBYZgV08MABxpwBFlPpUEl6CKFfR3YvBoU3hc9wOSz0y5f8
GunZr/FQn2GkRL6EsYxDeJ7ArXVPD+jS1BOJqgXu2Yj/ZQ5KloJndHwxGI4jpyVN3HaC4ebw
xzsrvvZpjw1RARCxYG23ULMoiDSkDeX8BJUP+YcIqf+ZRQq0/EmGFUu7NicBD7bz5qZficjs
ESWpIVUb+FnfC8r/63ISuK4sHzMh4bisG2ykcbNx80h47bIxmdrUtVMwxGpS+2UbBwuBL2Zo
ARoORNJdQc+3AuCXDyMvvBteDo2ZAgMBAAGjggLVMIIC0TAJBgNVHRMEAjAAMAsGA1UdDwQE
AwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwHQYDVR0OBBYEFLw3DlkKqBhh
Cvig3OqKZ1dYrqSJMB8GA1UdIwQYMBaAFK5Vg2/sMcq59x36r2sx88gd46y7MBoGA1UdEQQT
MBGBD3BldGVyQGtpZXNlci5jYTCCAUwGA1UdIASCAUMwggE/MIIBOwYLKwYBBAGBtTcBAgMw
ggEqMC4GCCsGAQUFBwIBFiJodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kucGRmMIH3
BggrBgEFBQcCAjCB6jAnFiBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTADAgEB
GoG+VGhpcyBjZXJ0aWZpY2F0ZSB3YXMgaXNzdWVkIGFjY29yZGluZyB0byB0aGUgQ2xhc3Mg
MiBWYWxpZGF0aW9uIHJlcXVpcmVtZW50cyBvZiB0aGUgU3RhcnRDb20gQ0EgcG9saWN5LCBy
ZWxpYW5jZSBvbmx5IGZvciB0aGUgaW50ZW5kZWQgcHVycG9zZSBpbiBjb21wbGlhbmNlIG9m
IHRoZSByZWx5aW5nIHBhcnR5IG9ibGlnYXRpb25zLjA2BgNVHR8ELzAtMCugKaAnhiVodHRw
Oi8vY3JsLnN0YXJ0c3NsLmNvbS9jcnR1Mi1jcmwuY3JsMIGOBggrBgEFBQcBAQSBgTB/MDkG
CCsGAQUFBzABhi1odHRwOi8vb2NzcC5zdGFydHNzbC5jb20vc3ViL2NsYXNzMi9jbGllbnQv
Y2EwQgYIKwYBBQUHMAKGNmh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3N1Yi5jbGFz
czIuY2xpZW50LmNhLmNydDAjBgNVHRIEHDAahhhodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS8w
DQYJKoZIhvcNAQEFBQADggEBAMnGxCRup78n279l+J6YKtXHlPstamJl3MwgTbzUSdsr1V3P
JY40LCkQ86a/CYUwoOEjGYdwtwCDgRsa2ArMmsUS90rH4f+j7YNxMSH1TY+gqGwdaYk67rDk
WlQ2EoxLWWUUeImLfZg0aP5mUYYeEETGp2WMAlzxuJq4LqkODS2FXYE7B2IAk0cpjG8q0NPn
iBnQDv7M3Iq0aLwA8sa6DHJcPk05Qe50K6LyLE1bXhqntK3pykdG83VrHsUBJ7SqQcSS8vx0
0iB3kB1Oa+4cI5P79WqCpYprmim3RkyZddAWJPPqW1PCRhJdbJtXDZ+DCmMIZ1hUUwRDxIlz
+lcjXD0xggPqMIID5gIBATCBkzCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29t
IEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2
BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDIgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENB
AgJRyzANBglghkgBZQMEAgEFAKCCAicwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMTUwOTI5MjMwMDA2WjAvBgkqhkiG9w0BCQQxIgQg1aaUgr9/dA246Tbq
y9TqpdkXA1b0bFauXKsfFfGRTjQwbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAH
BgUrDgMCBzANBggqhkiG9w0DAgIBKDCBpAYJKwYBBAGCNxAEMYGWMIGTMIGMMQswCQYDVQQG
EwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwg
Q2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMiBQcmltYXJ5
IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAlHLMIGmBgsqhkiG9w0BCRACCzGBlqCBkzCBjDEL
MAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBE
aWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDIg
UHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgJRyzANBgkqhkiG9w0BAQEFAASCAQAM
hnBD5uCae1Ifszmh3f/Cvd0ZsjhsWnI9HTmudLrRlEKORfrNauDY3f1kYehMQ/DhxZ4qrT3r
R47F2659vTTGdlKZWcvJa78t6VtFuVZVVITwFvPg9lCtmYPg1WAHkJWdrXEB/Wjj/ZRQ9Voo
Xu2za1hBHzjauh5KO/RhtbiEdIUQD8BGS4LWKN0ABw29MTln1MdwIiUkgM7o+dW3NiqvSCRi
zUGAmLkxB/ffEsxiNRLSYPUHgTqwubNR/UDxFhFHsffJ5rA07e5kPTZlesPlJ/NK0NnXrrIe
sP1YISZTjdZuKtIQDsNeqUEtghz6uGX/XnoQMxl05HhsUETceaZXAAAAAAAA
--------------ms010702050501040505050302--
