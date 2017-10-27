From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCHv4] bcache: only permit to recovery read error when cache
 device is clean
Date: Fri, 27 Oct 2017 16:36:13 -0700
Message-ID: <CAJ+L6qdA8zE+Za2xgV7J7hSY8B9Qt4f_=6-vbP+6MHns+H9vpg@mail.gmail.com>
References: <20171016180428.123657-1-colyli@suse.de> <alpine.LRH.2.11.1710271955340.24585@mail.ewheeler.net>
 <CAJ+L6qeSP6OLkaNBs1N0=D5=4hz3wDa2UcZfRSKHUM_rxZFpTQ@mail.gmail.com>
 <alpine.LRH.2.11.1710272111120.24585@mail.ewheeler.net> <CAJ+L6qdZekS4hTFwXG6oSHuXEuVODW1PRWh3j62RJDMWj9EXgw@mail.gmail.com>
 <alpine.LRH.2.11.1710272310510.24585@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1710272310510.24585@mail.ewheeler.net>
Sender: stable-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Nix <nix@esperi.org.uk>, Kai Krakow <hurikhan77@gmail.com>, Junhui Tang <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Oct 27, 2017 at 4:31 PM, Eric Wheeler <bcache@lists.ewheeler.net> wrote:
>> Seems like something that's a lot of effort for little gain.  It'll
>> only help when A) everything you need isn't dirty, and
>
> Indeed!
>
>> B) all the associated btree nodes are in memory.
>
> Is the dirty key map not memory resident?

The overall bcache btree says where stuff is resident and whether it's
dirty.  It is stored on disk and portions of it are cached in memory.

If data is hot, the relevant tree nodes are likely to be in memory,
but the data is also more likely to be dirty.

Mike
