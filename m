From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCHv4] bcache: only permit to recovery read error when cache
 device is clean
Date: Fri, 27 Oct 2017 13:00:18 -0700
Message-ID: <CAJ+L6qeSP6OLkaNBs1N0=D5=4hz3wDa2UcZfRSKHUM_rxZFpTQ@mail.gmail.com>
References: <20171016180428.123657-1-colyli@suse.de> <alpine.LRH.2.11.1710271955340.24585@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1710271955340.24585@mail.ewheeler.net>
Sender: stable-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Nix <nix@esperi.org.uk>, Kai Krakow <hurikhan77@gmail.com>, Junhui Tang <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Oct 27, 2017 at 12:57 PM, Eric Wheeler
<bcache@lists.ewheeler.net> wrote:
> Can this be relaxed to only error when the key failing to read is dirty?
> The liklihood of a 100% clean cache in writeback on a busy system seems
> unlikely.
>
> Can KEY_DIRTY facilitate this?

Don't we only have the metadata to know if the key is dirty on the
cache if we have the cache device? ;)

Mike
