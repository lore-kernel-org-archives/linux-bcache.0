From: Jason Warr <jason-/cow75dQlsI@public.gmane.org>
Subject: Re: bcache vs enhanceio?
Date: Tue, 19 Feb 2013 10:47:26 -0600
Message-ID: <5123AC9E.3050209@warr.net>
References: <5114334D.7040709@networklabs.co.nz> <23363144.24.1360701679980.JavaMail.root@zimbra> <20130212215629.GJ27179@google.com> <CAOzFzEiLeW=nvuwcrVrs2xO__92ze7b6BDt8MkAkaNctuSR9Vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEiLeW=nvuwcrVrs2xO__92ze7b6BDt8MkAkaNctuSR9Vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roy Sigurd Karlsbakk <roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org>, Andrew Thrift <andrew-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org


>>> Also, if running in writethrough, why shouldn't an SSD be allowed to be added in realtime?
>> If you're running in writethrough, you'd already be caching... not sure
>> what you mean?

Perhaps he means being restricted to only being able to add a write-through cache without the superblock prep?  On a reboot or cache device fault event it would not cause any corruption, just performance impact back to where it was before the device was added.
