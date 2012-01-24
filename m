From: David Rhodes Clymer <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>
Subject: Re: bcache lockup
Date: Tue, 24 Jan 2012 08:56:52 -0500
Message-ID: <CAB7K1hEp6Kk+th3DZnMbPhMOmo1peRuT_-mNRTVdpofW7C+Jsg@mail.gmail.com>
References: <CAB7K1hG7mYqGhrn1Uy9D0DGPJJVK8T0QOX8O26BXgcJHLxZESA@mail.gmail.com>
	<CAC7rs0tzAuxyokzAru=KDnPJjFmMhrFjAopH7NJnQiGxi05s3w@mail.gmail.com>
	<CAB7K1hEBJhe1xU5J5saVw4DFz_Oh_JCS7cvqLx++SdadCTtkNA@mail.gmail.com>
	<CAC7rs0uPp6Y41zQ7DS5ROBJn8rcT7Jqmb9P0gF-O-ct3-zPcgw@mail.gmail.com>
	<CAB7K1hGgX5qEfZU+5SY04JM0woT48oNy-sC5+FZg=QKnB7EwMg@mail.gmail.com>
	<CAC7rs0vCkk5QFBKm3TghZdkeOJETF4mrgUZJ-UEmSR2-gXtC9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC7rs0vCkk5QFBKm3TghZdkeOJETF4mrgUZJ-UEmSR2-gXtC9Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sun, Dec 18, 2011 at 11:01 PM, Kent Overstreet
<kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Appears I didn't push the fix to the public tree...
>
> Give me a day or so, I'll need to merge the latest fixes into the 3.1
> tree, test it and make sure I haven't missed anything else...


Looks like commit 7c3e597ca0f5c87767548d1e9aced024aa558b2a
resolved this issue for me.

-davidc


>
> On Sun, Dec 18, 2011 at 5:22 PM, David Rhodes Clymer
> <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org> wrote:
>> On Sat, Dec 17, 2011 at 11:46 PM, Kent Overstreet
>> <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> Argh, it's always something.
>>>
>>> That looks like you hit the BUG_ON(!req->nr_phys_segments). I thoug=
ht
>>> I fixed that.
>>>
>>> Are you running the latest code? There should be a commit that says
>>> "bcache: Always initialize bi_max_vecs".
>>
>> Yeah, I'm running the latest. The last commit is:
>>
>> =A0 =A0 =A0 =A0ffca635f2efb8e091c469ffcc86d4def2d5c381d: Open block =
device exclusively
>>
>> The only 2 commit messages referencing bi_max_vecs that I could find
>> didn't seem to be bcache specific (they were from 2006).
>>
>> I have no local modifications.
>>
>> -davidc.
>>
>>
>>>
>>> On Sat, Dec 17, 2011 at 5:00 AM, David Rhodes Clymer
>>> <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org> wrote:
>>>> On Fri, Dec 16, 2011 at 1:56 PM, Kent Overstreet
>>>> <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>> On Fri, Dec 16, 2011 at 9:41 AM, David Rhodes Clymer
>>>>> <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org> wrote:
>>>>>> Is there any reason bcache would not work with LVM in particular=
, or
>>>>>> did I do something else that was silly?
>>>>>
>>>>> Certainly ought to work, but I'm not sure what the last time I te=
sted
>>>>> it was. I'll see if I can reproduce it.
>>>>
>>>> Well, just for kicks, I setup bcache with a regular disk as the
>>>> backing device. Everything seemed to go ok...I was able to create =
an
>>>> ext4 filesystem on it and mount it. I remembered I had forgotten t=
o
>>>> attach the cache, so I attached the cache, and tried copying an IS=
O to
>>>> the mounted fs, and it immediately crashed.
>>>>
>>>> =A0I was doing this remotely, and now I can't get to the box. So I=
'm not
>>>> certain this is the full traceback, but it's what I got before I l=
ost
>>>> connection:
>>>>
>>>> =A0kernel:[50655.044130] ------------[ cut here ]------------
>>>> Message from syslogd@zapazoid at Dec 17 07:39:06 ...
>>>> kernel:[50655.048019] invalid opcode: 0000 [#1] SMP
>>>> Message from syslogd@zapazoid at Dec 17 07:39:06 ...
>>>> kernel:[50655.048019] Process kworker/5:0 (pid: 5699, ti=3Dc78c200=
0
>>>> task=3Df27db5f0 task.ti=3Dc78c2000)
>>>> Message from syslogd@zapazoid at Dec 17 07:39:06 ...
>>>> kernel:[50655.048019] Stack:
>>>> Message from syslogd@zapazoid at Dec 17 07:39:06 ...
>>>> kernel:[50655.048019] Call Trace:
>>>> Message from syslogd@zapazoid at Dec 17 07:39:06 ...
>>>> kernel:[50655.048019] Code: 8b 87 88 03 00 00 85 c0 74 17 8b 00 85=
 c0
>>>> 74 11 8b 48 28 85 c9 74 0a 89 f2 89 f8 ff d1 85 c0 75 6b 66 83 be =
84
>>>> 00 00 00 00 75 04 <0f> 0b eb fe 8b 9e 90 00 00 00 85 db 75 1d ba 2=
0 00
>>>> 00 00 89 f8
>>>> Message from syslogd@zapazoid at Dec 17 07:39:06 ...
>>>> kernel:[50655.048019] EIP: [<f8c759de>] scsi_setup_fs_cmnd+0x3f/0x=
a4
>>>> [scsi_mod] SS:ESP 0068:c78c3ed0
>>>>
>>>>
>>>> This box has a Phenom II X6 (1035T??). I'm not exactly certain of =
the
>>>> model number.
>>>>
>>>> -davidc
