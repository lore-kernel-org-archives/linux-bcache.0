From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: RE: Which Version
Date: Tue, 14 Aug 2012 11:18:38 +0100
Message-ID: <519012e7d778df8656c3444db28a1f71@abpni.co.uk>
References: <c2131d5d34c5334cefb53aa59e274c98@abpni.co.uk>
 <6035A0D088A63A46850C3988ED045A4B299F962D@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6035A0D088A63A46850C3988ED045A4B299F962D-mzsoxcrO4/2UD0RQwgcqbDSf8X3wrgjD@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

er if you believe you have received
this email in error.

On 14.08.2012 11:11, James Harper wrote:
>>
>> Hi Everyone,
>>
>> Which version of bcache do I pull from git if I want the latest 
>> stable release?
>> Am I correct in saying that the only way to obtain bcache is to pull 
>> and
>> compile the entire Linux kernel from the bcache git server?
>> Also, I wish to run bcache on my Xen Dom0, I'm guessing that these 
>> kernels
>> have to correct Xen patches for this (As xen kernel patches are now
>> mainline)?
>>
>
> I'm using the 3.2 branch, purely because I wanted to continue using
> the 3.2.x kernel from Debian. According to a question I asked 
> recently
> it's mostly up to date. To do this, I checked out the 3.2 branch of
> bcache, and extracted a diff from the v3.2 tag (eg the mainstream
> linux), then applied this to the Debian source. I can't remember but 
> I
> think the patch needed a bit of nudging in one place. I've only been
> testing for a few days but so far it's flawless.

Thanks for the info. Do you have the steps you used to do this? I've 
never patched a kernel before from another source....

I'd be using the Ubuntu kernel so the steps should be similar
>
> When you create the bcache devices, I suggest setting the block size
> to 512 bytes, otherwise the resulting bcache devices have 4K sectors
> sizes and Xen doesn't like it. YMMV.

Ah yes. I'm also using MD RAID. Does the chunk size matter at all?
>
> Because I'm layering lvm on bcache on md on sd, I had to tweak the
> initramfs scripts to make things load in the right order, and also 
> you
> still need to put /boot on something grub understands eg /dev/sdX or
> /dev/mdX. Grub doesn't understand bcache (yet?).

I'll be doing the same thing. What tweaks did you have to make? My 
bcache'ed MD RAID volume will be seperate to the boot and root 
partitions, so that shouldn't be an issue.

Thanks for your help
