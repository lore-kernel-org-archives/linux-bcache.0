From: Alex Pyrgiotis <apyrgio-Hpc4xzY4zrDSDkk6z29a7FAUjnlXr6A1@public.gmane.org>
Subject: Re: Bcache Journal
Date: Mon, 29 Oct 2012 23:47:59 +0200
Message-ID: <508EF98F.5040209@cslab.ece.ntua.gr>
References: <508D5B43.4040504@cslab.ece.ntua.gr> <20121029204330.GA14917@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121029204330.GA14917-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 10/29/2012 10:43 PM, Kent Overstreet wrote:
> On Sun, Oct 28, 2012 at 06:20:19PM +0200, Alex Pyrgiotis wrote:
>> Hi,
>>
>> In the wiki, it is mentioned that bcache can run either with or
>> without a journal.
>> What I'd like to ask is which is the default bcache configuration
>> (journal on|off?) and is there an option in the make-bcache tool to
>> change this configuration?
> That's out of dat... What page did you find that on? Running without a
> journal hasn't been an option in ages...
Hi Kent,

Here's the link: http://bcache.evilpiepirate.org/Design#Journal
The out-dated part is "It is possible to create cache devices..."
>
> (You wouldn't want to run without the journal, it's there to improve
> performance)
Yeah, I know. Just wanted to have a look at bcache's knobs and switches...
Thanks again. :-)
