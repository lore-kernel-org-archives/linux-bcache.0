From: Matthew Patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: full ssd for bcache or part?
Date: Wed, 23 Oct 2013 12:15:35 -0400
Message-ID: <f46b2a85-6116-4dac-8acd-03007110cf4b@email.android.com>
References: <CACaajQscOOajT2A6MNpstALph8D=jqdvqifynYxxR4gTXrGTGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQscOOajT2A6MNpstALph8D=jqdvqifynYxxR4gTXrGTGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

25 to 30 percent reserve is strongly recommended for any write heavy workload. The performance improvement will blow your mind.

A 240GB drive is a 256 with 7 percent reserve. Partition your device to 185 GB. 
