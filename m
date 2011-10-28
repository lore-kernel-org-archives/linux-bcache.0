From: Damien Churchill <damoxc@gmail.com>
Subject: Re: Crash when trying to mount ext4
Date: Fri, 28 Oct 2011 12:49:48 +0100
Message-ID: <CAFtEh-c7CA4aidt=1m_Zf8+sd3hxvLLcjC1A7qZ2zcqiDfbcBQ@mail.gmail.com>
References: <CAFtEh-dPs+3foczt0Cjs=gWu42as=scALPAfJo+QPK+C3fRUbg@mail.gmail.com>
	<CAC-hyiFAv1-HeFiX3MtOJwxbNyAAQp_CMpzDv0A7-Woo3+qKdA@mail.gmail.com>
	<CAFtEh-dfsWQZ-Dpy8zAjK8Be=XfOqsBj4x3CU-G3AA7NYq8tSA@mail.gmail.com>
	<CAC-hyiE8+xugo-ZtG=i7vJQTKOZCqkiD0Xj2Y6_uvoX1T2MaBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAC-hyiE8+xugo-ZtG=i7vJQTKOZCqkiD0Xj2Y6_uvoX1T2MaBQ@mail.gmail.com>
Sender: ceph-devel-owner@vger.kernel.org
To: Yehuda Sadeh Weinraub <yehudasa@gmail.com>
Cc: linux-bcache@vger.kernel.org, ceph-devel <ceph-devel@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On 28 October 2011 04:17, Yehuda Sadeh Weinraub <yehudasa@gmail.com> wrote:
> On Thu, Oct 27, 2011 at 1:51 PM, Damien Churchill <damoxc@gmail.com> wrote:
>> On 27 October 2011 17:25, Yehuda Sadeh Weinraub <yehudasa@gmail.com> wrote:
>>> On Thu, Oct 27, 2011 at 5:59 AM, Damien Churchill <damoxc@gmail.com> wrote:
>>>> Hi,
>>>>
>>>> I've been testing bcache with the latest sources from the git tree.
>>>> I've been attempting to use a rbd (RADOS block device) as the backing
>>>> device. I can format the bcache0 device with mkfs.ext4, however when I
>>>> mount it, there is a kernel bug when it attempts to initialize the
>>>> filesystem.
>>>>
>>>> I'm unsure if this is a bug in rbd or bcache however, I'm including
>>>> the stack trace outputted by the kernel. The kernel has been based off
>>>> the current Ubuntu Precise kernel (3.1.0) patched with the changes
>>>> from the bcache git repository as well as the changes from the ceph
>>>> repository in for-next (the same thing happened without the changes
>>>> from the ceph repository). bcache does function as expected when using
>>>> a raw disk drive.
>>>>
>>>
>>> Can you push a tree somewhere that has the exact kernel that you're
>>> using, patched with the specific bcache version? It'll make it easier
>>> for us to look at the issue.
>>>
>>> Thanks,
>>> Yehuda
>>>
>>
>> Certainly, I've pushed it up to github,
>> https://github.com/damoxc/linux.git. It's in the branch "testing".
>>
>
> I was able to reproduce the issue. It seems that bcache creates bios
> without invoking the merge_bvec callback (which we implement), so we
> end up with a request that holds pages that exceed the rbd block
> boundaries. The call to bio_split then crashes as it shouldn't have
> more than a single page trailing outside. So it's either a problem in
> bcache that doesn't call that callback, or an issue with rbd code that
> assumes that it'll always be called. A relatively quick workaround for
> rbd would be to create a special bio_split function that would do the
> required splitting for this case, but I'm not sure whether that would
> be the proper solution. If that's a bcache oversight and not an
> incorrect assumption I'd rather leave it for bcache.
>

Thanks a lot for looking. I agree that it should be fixed in the
correct place instead of a workaround being implemented. I will try
and have a look at the bcache code to see if I can spot anything and
whip up a patch.

Thanks again,
Damien
