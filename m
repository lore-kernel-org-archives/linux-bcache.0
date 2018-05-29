From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: PostgreSQL licensed code on Linux
Date: Tue, 29 May 2018 16:12:17 -0700
Message-ID: <CAB=NE6XBPjcGCbK2L_ELjMVVSO34BeJQv8cSiC6M_r7MDVFLvQ@mail.gmail.com>
References: <CAB=NE6XGCM0nZqvq74JPnSKgvL37Nkwvr3H3cAQ=ooTYJt7Rdg@mail.gmail.com>
 <20180529192643.GA3487@kmo-pixel> <20180529205143.GB7381@thunk.org>
 <20180529210025.GB3487@kmo-pixel> <20180529225928.GI31712@garbanzo.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529225928.GI31712@garbanzo.do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, Jessica Yu <jeyu@kernel.org>
Cc: Tso Ted <tytso@mit.edu>, Coly Li <colyli@suse.de>, Ciaran Farrell <ciaran.farrell@suse.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, linux-bcache@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Jonas Oberg <jonas@fsfe.org>
List-Id: linux-bcache@vger.kernel.org

It would seem I did follow up with a v3 patch and Rusty noted that although
I may be right, its hard to care [0]. But of relevance here is again if one
of the MODULE_LICENSE() dual tags should be used or the GPL tag. I'll
continue to side recommending with the MODULE_LICENSE("GPL") tag even on
files with permissive licenses, and even if it we haven't clarified this in
documentation as I think scaling these tags further is just silly.

[0] http://lkml.kernel.org/r/87bom0hf0f.fsf@rustcorp.com.au

   Luis
