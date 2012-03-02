From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache and dm targets (specifically lvm)
Date: Thu, 1 Mar 2012 22:44:11 -0800
Message-ID: <CAC7rs0us5Xqag_AWq=wsFYqn3Fub3qt59a9=vDeS5cLh2oOg0Q@mail.gmail.com>
References: <CAOzFzEjKapphA5NKCWbEyx4nvjWw+e_dxr+fOLr8f5j586jiyA@mail.gmail.com>
	<CAOzFzEjffLGjYhOznTo1F3moHLq+nvKYZFoy7mkU-q8RPDd9oQ@mail.gmail.com>
	<CAC7rs0vpQAaF9uNhhy2ziLa+3EB6udJVRjGwf=RVoSk0TxuDcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC7rs0vpQAaF9uNhhy2ziLa+3EB6udJVRjGwf=RVoSk0TxuDcw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Oh - try stracing the pvcreate and see what happens.

On Thu, Mar 1, 2012 at 10:03 PM, Kent Overstreet
<kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Weird.
>
> Did the /dev/bcache0 device get create created by udev?
>
> It's possible my code isn't poking the right thing. *mutters about th=
e
> block layer...*
>
> On Thu, Mar 1, 2012 at 9:49 PM, Joseph Glanville
> <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org> wrote:
>> Hi,
>>
>> I can't use bcache devices as members of lvm volume groups because
>> dmsetup can't find the devices.
>> It provides the ever useful feedback of:
>> # pvcreate /dev/bcache0
>> =A0 Device /dev/bcache0 not found (or ignored by filtering).
>>
>> My LVM.conf is only filtering out nbd devices:
>> filter =3D [ "r|/dev/nbd.*|", "a/.*/" ]
>>
>> Any insight would be greatly appreciated. :)
>>
>> I also noted that bcache devices don't appear in iostat..
>>
>> Joseph.
>>
>> --
>> Founder | Director | VP Research
>> Orion Virtualisation Solutions=A0|=A0www.orionvm.com.au=A0| Phone: 1=
300 56
>> 99 52 | Mobile: 0428 754 846
>>
>>
>> --
>> Founder | Director | VP Research
>> Orion Virtualisation Solutions=A0|=A0www.orionvm.com.au=A0| Phone: 1=
300 56
>> 99 52 | Mobile: 0428 754 846
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcac=
he" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
