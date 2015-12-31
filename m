From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PULL] Re: bcache stability patches
Date: Wed, 30 Dec 2015 20:25:36 -0700
Message-ID: <5684A030.1040306@kernel.dk>
References: <CAO2mnow-HG_0pnDVFGfU0e+hPXfT=zMTrdemwiv=pxgJ+m4o2w@mail.gmail.com>
 <alpine.LRH.2.11.1512291807510.30746@mail.ewheeler.net>
 <56841B8B.6070306@kernel.dk> <20151231031500.GA8265@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151231031500.GA8265@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, Al Viro <viro@zeniv.linux.org.uk>, Denis Bychkov <manover@gmail.com>, g2p.code@gmail.com, Jiri Kosina <jkosina@suse.com>, Joshua Schmid <jschmid@suse.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, stefan.bader@canonical.com, Takashi Iwai <tiwai@suse.de>, Vojtech Pavlik <vojtech@suse.com>, Zheng Liu <gnehzuil.liu@gmail.com>, Zheng Liu <wenqing.lz@taobao.com>
List-Id: linux-bcache@vger.kernel.org

On 12/30/2015 08:15 PM, Kent Overstreet wrote:
> On Wed, Dec 30, 2015 at 10:59:39AM -0700, Jens Axboe wrote:
>> Looking over these, most are really simple one-liners, and nothing sticks
>> out as being overly complicated. Kent, do you have any plans to maintain the
>> in-kernel bcache?
>
> Yeah - these patches are all fine, go ahead and pull.

Great, thanks.

> I may start doing maintainence again at some point (but if there's someone
> willing to step up and take over and do a good job of it, I'd gladly hand things
> off)

As long as we have a path into mainline for stability fixes, at least 
that's better than before.

Thanks Eric for collecting these. I've reformatted some of them a bit, 
not sure if that's github crappery, or if they came like that. It's 
pushed out now.

-- 
Jens Axboe
