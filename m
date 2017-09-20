From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCHv2] bcache: option for allow stale data on read failure
Date: Wed, 20 Sep 2017 08:40:00 -0700
Message-ID: <CAJ+L6qc_U_37Jn=wzcXoLU6dHWHQyRJGTACDtmctAn1Gg08keA@mail.gmail.com>
References: <20170919222433.24336-1-colyli@suse.de> <CAJ+L6qeLMsCAVsdNkertg2BzwVHcq4ZZ==E8gojo9O2cutWrVQ@mail.gmail.com>
 <db997d70-9d0d-fd27-1c7c-7f602499aea4@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <db997d70-9d0d-fd27-1c7c-7f602499aea4@suse.de>
Sender: stable-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Nix <nix@esperi.org.uk>, Kai Krakow <hurikhan77@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, Junhui Tang <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Sep 20, 2017 at 3:28 AM, Coly Li <colyli@suse.de> wrote:
> Even the read request failed on file system meta data, because finally a
> stale data will be provided to kernel file system code, it is probably
> file system won't complain as well.

The scary case is when filesystem data that points to other filesystem
data is cached.  E.g. the data structures representing what space is
free on disk, or a directory, or a database btree.  Some examples:

Free space handling-- if a big file /foo is created, and the active
free-space datastructures are in cache (and this is likely, because
actively written places can have their writeback-writes
cancelled/deferred indefinitely)-- and then later the caching disk
fails, an old version of this will be read from disk.  Later, an
effort to write a file /bar allocates the space used by /foo, and
writes over it.

Directory entity handling-- if /var/spool/foo is an active directory
(associated data structures in cache), and has the directory
/var/spool/foo/bar under it, and then /bar is removed... the backing
disk will still have a reference to bar.  If the space for bar is then
used for something else, the kernel may end up reading something very
different from what it expects for a directory later after a cache
device failure.

Btrees, etc-- the same thing.  If a tree shrinks, old tree entitys can
end up pointing to other kinds of data.

I think this change is harmful-- it is not a good idea to
automatically, at runtime, decide to start returning data that
violates the guarantees a block device is supposed to obey about
ordering and persistence.

Mike
