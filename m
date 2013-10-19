From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: configuration for kvm vps on disk
Date: Sat, 19 Oct 2013 15:07:31 +0400
Message-ID: <CACaajQsxtpie2otXiG2P9S2bxMHg7=0sUr4eCWEixbgEkTakFA@mail.gmail.com>
References: <CACaajQt5FV=hLROyFtF-dQHpKzwq0guwwTonYjYF=q4MtW9q2Q@mail.gmail.com>
 <1382042170.70599.YahooMailNeo@web181502.mail.ne1.yahoo.com>
 <CACaajQtBmi_m4WuNUr9H4qXJg+dCrPtknat6EfX0A_kFAgBC+Q@mail.gmail.com>
 <CAFMg4WB5HtoDZPuMwngZXz-61Z-UVdFdK9gTi-8AbzEv0tY+uA@mail.gmail.com>
 <CACaajQsxLihiWDi98z1dck6x10PQO=hi8UMZ117S9dmJ3GSqXA@mail.gmail.com>
 <CAFMg4WCejoR0AojENfc1YwLwfMD-_c0Wwdh2tVyANv0w+5no1g@mail.gmail.com>
 <CACaajQuMLQxZTsMZctnrno2X_8K5VYwGwpif5idrK76bErO+KQ@mail.gmail.com> <1382180418.2404.2.camel@ThinkPad-X230.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382180418.2404.2.camel-aTCQVLFAsbFNyYP8qUDXA8/Rnsmy/zvw/z7RTEddyNg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Igor Gnatenko <i.gnatenko.brain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

2013/10/19 Igor Gnatenko <i.gnatenko.brain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>
> http://pkgs.fedoraproject.org/cgit/bcache-tools.git/tree/
>
> Take a look tracking bug[1] for more bugs and fixes..
>
> [1]https://bugzilla.redhat.com/show_bug.cgi?id=998543


Thanks. As i see this is only tools patches, that i don't need =). I'm
once create bcache and register it when node starts.
Does it possible to cache in memory some operations on lvm volume?
When i'm testing vps on ext4 can create 53000 iops on random write
opposite of lvm 43000... but in case of ext4 i have 2Gb cached on
host, while in case of lvm only 500

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
