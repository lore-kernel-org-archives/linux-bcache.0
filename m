From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 1/5] bcache: don't write back data if reading it failed
Date: Wed, 27 Sep 2017 01:28:28 -0700
Message-ID: <CAJ+L6qf2YE=JzXV3ajNV6DvFzsUK8V0cbY+jen29UL-ky1RWag@mail.gmail.com>
References: <20170926192423.10665-1-mlyle@lyle.org> <5831212f-a002-42f5-6aa5-9dc13e2c90ba@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:37529 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751785AbdI0I2a (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Sep 2017 04:28:30 -0400
Received: by mail-qk0-f195.google.com with SMTP id r66so8331006qke.4
        for <linux-bcache@vger.kernel.org>; Wed, 27 Sep 2017 01:28:29 -0700 (PDT)
In-Reply-To: <5831212f-a002-42f5-6aa5-9dc13e2c90ba@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: linux-bcache@vger.kernel.org

SET_KEY_DIRTY sets it to false when bi_status is not 0.

We do the write if KEY_DIRTY is true, else it is skipped.

Mike

On Wed, Sep 27, 2017 at 1:22 AM, Coly Li <i@coly.li> wrote:
> On 2017/9/27 =E4=B8=8A=E5=8D=883:24, Michael Lyle wrote:
>> If an IO operation fails, and we didn't successfully read data from the
>> cache, don't writeback invalid/partial data to the backing disk.
>>
>> Signed-off-by: Michael Lyle <mlyle@lyle.org>
>> ---
>>  drivers/md/bcache/writeback.c | 19 +++++++++++++------
>>  1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback=
.c
>> index e663ca082183..eea49bf36401 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -179,13 +179,20 @@ static void write_dirty(struct closure *cl)
>>       struct dirty_io *io =3D container_of(cl, struct dirty_io, cl);
>>       struct keybuf_key *w =3D io->bio.bi_private;
>>
>> -     dirty_init(w);
>> -     bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
>> -     io->bio.bi_iter.bi_sector =3D KEY_START(&w->key);
>> -     bio_set_dev(&io->bio, io->dc->bdev);
>> -     io->bio.bi_end_io       =3D dirty_endio;
>> +     /* IO errors are signalled using the dirty bit on the key.
>> +      * If we failed to read, we should not attempt to write to the
>> +      * backing device.  Instead, immediately go to write_dirty_finish
>> +      * to clean up.
>> +      */
>> +     if (KEY_DIRTY(&w->key)) {
> Maybe it should be "if (!KEY_DIRTY(&w->key))" ? In dirty_endio(),
> SET_KEY_DIRTY() is called only when bio->bi_status is not 0.
>
>
>> +             dirty_init(w);
>> +             bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
>> +             io->bio.bi_iter.bi_sector =3D KEY_START(&w->key);
>> +             bio_set_dev(&io->bio, io->dc->bdev);
>> +             io->bio.bi_end_io       =3D dirty_endio;
>>
>> -     closure_bio_submit(&io->bio, cl);
>> +             closure_bio_submit(&io->bio, cl);
>> +     }
>>
>>       continue_at(cl, write_dirty_finish, io->dc->writeback_write_wq);
>>  }
>>
>
>
> --
> Coly Li
