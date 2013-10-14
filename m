From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Oct 14 (bcache)
Date: Mon, 14 Oct 2013 11:58:10 -0700
Message-ID: <525C3EC2.20404@infradead.org>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1381762088-18880-1-git-send-email-treding@nvidia.com>
Sender: linux-next-owner@vger.kernel.org
To: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Kent Overstreet <kmo@daterainc.com>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 10/14/13 07:48, Thierry Reding wrote:
> Hi all,
> 
> I've uploaded today's linux-next tree to the master branch of the
> repository below:
> 
>         git://gitorious.org/thierryreding/linux-next.git
> 
> A next-20131014 tag is also provided for convenience.
> 
> Gained a few conflicts, but nothing too exciting. x86 and ARM default
> configurations build fine. There were some build failures unrelated to

Maybe you could build allmodconfig instead of a default config
for more better coverage?  I am seeing lots of build problems.

> the merge, most of which I fixed and added as patches on top of the
> final merge.


on x86_64:

drivers/md/bcache/request.c: In function 'cached_dev_write':
drivers/md/bcache/request.c:1076:8: error: 'struct btree_op' has no member named 'cache_bio'


-- 
~Randy
