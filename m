From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs] bcache (dm-10): IO error on dm-10 for checksum error
 (due to change of str_hash?)
Date: Fri, 16 Sep 2016 13:17:39 +0200
Message-ID: <4ce5eedb-8e38-ef94-e01e-b46f9ce8c4d4@mejor.pl>
References: <20160916083853.5syjxgpb4f73bmtt@kmo-pixel>
 <17792e18-4315-0e12-bc5a-96d1cb3e10d5@mejor.pl>
 <20160916091627.nmu2syyabwcohhh3@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:46700 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933921AbcIPLSl (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Sep 2016 07:18:41 -0400
In-Reply-To: <20160916091627.nmu2syyabwcohhh3@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 16.09.2016 o 11:16, Kent Overstreet pisze:
> On Fri, Sep 16, 2016 at 11:02:10AM +0200, Marcin Mirosław wrote:
>> W dniu 16.09.2016 o 10:38, Kent Overstreet pisze:
>> [...]
>>> I haven't yet tried randomly flipping the compression type at runtime, I'll try
>>> that now...
>>
>> Don't forget changing other options, simply changing compression type I
>> tested some times ago and it worked;) I think that also heavy writes
>> while making changes are important.
> 
> Yeah, I think you're right about heavy writes - the one other bug remotely like
> this that's been reported was an intermittent deadlock under heavy write load.
> 
> But "heavy write workload" describes a lot of the tests I already have, so I'm
> not sure what I'm missing. Argh.

I used rsync to make noise:) Ok, With netconsole's help I have:
[11055.485337] bcache (dm-11): journal replay done, 0 keys in 1 entries,
seq 3451
< now I'm starting rsync on earlier used fs, problem happened soon >
[11159.293119] Kernel panic - not syncing: stack-protector: Kernel stack
is corrupted in: ffffffffc095b021
[11159.293157] CPU: 0 PID: 30023 Comm: rsync Tainted: P           O
4.7.0-bcache+ #2
[11159.293166] Hardware name: .   .  /IP35 Pro XE(Intel P35-ICH9R), BIOS
6.00 PG 09/09/2008
[11159.293176]  0000000000000086
00000000414f6380
ffff88002814fae0
ffffffff812cbe0d
[11159.293537] Kernel Offset: disabled
[11159.296006] ---[ end Kernel panic - not syncing: stack-protector:
Kernel stack is corrupted in: ffffffffc095b021

New lines can be broken, I used tcpdump to catch messages.

Marcin
