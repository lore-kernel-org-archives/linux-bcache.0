From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [GIT] Bcache version 12
Date: Thu, 15 Sep 2011 15:07:30 -0700
Message-ID: <CAC7rs0tSPAwC4WGWPn6t3H0hq_tB06nK-PA2KXLK+bWwTs+81Q@mail.gmail.com>
References: <20110910064531.GA32536@moria>
	<CAA9_cmdCg4UJrzYBzcrhD61PZ6hfrGWbF2A05LPo9WD55874uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmdCg4UJrzYBzcrhD61PZ6hfrGWbF2A05LPo9WD55874uw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net, axboe@kernel.dk, akpm@linux-foundation.org, neilb@suse.de
List-Id: linux-bcache@vger.kernel.org

On Thu, Sep 15, 2011 at 3:03 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> Does it consider the raid5/6 write hole in what it caches? =A0Guess I
> need to take a look at the code, but just wondering if it considers
> the need to maintain a consistent strip when writing back to raid5/6
> array, or would there still be a need for a separate driver/region of
> the SSD for caching that data.

Do you mean - if you're caching a raid5 (not the individual devices,
the entire array) the parity blocks?

In that case no, bcache will never see them. However, if you're doing
writeback caching that won't be a huge problem since you'll end up
with more full stripe writes.
