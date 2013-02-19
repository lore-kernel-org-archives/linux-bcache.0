From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: bcache vs enhanceio?
Date: Wed, 20 Feb 2013 02:33:36 +1100
Message-ID: <CAOzFzEjM=9Nx4WUXd2ZzxDpBmKkLskX=Baz=SuUhKSAj4UJaVQ@mail.gmail.com>
References: <5114334D.7040709@networklabs.co.nz>
	<23363144.24.1360701679980.JavaMail.root@zimbra>
	<20130212215629.GJ27179@google.com>
	<CAOzFzEiLeW=nvuwcrVrs2xO__92ze7b6BDt8MkAkaNctuSR9Vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEiLeW=nvuwcrVrs2xO__92ze7b6BDt8MkAkaNctuSR9Vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roy Sigurd Karlsbakk <roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org>, Andrew Thrift <andrew-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> Looking through the enhanceio repo it seems possible to do it without
> a superblock by utilizing customized udev rules.
> Said rules prevent the backing device from being using to mount the
> root filesystem before the cache is attached.

Just to folow up with the udev config mentioned:
https://github.com/stec-inc/EnhanceIO/tree/master/Documents

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
