From: "Lidong Zhong" <lzhong@suse.com>
Subject: Re: caching device setup
Date: Wed, 08 Apr 2015 21:05:04 -0600
Message-ID: <55265CE0020000E100020423@relay2.provo.novell.com>
References: <CAK1hC9vTG=TEsUzNgxym=+0swhPoxBNaaPAiWk1kBf-D+_Hftg@mail.gmail.com>
 <498317a297a1038028f1393da9b49231@de.mcbf.net>
 <98agvb-l7r.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay2.provo.novell.com ([137.65.250.214]:52657 "EHLO
	relay2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbbDIDFL convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-bcache@vger.kernel.org:2:1>);
	Wed, 8 Apr 2015 23:05:11 -0400
In-Reply-To: <98agvb-l7r.ln1@hurikhan77.spdns.de>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>, linux-bcache@vger.kernel.org

>>> On 4/9/2015 at 02:56 AM, in message <98agvb-l7r.ln1@hurikhan77.spdns.de>, Kai
Krakow <hurikhan77@gmail.com> wrote: 
> David Mohr <david@mcbf.net> schrieb: 
>  
> > On 2015-04-06 09:44, arnaud gaboury wrote: 
> >> Here is my overall plan: 
> >>  
> >> root filesystem & OS on a SSD 
> >> DB and other stuff on HD. 
> >> Use ssd as caching device and HD as backing. 
> >>  
> >> Shall I partition the SSD with : one partition for OS and one empty 
> >> for bcache? Or install the OS on the whole SSD and use the whole SSD 
> >> as caching device? 
> >>  
> >> Thank you for hint. 
> >  
> > So this is just depending on your preference, how big the SSD is, and 
> > how much space you expect your OS to take up. 
> >  
> > Personally I split my SSD into two partitions: one for the root FS, and 
> > the other as a caching device for /home. 
>  
> The other preference is valid, too: I chose to put bcache only on the SSD to  
>  
> get maximum benefit from its capacity, rootfs and home dynamically share the  
>  
Hi David,
I am curious about how rootfs and home share the SSD dynamically. Are they on
the same partition? Sorry for stupid questions since I just touched bcache recently.

Regards,
Lidong
> cache then depending on demands. So rootfs is a bit slower as natively on  
> SSD but home can gain much more because unsed parts of the rootfs are  
> available for caching. 
>  
> The split-setup preference in turn gives you a fallback boot option in case  
> bcache chokes: You still have a working rootfs to do repairs or restore  
> backups. In my setup I encounter that problem with a working USB3-HD mirror  
> of my system I can boot and restore from which is synced and snapshotted  
> every night (so it also protects against accidental file deletion synced  
> undetected into the backup). Most valuable data is stored remotely (photos,  
> source code, documents, configuration, etc). 
 
