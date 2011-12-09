From: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: New version up with fix for md and other block devices
Date: Fri, 09 Dec 2011 21:00:57 +0800
Message-ID: <4EE20689.90204@fnarfbargle.com>
References: <20111121101402.GA17787@dhcp-172-18-216-138.mtv.corp.google.com>	<4ED47771.9030309@fnarfbargle.com>	<20111129063126.GA14194@dhcp-172-18-216-138.mtv.corp.google.com>	<4ED48A64.4080406@fnarfbargle.com>	<20111129075440.GB14194@dhcp-172-18-216-138.mtv.corp.google.com>	<4ED4981E.6040501@fnarfbargle.com>	<20111206034553.GA25438@moria>	<CAC7rs0saVh=a587mNCTCJwbVi7-u7kRuXu6-pZuJ6CRs1AACsw@mail.gmail.com>	<CAC7rs0ttY4Ama4v7yTepVTc65TyCo3+T4aPFoHJW1CwA8mDuUA@mail.gmail.com>	<CAH+dOxLW71YKpC1YL61osFq6oDVWxoj4ajLht3EqMUiWTYogTA@mail.gmail.com>	<4EE16FED.5080809@fnarfbargle.com> <CAC7rs0tnhwAhQF53nTnHsdnnFOKpbG1BvAE5EcbbvsFWR-_6RA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC7rs0tnhwAhQF53nTnHsdnnFOKpbG1BvAE5EcbbvsFWR-_6RA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 09/12/11 18:01, Kent Overstreet wrote:
> Bah, that's what I get for being lazy. Should work now.
>
> Also, there's no need to re clone when I rebase - just do git reset
> --hard origin/bcache
>

Will do. It's never an extensive process anyway as I always --reference 
a local git tree, so it's only bcache that gets pulled.

I'll compile it up in the morning and run some tests.

Regards,
Brad
