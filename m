From: Francis Moreau <francis.moro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache and SSD over provisioning
Date: Wed, 13 Nov 2013 20:54:38 +0100
Message-ID: <5283D8FE.5000908@gmail.com>
References: <CAC9WiBiuQ2zG6C9XJio-STz-ScnfzzYb+Rz23u6JW+vFni8PNA@mail.gmail.com> <op.w6hq4v0of3gqgg@desktop.patton.net> <CAHYUNGZAp8_LNqTJ6ufnVjLEnK-8cn0SKYgtH+YpVw_ki2+ONQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHYUNGZAp8_LNqTJ6ufnVjLEnK-8cn0SKYgtH+YpVw_ki2+ONQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Berkan <aberkan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Le 13/11/2013 19:23, Adam Berkan a =E9crit :
> On Wed, Nov 13, 2013 at 6:13 AM, Matthew Patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> =
wrote:
>> On Wed, 13 Nov 2013 03:42:54 -0500, Francis Moreau <francis.moro@gma=
il.com>
>> wrote:
>>
>>> First I'd like to know if over-provisioning is still needed when
>>> bcache is used ?
>>
>>
>> it's needed for any decent, sustained write load if you don't want
>> performance to crash thru the floor. But it doesn't sound like this =
is your
>> use case. Are you sustaining 5000+ write IOPs?
>>
>>
>>>   - Should I create 2 partitions with one left emtpy and whose size=
 is
>>> roughly 7% of the device size ?
>>
> bcache has a pretty flash friendly write pattern, so you probably
> don't need a huge lot of empty space.  The 7% might in fact be enough=
,
> but bumping it up to 10%-12% wouldn't hurt.  I think the >25% numbers
> are more relevant for non-flash friendly writes (like random writes).
> In that case you definitely want lots of free space.

Thanks for your enlightment.

I'll probably go for 10%.
