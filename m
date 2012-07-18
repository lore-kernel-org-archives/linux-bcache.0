From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache repo down?
Date: Wed, 18 Jul 2012 15:15:58 -0700
Message-ID: <CAC7rs0v-Yo9WMkS7wY5S+wPVyegSRkPyB9Ata-bJritQx2NjeQ@mail.gmail.com>
References: <CACuCnRu1wM=o+CXW_4Js3OiohwVr6WjTbcXOw=bjrhgUbzLGJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACuCnRu1wM=o+CXW_4Js3OiohwVr6WjTbcXOw=bjrhgUbzLGJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Todd Daugherty <todd1794-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Git clone over the git protocol uses ridiculous amounts of memory.
I've given up trying to repack the repository to keep it working - git
clone over dumb http works, though:

git clone http://evilpiepirate.org/git/linux-bcache.git

On Sat, Jul 14, 2012 at 2:32 AM, Todd Daugherty <todd1794-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> git clone git://evilpiepirate.org/~kent/linux-bcache.git
> Cloning into 'linux-bcache'...
> remote: fatal: Out of memory, realloc failed
> remote: aborting due to possible repository corruption on the remote side.
> fatal: early EOF
> fatal: index-pack failed
