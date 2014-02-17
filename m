From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: New bcache compiler warning (was: Re: bcache: Minor fixes from
 kbuild robot)
Date: Mon, 17 Feb 2014 14:46:45 -0800
Message-ID: <20140217224645.GC11655@kmo>
References: <CAMuHMdUYZLv4X3VBEOgcf+Dr22Pi1xWx-6oMPX7usBk6HJHTMw@mail.gmail.com>
 <530279EC.5010605@infradead.org>
 <CAMuHMdUnCdEoyD+seYXJD+e4bED9=ceUCC7NYsoRa1_vc3g4Hw@mail.gmail.com>
 <20140217214553.GB11655@kmo>
 <530290DF.1060008@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <530290DF.1060008@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Feb 17, 2014 at 02:44:47PM -0800, Randy Dunlap wrote:
> Could that cause a truncation?  unsigned means unsigned int.
> Can unsigned int be smaller (fewer bits) than the k pointer?
> If so, is that OK or a problem?

It's just truncating the offset of the pointer within the struct bset, which is
part of a btree node - the thing that's being cast is restricted to be no bigger
than a btree node, which is at most a few mb.
