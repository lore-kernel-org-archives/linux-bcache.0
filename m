From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bcache-status shows now output when caching device detached
Date: Sun, 15 Sep 2013 19:34:46 +0200
Message-ID: <5235EFB6.2060008@rolffokkens.nl>
References: <5235CD22.8000507@rolffokkens.nl> <5235D021.8040501@gmail.com> <5235D578.8020406@rolffokkens.nl> <5235E637.10008@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5235E637.10008-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

When no caching devices are connected, bcache-status shows nothing. 
Although actually no caching happens, it's confusing.

On 09/15/2013 06:54 PM, Rolf Fokkens wrote:
> Yep, works indeed.
>
> Dispite the alarming description :-)
>
> Suggestion for alternative text:  "Detaches all caching devices and 
> closes them; if any data is present in the caching devices it will ..."
>
> On 09/15/2013 05:42 PM, Rolf Fokkens wrote:
>> On 09/15/2013 05:20 PM, Gabriel de Perthuis wrote:
>>> Cache sets have an 'unregister' action: 
>>> /sys/fs/bcache/<uuid>/unregister The reference docs are in 
>>> bcache.txt. 
>>> http://atlas.evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt?h=bcache-dev#n367 
>>
>>
>> I noteced that one, but it looks kind of scary to me:
>> |"Detaches all backing devices and closes the cache devices; if dirty 
>> data is present it will disable writeback caching and wait for it to 
>> be flushed.|
>> Sounds like one of these:
>> - the /dev/cache* devices are gone; if so: that's definitely not what 
>> I want.
>> - or at least the the baching devices are detached; that also sounds 
>> bad. I don't want to detacht the backing devices at all, I want to 
>> detacht the caching device.
>>
>> The text is somewhat confusing to me. I'll give it a try, it's only a 
>> VM.
>
