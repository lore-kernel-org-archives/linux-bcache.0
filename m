From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [GIT] Bcache version 12
Date: Thu, 15 Sep 2011 14:15:19 -0700
Message-ID: <CAA9_cmeqevWoK=9WMD9c+csc8SbaYq0aK9j1qWr_0FEa6jWZEw@mail.gmail.com>
References: <20110910064531.GA32536@moria>
	<20110911081854.2958fdc8@notabene.brown>
	<20110911192259.GA3743@moria>
	<FD294A0B-7127-4ED1-89B8-3E3ADA796360@dilger.ca>
	<20110912014407.GA5171@moria>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110912014407.GA5171@moria>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, NeilBrown <neilb@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "rdunlap@xenotime.net" <rdunlap@xenotime.net>, "axboe@kernel.dk" <axboe@kernel.dk>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-Id: linux-bcache@vger.kernel.org

On Sun, Sep 11, 2011 at 6:44 PM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:
> On Sun, Sep 11, 2011 at 07:35:56PM -0600, Andreas Dilger wrote:
>> On 2011-09-11, at 1:23 PM, Kent Overstreet <kent.overstreet@gmail.co=
m> wrote:
>> > I don't think that makes any more sense, as module paramaters AFAI=
K are
>> > even more explicitly just a value you can stick in and pull out.
>> > /sys/fs/bcache/register is really more analagous to mount().

=2E.. and you looked at module_param_call()?

>> > You're not the first person to complain about that, I moved it to
>> > configfs for awhile at Greg K-H's behest... but when I added cache=
 sets
>> > I had to move it back to sysfs.
>> >
>> >> Alternately you could device a new 'bus' type for bcache and do s=
ome sort of
>> >> device-model magic to attach something as a new device of that ty=
pe.
>> >
>> > I like that, I think that could make a lot of sense.
>> >
>> > I'm not sure what to do about register though, I do prefer to have=
 it a
>> > file you can echo to but it doesn't really fit anywhere.
>>
>> Rather than using /proc or /sys to configure bcache, why not integra=
te it with device mapper, and use dmsetup to configure it? =A0That avoi=
ds adding yet another block device abstraction into the kernel, and yet=
 one more obscure way of configuring things.
>>
>> A bcache device could be considered almost like an LV snapshot, wher=
e writes go to the SSD device instead of a disk, and they can have writ=
eback or writethrough cache.
>
> I looked into that many months ago, spent quite a bit of time fightin=
g
> with the dm code trying to get it to do what I wanted and... no. Neve=
r
> again

Did you do a similar analysis of md?  I had a pet caching project that
had it's own sysfs interface registration system, and came to the
conclusion that it would have been better to have started with an MD
personality.  Especially when one of the legs of the cache is a
md-raid array it helps to keep all that assembly logic using the same
interface.  And md supports assembling devices via sysfs without
requiring mdadm which is a nice feature.

Also has the benefit of reusing the distro installation / boot
enabling for md devices which turned out to be a bit of work when
enabling external-metadata in md.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
