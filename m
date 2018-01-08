From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v3] bcache: fix writeback target calc on large devices
Date: Mon, 8 Jan 2018 09:58:02 -0800
Message-ID: <CAJ+L6qe=Roiswb7DfRtCGk=FnE4JG9vesyVy6OyT8Ex+GgDTcA@mail.gmail.com>
References: <1515379587-21540-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1515379587-21540-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-block-owner@vger.kernel.org
To: Junhui Tang <tang.junhui@zte.com.cn>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Tang Junhui--

Thanks for your feedback, help, and flexibility.  I will try to make
this better overall in the long term.

On Sun, Jan 7, 2018 at 6:46 PM,  <tang.junhui@zte.com.cn> wrote:

> OK, please replace 16384 with macro, and replease 16384 * bdev_sectors(dc->bdev)
> with bit shift operation, eg: bdev_sectors(dc->bdev)<<MACRO.
>
> Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>

I have pulled this into bcache-for-next and will be testing it all
some today, hopefully to send out to linux-block/Jens late
today/tomorrow.

Mike
