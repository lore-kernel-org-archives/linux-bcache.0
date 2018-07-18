From: Noah Massey <noah.massey@gmail.com>
Subject: Re: [PATCH v3 3/3] lib/test_crc: Add test cases for crc calculation
Date: Wed, 18 Jul 2018 14:30:27 -0400
Message-ID: <CADfjVrg_oe1d5+3Hr3dv5fVpcA9jYP44B24LJS2_OsUFpnyB5g@mail.gmail.com>
References: <20180717145525.50852-1-colyli@suse.de> <20180717145525.50852-4-colyli@suse.de>
 <CADfjVriarrPnxixjun1g0m7izp4kMCvP4vXuPtNTth7_LWXrMA@mail.gmail.com> <CAHp75Ve7w8HxAcRXozsctFETuBtA0VD6jAsExEb6Wtq4UYRNAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75Ve7w8HxAcRXozsctFETuBtA0VD6jAsExEb6Wtq4UYRNAg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: andy.shevchenko@gmail.com
Cc: Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, gregkh@linuxfoundation.org, torvalds@linux-foundation.org, tglx@linutronix.de, kstewart@linuxfoundation.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Jul 17, 2018 at 4:59 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Tue, Jul 17, 2018 at 9:51 PM, Noah Massey <noah.massey@gmail.com> wrote:
> > On Tue, Jul 17, 2018 at 10:56 AM Coly Li <colyli@suse.de> wrote:
>
> >> +       if (err == 0)
> >> +               pr_info("test_crc: all %d tests passed\n", i);
> >
> > Similar to previous comment: we should not report the number of passed
> > tests, since adding a test would invalidate previous golden output.
> > Also, consider the situation where some tests are conditionally
> > executed depending on kconfig.
>
> We do similar in many test modules and I know at least two that had
> been changed in order to get new test cases.
> Are you proposing to change 'em all?
>

I was proposing that the message should be "test_crc: all tests
passed\n", since that would maintain a static expected output. Upon
further review, parsing minor variations in the messages is simple
enough so if the automated test tools already handle it keeping the
test count in the output is better.

Sorry for the noise,

~ Noah
