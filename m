From: "Lidong Zhong" <lzhong@suse.com>
Subject: Re: caching device setup
Date: Wed, 08 Apr 2015 21:08:18 -0600
Message-ID: <55265DA2020000E10002042C@relay2.provo.novell.com>
References: <CAK1hC9vTG=TEsUzNgxym=+0swhPoxBNaaPAiWk1kBf-D+_Hftg@mail.gmail.com>
 <498317a297a1038028f1393da9b49231@de.mcbf.net>
 <98agvb-l7r.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay2.provo.novell.com ([137.65.250.214]:52751 "EHLO
	relay2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbbDIDIZ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-bcache@vger.kernel.org:2:1>);
	Wed, 8 Apr 2015 23:08:25 -0400
In-Reply-To: 
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>, linux-bcache@vger.kernel.org

>>> On 4/9/2015 at 11:05 AM, in message <5525EC60.8F7 : 225 : 10347>, Lidong Zhong
wrote: 

> Hi David, 
Hi Kai, I am really sorry for the wrong name :\

> I am curious about how rootfs and home share the SSD dynamically. Are they  
> on 
> the same partition? Sorry for stupid questions since I just touched bcache  
> recently. 
>  
> Regards, 
> Lidong 
>> cache then depending on demands. So rootfs is a bit slower as natively on   
>> SSD but home can gain much more because unsed parts of the rootfs are   
>> available for caching.  
>>   
>> The split-setup preference in turn gives you a fallback boot option in case   
>> bcache chokes: You still have a working rootfs to do repairs or restore   
>> backups. In my setup I encounter that problem with a working USB3-HD mirror   
>> of my system I can boot and restore from which is synced and snapshotted   
>> every night (so it also protects against accidental file deletion synced   
>> undetected into the backup). Most valuable data is stored remotely (photos,   
>> source code, documents, configuration, etc).  
>   
>  
