From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker merged)
Date: Sat, 29 Jun 2019 17:39:24 +0100
Message-ID: <CAPweEDxufL1SHCh2ao7600fF9+aciMhr2V_5vxQN6S8r=u2W4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, axboe@kernel.dk, darrick.wong@oracle.com, david@fromorbit.com, dchinner@redhat.com, josef@toxicpanda.com, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, tj@kernel.org, viro@zeniv.linux.org.uk, zach.brown@ni.com
List-Id: linux-bcache@vger.kernel.org

hey linus, you made news again, all blown up and pointless again.
you're doing great: you're being honest. remember the offer i made to
put you in touch with my friend.

anecdotal story: andrew tridgell worked on the fujitsu sparc
supercomputer a couple decades ago: it had a really weird DMA ring
bus.

* memory-to-memory copy (in the same core) was 10mbytes/sec
* DMA memory-to-memory copy (in the same core) was 20mbytes/sec
* memory-memory copy (across the ring bus i.e. to another machine) was
100mbytes/sec
* DMA memory-memory copy (across the ring bus) was *200* mbytes/sec.

when andrew tried asking people, "hey everyone, we need a filesystem
that can work really well on this fast parallel system", he had to
continuously fend off "i got a great idea for in-core memory-to-memory
cacheing!!!!" suggestions, because they *just would never work*.

the point being: caches aren't always "fast".

/salutes.

l.
