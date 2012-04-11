From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Resizing bcache backing store
Date: Wed, 11 Apr 2012 19:55:54 -0400
Message-ID: <CAH+dOxJv-ajvLfbUSo8dqG0a8_grNBhfxJ1EbmSrYZz0YXJM2w@mail.gmail.com>
References: <CAB7K1hH_o7koST7RYTbw9ya0GMEvmpb=TYAt1MqEVDhtBdRd1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAB7K1hH_o7koST7RYTbw9ya0GMEvmpb=TYAt1MqEVDhtBdRd1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rhodes Clymer <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

=46or the backing device, I think things will just work - you'll just
have to close and reopen the backing device in order for bcache to
notice the new size. Bcache's superblock doesn't remember the size, it
just goes off of what the size of the backing device is when it's
registered.

There's currently no way to make bcache notice the backing device has
grown to do it at runtime, though that ought to be fairly simple too.

On Wed, Apr 11, 2012 at 6:47 PM, David Rhodes Clymer
<david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org> wrote:
> In the case where the bcache backing store is resizeable (eg. a
> logical volume), is it possible to resize the backing store without
> breaking bcache? Let's say, for example, that I would
> unmount/unregister /dev/bcacheX, resize the backing store,
> reregister/remount the cache.
>
> I imagine a better approach would be to layer LVM on the cache device
> itself. However, in this particular case, I set up the bcache before =
I
> had learned how to get LVM to use a bcache device as a PV.
>
> -davidc
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
