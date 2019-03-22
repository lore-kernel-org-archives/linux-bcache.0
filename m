From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bcache: Zero initialize bucket in bch_allocator_thread
Date: Fri, 22 Mar 2019 15:36:12 +0100
Message-ID: <CAK8P3a24tM1SB+gy1P9jdJ4077=DtOmgLvMLuNa9cj9RZGdxBg@mail.gmail.com>
References: <20190307221054.13126-1-natechancellor@gmail.com> <94c7f399-7101-2297-43e0-834f50c3510f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94c7f399-7101-2297-43e0-834f50c3510f@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Nathan Chancellor <natechancellor@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, clang-built-linux@googlegroups.com, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-bcache@vger.kernel.org

On Fri, Mar 8, 2019 at 3:11 AM Coly Li <colyli@suse.de> wrote:
> On 2019/3/8 6:10 上午, Nathan Chancellor wrote:
> > When building with -Wsometimes-uninitialized, Clang warns:
> >
> > drivers/md/bcache/alloc.c:333:4: warning: variable 'bucket' is used
> > uninitialized whenever 'if' condition is false
> > [-Wsometimes-uninitialized]
> >
> > fifo_pop expands to a conditional depending on '!fifo_empty(...)', which
> > is the same condition as the while loop. It seems Clang can't piece
> > together that this condition will never been false as long as we are in
> > the while loop because they are the same condition. It's easy enough to
> > silence this warning by just explicitly zero initializing bucket.
> >
> > Link: https://github.com/ClangBuiltLinux/linux/issues/396
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>
> Hi Nathan,
>
> Nice catch, I will add it to my for-test. Thanks.

I saw the same warning but came up with a nicer (IMHO) fix, see
https://lore.kernel.org/lkml/20190322143507.1256436-1-arnd@arndb.de/T/#u

        Arnd
