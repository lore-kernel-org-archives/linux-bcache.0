From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 14/17] bcache: back to cache all readahead I/Os
Date: Fri, 24 Jan 2020 08:48:23 -0800
Message-ID: <CAJ+L6qdThUX-Lk5T7-_xw-8KTtR73-Cbxj+oSr0n_tmth5EM+A@mail.gmail.com>
References: <20200123170142.98974-1-colyli@suse.de> <20200123170142.98974-15-colyli@suse.de>
 <CAJ+L6qckUd+Kw8_jKov0dNnSiGxxvXSgc=2dPai+1ANaEdfWPQ@mail.gmail.com> <efdfdd2b-b22e-42d1-c642-6c398db6864c@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <efdfdd2b-b22e-42d1-c642-6c398db6864c@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org, stable <stable@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

Hi Coly---

Thank you for holding the patch.  I'm sorry for the late review (I was
travelling).

(We sure have a lot of settings and a lot of code dealing with them
all, which is unfortunate... but workloads / hardware used with bcache
are so varied).

Mike

On Thu, Jan 23, 2020 at 9:28 AM Coly Li <colyli@suse.de> wrote:
>
> On 2020/1/24 1:19 =E4=B8=8A=E5=8D=88, Michael Lyle wrote:
> > Hi Coly and Jens--
> >
> > One concern I have with this is that it's going to wear out
> > limited-lifetime SSDs a -lot- faster.  Was any thought given to making
> > this a tunable instead of just changing the behavior?  Even if we have
> > an anecdote or two that it seems to have increased performance for
> > some workloads, I don't expect it will have increased performance in
> > general and it may even be costly for some workloads (it all comes
> > down to what is more useful in the cache-- somewhat-recently readahead
> > data, or the data that it is displacing).
>
> Hi Mike,
>
> Copied. This is good suggestion, I will do it after I back from Lunar
> New Year vacation, and submit it with other tested patches in following
> v5.6-rc versions.
>
> Thanks.
>
> Coly Li
>
> [snipped]
>
> --
>
> Coly Li
