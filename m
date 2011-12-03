From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: New version up with fix for md and other block devices
Date: Fri, 2 Dec 2011 22:27:38 -0800
Message-ID: <CAH+dOx+Gha19fvZhVAGEhUAhYvT+mNdwhruqS67qTK05J5WSPQ@mail.gmail.com>
References: <20111121101402.GA17787@dhcp-172-18-216-138.mtv.corp.google.com>
	<4ED47771.9030309@fnarfbargle.com>
	<20111129063126.GA14194@dhcp-172-18-216-138.mtv.corp.google.com>
	<4ED48A64.4080406@fnarfbargle.com>
	<20111129075440.GB14194@dhcp-172-18-216-138.mtv.corp.google.com>
	<4ED4981E.6040501@fnarfbargle.com>
	<20111129084544.GA16225@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111129084544.GA16225-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Just reproduced it - raid10 did the trick.

I'll try and debug it this weekend.

On Tue, Nov 29, 2011 at 12:45 AM, Kent Overstreet
<koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Nov 29, 2011 at 04:30:22PM +0800, Brad Campbell wrote:
>> On 29/11/11 15:54, Kent Overstreet wrote:
>> >Ok, that's weird. It shouldn't be able to register the second time
>> >because the first register opens it exclusively, and the second open
>> >will fail with -EBUSY.
>>
>> Can reproduce it at will here.
>
> I don't doubt you, just surprised. I'll try it out first thing tomorrow.
> No reason I shouldn't be able to reproduce it.
>
>> I doubt its the driver as the RAID is on the same card as the single
>> drive I tested with last time.
>
> Ok, raid10 is the one I didn't test - I tried raid0 and 6 and those
> worked, but each raid layer has its own code to process bios so it
> sounds like there's a corner case we're tripping.
>
>> I can probably try some other RAID levels this evening if it would
>> help. I trashed the RAID recently anyway so I need to re-build it
>> from scratch.
>
> Let me see if I can reproduce it first, I'll try it first thing in the
> morning. Hopefully it'll be something easy.
>
> Were you running in passthrough mode or was caching on when you got the
> oops?
