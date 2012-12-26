From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Journal question
Date: Wed, 26 Dec 2012 10:32:17 -0800
Message-ID: <20121226183217.GA20185@google.com>
References: <50D8961A.1010703@cslab.ece.ntua.gr>
 <50D8A306.8050109@cslab.ece.ntua.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50D8A306.8050109-Hpc4xzY4zrDSDkk6z29a7FAUjnlXr6A1@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Pyrgiotis <apyrgio-Hpc4xzY4zrDSDkk6z29a7FAUjnlXr6A1@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Dec 24, 2012 at 08:46:30PM +0200, Alex Pyrgiotis wrote:
> Hi Kent,
> 
> I was reading the code documentation on your site, and I saw that
> you have written this:
> 
> "... In the future, the journal will contain a strong checksum of
> the data so that the write will complete when the journal entry
> finishes..."

I think that was poorly worded. The idea is that if the pointer has a
data checksum, we can allow the journal entry to be written before all
the data it points to has been written, and then on recovery we can
figure out if we should replay keys in the journal entry by checking if
the checksums match (which means the data write did finish).

> My question is, is this feature implemented?

Nah, would need to finish data checksumming first. I'm also not sure
it's really worth implementing, since awhile back I made it so only
cache flushes wait on journal writes... in the absence of cache flushes
we only write journal entries every ~100 ms by default.

Since cache flushes have to wait on outstanding data writes anyways it
wouldn't buy us much, it'd just let the data writes and journal write go
in parallel.

> As far as I can see by
> looking at journal.c, you are journaling only the keys and not the
> data they point to (it has been issued asynchronously a few steps
> back to the SSD, right?).

Yup, that's correct.

> Also, if this is a feature to be implemented, wouldn't it create
> more stress on the CPUs, as well as more latency to issue the IO
> request to the SSDs (unless you issue it asynchronously while
> processing the keylist)?
> 
> I'm just curious on how you'd handle it.

Not really, crc32c is ridiculously fast since it's implemented in
hardware and the 64 bit checksum bcache uses for some stuff is also
plenty fast. The checksumming overhead would only be noticable if we
were using something like sha1 (and there's advantages to using a crc
instead of a cryptographic hash - you can merge crcs (which we'd want to
do when merging extents), you can't merge cryptographic hashes).
