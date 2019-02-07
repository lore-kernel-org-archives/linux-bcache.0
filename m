From: Coly Li <colyli@suse.de>
Subject: Re: bcache on XFS: metadata I/O (dirent I/O?) not getting cached at
 all?
Date: Thu, 7 Feb 2019 18:23:44 +0800
Message-ID: <41fef785-1e38-87ea-115a-4cdb7e86ed18@suse.de>
References: <87h8dgefee.fsf@esperi.org.uk>
 <64f32487-5b8f-f6c2-37a9-84bb0717a9e1@suse.de>
 <20190207094138.GZ24140@tuebingen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190207094138.GZ24140@tuebingen.mpg.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andre Noll <maan@tuebingen.mpg.de>
Cc: Nix <nix@esperi.org.uk>, linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-bcache@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 2019/2/7 5:41 下午, Andre Noll wrote:
> On Thu, Feb 07, 16:16, Coly Li wrote
>> From: Coly Li <colyli@suse.de> Date: Thu, 7 Feb 2019 15:54:24
>> +0800 Subject: [PATCH] bcache: use (REQ_META|REQ_PRIO) to
>> indicate bio for metadata
>> 
>> In 'commit 752f66a75aba ("bcache: use REQ_PRIO to indicate bio
>> for metadata")' REQ_META is replaced by REQ_PRIO to indicate
>> metadata bio. This assumption is not always correct, e.g. XFS
>> uses REQ_META to mark metadata bio other than REQ_PRIO. This is
>> why Nix reports a regression that bcache does not cache metadata
>> for XFS after the above commit.
> 
> maybe s/reports a regression/noticed
> 
>> Thanks to Dave Chinner, he explains the difference between
>> REQ_META and REQ_PRIO from view of file system developer. Here I
>> quote part of his explanation from mailing list, REQ_META is used
>> for metadata. REQ_PRIO is used to communicate to the lower layers
>> that the submitter considers this IO to be more important that
>> non REQ_PRIO IO and so dispatch should be expedited.
>> 
>> IOWs, if the filesystem considers metadata IO to be more
>> important that user data IO, then it will use REQ_PRIO | REQ_META
>> rather than just REQ_META.
>> 
>> Then it seems bios with REQ_META or REQ_PRIO should both be
>> cached for performance optimation, because they are all probably
>> low I/O latency demand by upper layer (e.g. file system).
>> 
>> So in this patch, when we want to check whether a bio is
>> metadata related, REQ_META and REQ_PRIO are both checked. Then
>> both metadata and high priority I/O requests will be handled
>> properly.
> 
> s/check whether a bio is metadata related/decide whether to bypass
> the cache
> 
> Apart from these two nitpicks, feel free to add my Reviewed-by.

Hi Andre,

Thanks for your review :-)

- -- 

Coly Li
-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE6j5FL/T5SGCN6PrQxzkHk2t9+PwFAlxcBy0ACgkQxzkHk2t9
+PxmeRAAnIh3KzGx13lmpj/0sDlellc02eawvooSDE8zTNsqo/UzqAB1lzUvtJx1
SQXYepoM4hPjrGzDKBe+oaMWuzG6WO08kI0dMT1Q1cfKX2eucExa8G9oRHQqxxBq
wRChl4HKScqvyCy0XTQYet8QJwFAeBAdBzM2L0VOuulsRjLKBSfpcH+jr9fdNt/S
wWGv9KVlJDq3BZrRA0TA1ovDl4wohyvtXM4OL27ahUMlmj4cI0XlaoketaAVM8QS
z7uK+9sRdemW3cvfkl76wfIkiSN43Pk6RZcKRAHzlSgwF1L3xY7ZPxhFz187bFzI
ANpTLVXiv1JNx+jnceV4O7UVZyj06hQhh1VFLedqpAVvzgYNp8RRSaiWucNH7m5d
6qzw5+ob5jMEI2vdXooYC8hVwNaXa+3XfVU5QLlKVG9Al1kZxgkE3e8s28pjj3Df
WJXaqkOCnal12FZ9Hz+Ev/Jp/1wmN3TagPJyeVlc/0vQTIXfBFuSssL+n/1RrKjd
wTc2WuWBf2x7BLnuCX6z4fDvPLuW8LOJCrCYsqr4z5s7YI6mb0B4qDSqli8dN2TB
vxnY1K1WQW/9BhE/QQpXHKBD2nRbPYcaAZEhk3UvIdV2dvafdQpcD4FgrEXGKXV8
MmkaeTcQ4NcSNvGWgG9vaiY0acE8YGtqNsBDAtjOglJrP/tJjJA=
=kG5J
-----END PGP SIGNATURE-----
