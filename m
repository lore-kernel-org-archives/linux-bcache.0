From: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: full ssd for bcache or part?
Date: Thu, 24 Oct 2013 10:24:56 +0800
Message-ID: <526884F8.4080000@fnarfbargle.com>
References: <CACaajQscOOajT2A6MNpstALph8D=jqdvqifynYxxR4gTXrGTGQ@mail.gmail.com> <f46b2a85-6116-4dac-8acd-03007110cf4b@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f46b2a85-6116-4dac-8acd-03007110cf4b-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 10/24/2013 12:15 AM, Matthew Patton wrote:
> 25 to 30 percent reserve is strongly recommended for any write heavy workload. The performance improvement will blow your mind.
>
> A 240GB drive is a 256 with 7 percent reserve. Partition your device to 185 GB.

I thought (and maybe I'm wrong) that a good chunk of reserved space was 
essential to allow the drive to efficiently manage its read-modify-write 
cycles. It was my understanding that bcache was explicitly designed to 
fill erase block sized chunks sequentially and discard them in whole 
units, negating the requirement for the drive to actually perform RMW 
cycles and therefore negating the requirement for the extra free space.

Have I got it wrong?

Regards,
Brad
