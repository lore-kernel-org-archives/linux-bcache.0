From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs] bcache (dm-10): IO error on dm-10 for checksum error
 (due to change of str_hash?)
Date: Fri, 16 Sep 2016 10:07:30 +0200
Message-ID: <b84591f6-c35e-0286-e6f2-16c7fdf5daaf@mejor.pl>
References: <0d572bc6-179d-f779-5d40-6fba6c66a3e6@mejor.pl>
 <20160916033308.voyodnallkvbqkgj@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:57058 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755222AbcIPIHk (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Sep 2016 04:07:40 -0400
In-Reply-To: <20160916033308.voyodnallkvbqkgj@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 16.09.2016 o 05:33, Kent Overstreet pisze:
> On Thu, Sep 15, 2016 at 11:36:14AM +0200, Marcin Mirosław wrote:
>> Hi!
>> I was playing with fs without tiering. I was using it for tmp dir for
>> compilation. Next I changed in sys:
>> echo crc64 > options/data_checksum
>> echo crc64 > options/metadata_checksum
>> echo crc64 > options/str_hash
>>
>> After a couple of minutes I got:
>> [ 8372.574346] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8372.680196] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8464.361860] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8466.146966] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8466.995095] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8469.199749] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8469.441408] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8469.722676] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8469.827055] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8470.038869] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8470.236663] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8470.427094] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8472.030519] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8473.098820] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8916.491297] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8916.715057] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8916.715111] bcache (dm-10): too many IO errors on dm-10, setting
>> filesystem RO
>> [ 8916.733056] bcache (dm-10): IO error on dm-10 for checksum error
>> [ 8916.733125] bcache (dm-10): dm-10 read only
>> [ 8916.733161] bcache (dm-10): too many IO errors on dm-10, setting
>> device RO
>> [ 8916.988286] bcache (dm-10): IO error: read only
>> [ 8916.988545] bcache (dm-10): IO error: read only
> 
> Ok, it turns out the crc64 for data checksums code was just fubar. Fix is up
> (the fix does change how crc64 is computed for bios though, so it'll be
> incompatible with your existing filesystem).
> 
> Also pushed a patch that adds some more error messages to fs-gc, we should
> figure out why it wouldn't mount. I can't think of any reason why data checksum
> errors would've caused that.

Hi Kent, hi all,
when I tried to mount fs that has troubles yesterday I've got:
[  494.296818] bcache (dm-10): dm-10: journal checksum bad (got
18446744072224191025 expect 2809606705), sector 2048u
[  494.309973] bcache (dm-10): dm-10: journal checksum bad (got
18446744073320597786 expect 3906013466), sector 2304u
[  494.311597] bcache (dm-10): dm-10: journal checksum bad (got
18446744070980686285 expect 1566101965), sector 2560u
[  494.313038] bcache (dm-10): dm-10: journal checksum bad (got
18446744073177643543 expect 3763059223), sector 2816u
[  494.324082] bcache (dm-10): dm-10: journal checksum bad (got
18446744070081456445 expect 666872125), sector 3072u
[... many similar lines...]
[  495.000229] bcache (dm-10): dm-10: journal checksum bad (got
18446744071270315299 expect 1855730979), sector 90368u
[  495.001373] bcache (dm-10): dm-10: journal checksum bad (got
18446744070901133954 expect 1486549634), sector 90624u
[  495.002696] bcache (dm-10): dm-10: journal checksum bad (got
18446744071373615633 expect 1959031313), sector 90880u
[  496.618084] bcache (dm-10): journal replay error: -28
[  496.618124] bcache: bch_open_as_blockdevs() register_cache_set err
journal replay failed
[  496.796085] bcache (dm-10): stopped


What str_hash does?

Today I formated block device and again I play with changing
"compression, data_checksum, metadata_checksum, str_hash". I was
changing options while intensive writing to fs. Two times I had hard
lockup of kernel. No chance for getting dmesg. After first lockup I
caouldn't mount fs again due to:
kernel: [  260.141942] bcache: bch_open_as_blockdevs()
register_cache_set err bad btree root

So -> format -> testing - hard lockup. On the second time I could mount
again fs:
kernel: [  234.920846] bcache (dm-11): journal replay done, 29 keys in 1
entries, seq 3447

I'm thinking about using netconsole but I'm not sure I would have a time
for this before tuesday.

Thanks,
Marcin
