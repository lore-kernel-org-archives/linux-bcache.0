From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: support for physical ramdisk
Date: Wed, 19 Jan 2011 19:52:20 -0800
Message-ID: <4D37B174.9040309@gmail.com>
References: <4D377D66.5020609@gmail.com>	<AANLkTik30_V_bWGsvoUQw-5-W7URK1tSTDSfcTa8LayX@mail.gmail.com>	<4D37890B.3060808@gmail.com>	<AANLkTinUD1_z3iZ3VgJFh=JkF+6EWDq62==Z9EhBpwBP@mail.gmail.com>	<4D378C5E.7050309@gmail.com> <AANLkTin+xKeYbxSU6u=h8bfujSpm3fxqurC0nR4+89wX@mail.gmail.com> <4D37AD2D.6070108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D37AD2D.6070108-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cory Coager <ccoager-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 01/19/2011 07:34 PM, Cory Coager wrote:
> Sounds great, when will it be ready? ;-)

Well, good question. I've been short funding and thus time for bcache 
lately; not sure what's happening there just yet.

And there's a bunch of things on my todo list; my main priority has been 
the code for a bcache specific block device and superblock for the 
backing device. After that is multiple cache devices, volume management 
and tiered storage, but there's no set order those and 
journalling/external journal support need to be done in.

>
> On 01/19/2011 08:27 PM, Kent Overstreet wrote:
>> Well, ram is more expensive per gigabyte than SSDs, particularly if
>> you've got something with a battery attached - the idea would be to
>> use your SSD for buffering 80 gb or so of writes, but then buffer all
>> of bcache's metadata writes in battery backed-up ram, significantly
>> decreasing the number of write IOPS to the SSD, and making it so
>> pretty much all the writes to the SSD are big contiguous writes.

--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
