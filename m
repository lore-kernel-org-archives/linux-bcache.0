From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: PostgreSQL licensed code on Linux
Date: Wed, 30 May 2018 03:10:18 +0300
Message-ID: <CAHp75Vf4AUrCbvsqaTZipC6xdHN=H+rRz1ACVkUpKzNQ4jbKbQ@mail.gmail.com>
References: <CAB=NE6XGCM0nZqvq74JPnSKgvL37Nkwvr3H3cAQ=ooTYJt7Rdg@mail.gmail.com>
 <20180529192643.GA3487@kmo-pixel> <20180529205143.GB7381@thunk.org>
 <20180529210025.GB3487@kmo-pixel> <20180529225928.GI31712@garbanzo.do-not-panic.com>
 <CAB=NE6XBPjcGCbK2L_ELjMVVSO34BeJQv8cSiC6M_r7MDVFLvQ@mail.gmail.com>
 <CAHp75Vefx7zwrn4CwhDYZrMSLdaaqta1uJHJrqD7c40MQ_N0ZA@mail.gmail.com> <20180530000321.GP4511@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530000321.GP4511@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Jessica Yu <jeyu@kernel.org>, Tso Ted <tytso@mit.edu>, Coly Li <colyli@suse.de>, Ciaran Farrell <ciaran.farrell@suse.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, linux-bcache@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Jonas Oberg <jonas@fsfe.org>
List-Id: linux-bcache@vger.kernel.org

On Wed, May 30, 2018 at 3:03 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Wed, May 30, 2018 at 02:22:14AM +0300, Andy Shevchenko wrote:
>> On Wed, May 30, 2018 at 2:12 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>> > It would seem I did follow up with a v3 patch and Rusty noted that although
>> > I may be right, its hard to care [0]. But of relevance here is again if one
>> > of the MODULE_LICENSE() dual tags should be used or the GPL tag. I'll
>> > continue to side recommending with the MODULE_LICENSE("GPL") tag even on
>> > files with permissive licenses, and even if it we haven't clarified this in
>> > documentation as I think scaling these tags further is just silly.
>> >
>> > [0] http://lkml.kernel.org/r/87bom0hf0f.fsf@rustcorp.com.au
>>
>> https://www.spinics.net/lists/linux-bcache/msg06048.html
>>
>> https://www.spinics.net/lists/linux-bcache/msg06058.html
>
> For those that are not developers:
>
> The proposed changes referenced in the above URLs take old portions PostgreSQL
> C code which were previously on a larger C file and move them to a new module
> which has the PostgreSQL header. Modules need to have a MODULE_LICENSE() tag,
> and if one is not used the kernel assumes the module is proprietary. The above
> code lacks a MODULE_LICENSE() tag as such currently the driver is proprietary.

Thanks for explaining this for audience.

> Clearly that needs to be fixed before upstreaming.

Yes, that's why Coly deferred the change for getting clear with licenses.

-- 
With Best Regards,
Andy Shevchenko
