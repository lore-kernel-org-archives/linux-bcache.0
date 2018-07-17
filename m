From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v3 3/3] lib/test_crc: Add test cases for crc calculation
Date: Tue, 17 Jul 2018 23:59:38 +0300
Message-ID: <CAHp75Ve7w8HxAcRXozsctFETuBtA0VD6jAsExEb6Wtq4UYRNAg@mail.gmail.com>
References: <20180717145525.50852-1-colyli@suse.de> <20180717145525.50852-4-colyli@suse.de>
 <CADfjVriarrPnxixjun1g0m7izp4kMCvP4vXuPtNTth7_LWXrMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADfjVriarrPnxixjun1g0m7izp4kMCvP4vXuPtNTth7_LWXrMA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Noah Massey <noah.massey@gmail.com>
Cc: Coly Li <colyli@suse.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

On Tue, Jul 17, 2018 at 9:51 PM, Noah Massey <noah.massey@gmail.com> wrote:
> On Tue, Jul 17, 2018 at 10:56 AM Coly Li <colyli@suse.de> wrote:

>> +               pr_info("test_crc: %s: PASSED:(0x%016llx, expected 0x%016llx)\n",
>> +                       name, crc, expval);
>
> I don't think we should have specific kernel output for passed tests.
> If a new test is added which follows this pattern, the 0-day will fail
> because the kernel output would change. Along the lines of "silence is
> golden", if no test hit the error output, we're good.

Agree.

>> +       if (err == 0)
>> +               pr_info("test_crc: all %d tests passed\n", i);
>
> Similar to previous comment: we should not report the number of passed
> tests, since adding a test would invalidate previous golden output.
> Also, consider the situation where some tests are conditionally
> executed depending on kconfig.

We do similar in many test modules and I know at least two that had
been changed in order to get new test cases.
Are you proposing to change 'em all?

-- 
With Best Regards,
Andy Shevchenko
