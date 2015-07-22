From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Wed, 22 Jul 2015 09:19:26 +0200
Message-ID: <55AF43FE.8040402@megasoft.be>
References: <20150714005825.GA24027@kmo-pixel> <468c161352fd5f77ec371ce256f27e14@de.mcbf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46791 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbbGVHTb (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 22 Jul 2015 03:19:31 -0400
In-Reply-To: <468c161352fd5f77ec371ce256f27e14@de.mcbf.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: sviatoslavpestov@gmail.com, mrubin@google.com, adam.berkan@gmail.com, zab@zabbo.net, rickyb@google.com


On 21-07-15 20:37, David Mohr wrote:

> one quick question about the roadmap at this point: As far as I understand bcachefs basically integrates bcache features directly in the filesystem.
> So does this deprecate bcache itself in your opinion? Bcache is obviously still useful for other FS, but I just want to know how things will get maintained in the future.

If they remove bcache from the kernel a lot of peaple are going to have serious troubles, as it's not easy to remove.
But to quote the developer:
"no don't worry. it's not going to be deleted from upstream"

> I wanted to suggest / possibly start implementing bcache support for the debian installer - obviously that only makes sense if I can expect it to be in the mainline kernel for the foreseeable future :-).

I can also make a quote on this question:
"the btree code is also hugely improved over what's in mainline, i'd like to get the improvements backported but i think it's just way way too much work"
"bcache will be deprecated when a stable bcachefs is upstream (but it's going to be awhile before the on disk format is stable again)"

More info on what bcachefs actually is:
You initialize some fast storage as a caching-device. These store a btree-journal-change (or whatever is actually used internally) key-value storage system on disk.
Next you can use this btree-caching-device to put a file system on top OR use it to store the cache data for a caching-block-device.
(Not sure if you can combine a caching device and a backing device into the same FS, but you will probably be able to.)

--
Killian De Volder
