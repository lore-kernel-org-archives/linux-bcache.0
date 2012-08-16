From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: Kernel panic with current bcache-3.2 branch.
Date: Thu, 16 Aug 2012 21:34:02 +1000
Message-ID: <CAOzFzEim7Q7eDr2z=BNsgnUuYH-XJaCPYpeVt5zkE1kvxZn+RQ@mail.gmail.com>
References: <CAOzFzEiS3MWe39C+XinBP3fN-Kw8Hs6n3oyqixrMVZpsuMhLcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEiS3MWe39C+XinBP3fN-Kw8Hs6n3oyqixrMVZpsuMhLcw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

I am able to trigger this reliably and I have also confirmed it
doesn't occur with the version of the code we are running. (which
unfortunately I don't have the commit from. :( )
In my wisdom I imported the bcache code as a big single commit into our tree.
I can take the diff of a file for you to try help track down which
commit it was if that helps.

Joseph.
