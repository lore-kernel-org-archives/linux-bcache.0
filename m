From: Adam Berkan <aberkan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache and SSD over provisioning
Date: Wed, 13 Nov 2013 10:23:51 -0800
Message-ID: <CAHYUNGZAp8_LNqTJ6ufnVjLEnK-8cn0SKYgtH+YpVw_ki2+ONQ@mail.gmail.com>
References: <CAC9WiBiuQ2zG6C9XJio-STz-ScnfzzYb+Rz23u6JW+vFni8PNA@mail.gmail.com>
 <op.w6hq4v0of3gqgg@desktop.patton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <op.w6hq4v0of3gqgg-r49W/1Cwd2cba4AQcYcrVKxOck334EZe@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Francis Moreau <francis.moro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Wed, Nov 13, 2013 at 6:13 AM, Matthew Patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, 13 Nov 2013 03:42:54 -0500, Francis Moreau <francis.moro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> wrote:
>
>> First I'd like to know if over-provisioning is still needed when
>> bcache is used ?
>
>
> it's needed for any decent, sustained write load if you don't want
> performance to crash thru the floor. But it doesn't sound like this is your
> use case. Are you sustaining 5000+ write IOPs?
>
>
>>   - Should I create 2 partitions with one left emtpy and whose size is
>> roughly 7% of the device size ?
>
bcache has a pretty flash friendly write pattern, so you probably
don't need a huge lot of empty space.  The 7% might in fact be enough,
but bumping it up to 10%-12% wouldn't hurt.  I think the >25% numbers
are more relevant for non-flash friendly writes (like random writes).
In that case you definitely want lots of free space.
>
> Your SSD already has 7% overprovisioning. For best sustained and consistent
> write performance you'll want to bump it to 25-30%. Yes you just need to
> partition/LVM down to the desired size.
>
>
>>   - Should I create a "Host Protected Area" by using hdparm ?
>
>
> http://www.thomas-krenn.com/en/wiki/SSD_Over-provisioning_using_hdparm
>
> Either take the precautions outlined in the WIKI given the penchant of the
> kernel to ignore such settings, or just remove the chance for error and
> partition the device instead.
>
>
>> And finally, can I create the over-provisioning without lost the
>> content of my backing device ?
>
>
> hell no.
>
> --
> NSA - subscribe to our Timeline and you'll know even before they've hit
> 'ENTER'
>
> "The budget should be balanced, the Treasury refilled, public debt reduced,
> the arrogance of officialdom tempered and controlled, and the assistance to
> foreign lands should be curtailed lest Rome become bankrupt. People must
> again learn to work, instead of living on public assistance."
>  - Cicero (55 BC)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
