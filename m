Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C8554654;
	Tue,  3 Mar 2026 00:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772499449; cv=fail; b=CrJoKGoyHwCB6RIQ+8CoUKiTMjVlVLE+v3UY/dhmOepfPE+23e1Z19QqCKiV8negyjZ0sEfIlg8eBZ6UPmPtMiKm3kh7/UqM/uIUoOHFbL/CGk7N1ngINtJxhdT/NajclsFR5y6T9QZZ6FRp8cYsSjCthArx0KxBu6A3I9ZUgHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772499449; c=relaxed/simple;
	bh=3cyVj2yAHe8jycLCXObbwdmJxiXV+/fYN5PCe/8VfnA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dmf2gHeEf5dX256VIg9gn5goIhAFOI2V60heYOIFIrNB+6tMcd/QuGGywagFlq/9zDNR6PWU+K/WJmT6+XCqe/xIP30mEZDSkO/e5Euz2YYrq2tRsvhT2oPlaIveQ+b4iRZDynq2s5YC8ci87mKszWw7HCG8SRuiqgsGW6gb7zM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mZc5Yv9+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ArknyVga; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mZc5Yv9+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ArknyVga"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772499448; x=1804035448;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3cyVj2yAHe8jycLCXObbwdmJxiXV+/fYN5PCe/8VfnA=;
  b=mZc5Yv9+Ap5EUJ3JssG378kqyk4Qnf9GGa+ht5Zo4RMyJcjUO3SdjMtb
   cVaIv5D1iOxVfVyuokEWw0b+4KoZBQonWpTZ005wbavp7FRNaDwVj3zcd
   Rfn01z8BanuSgx8ZjJr1NElVA+mKEp6s+BMHFDEPO4YWjzwu979GpWm60
   ga0WMO8cVY3LBu/YJuwhGvJR3KtuvmT3gRw6kvpVEyEmN7MjPiXLsZH2T
   fxiGbuVez2rUk+prdwFklpRZYikgZ5mcUN8UhKIjzPjeZb+a5hPwMK8jy
   IC55B6+EdxHf3wai1EFiBl0jUm+gJKTBvKNBWgvCVapZ5xQQXyjwJDBtg
   Q==;
X-CSE-ConnectionGUID: s3vY0dTlQtWB4zemG+w07Q==
X-CSE-MsgGUID: 9dwe/e0HS62uXbG0QjA8zg==
X-IronPort-AV: E=Sophos;i="6.21,321,1763395200"; 
   d="scan'208";a="140811241"
Received: from mail-centralusazon11011033.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.33])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Mar 2026 08:57:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=caVaxBPWom03Xw+KdE0owrPmJmNORDPoONl4kKlX+je2dxbs5X+H0HTkrfxCeSkwAE8WFdbVVez0ygvb6k8SQOzRqEuFl08nQgGnHQgVNTC3xjeLyBCD3wSsqP1sETM+zdi6Ositv0yWYLLkfZl2kUXSucV0ihG9XEquyk2/xYhxU9bMVg9+bow3G8PQ1Z6gEzHayimGwUVKOZW0cQcWasUjSfCJ1z0Fn8+VX8yrs/d3qGUcZEvPbJbs7Rm7OSmCqYZz3oQNjYikNYI8BUWOhsK+1qDdmqxUJ5l+C+bL3T1s+WL+s0a1vZkuVYWlYHATvFG/mD1f2miVJrqDUzS6Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LFZL1PpA+KYh7EOR3YqX9+jMH9KIDPeUtvui+RaWC5Q=;
 b=HvLVeVGWQl5Xw0jo3DSwSGPmxC3ub8jyK4FXr9uz7EdA1BkFC7BEzG8NjNjRRRFLHwR/enVQg3AGzy6mjhYyQ35a4Ep3Um3KrmNIufo7mhaEzBovbu2PfYWXhven1wBy4br1cyme5STf8d0u7RWGpp1hRQDy7INB+UDLNt3kNAtlsCyddylJPqrQOzUsBYZpRhu4OZFOjs9ff9MZ9052TRDf6AHgZ10MD/9NmP29vwBWp/3KkdbHViSAaJs8GzQ4eNC9oqHCP1P3Pc891grLARAldvWLdd9HQQb9nyNPoG6W40A6IQ5QfiyFsOitQcdRW7ihsSElE8WZHRO28Xeu4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFZL1PpA+KYh7EOR3YqX9+jMH9KIDPeUtvui+RaWC5Q=;
 b=ArknyVgaelV9VAXVYfLei23TrAUqbt8pWMUWWz2zXdOSIxsZQS0JpYtHhYksox6mbCq8GHOnu7cAwYiKJL7EbM63e7uoAICRafFKhqHv0zKG7y1P02Sh0ga3U8JFFp63Geas7cfyHPac95NizTbH3L6MBKUUIllrYeaIbM9aDyQ=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by DM6PR04MB6825.namprd04.prod.outlook.com (2603:10b6:5:1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.9; Tue, 3 Mar 2026 00:57:18 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9678.011; Tue, 3 Mar 2026
 00:57:18 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Daniel Wagner <dwagner@suse.de>
CC: "hch@infradead.org" <hch@infradead.org>, Stephen Zhang
	<starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, Coly
 Li <colyli@fnnas.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v4 0/3] bcache: add initial test cases
Thread-Topic: [PATCH blktests v4 0/3] bcache: add initial test cases
Thread-Index: AQHcnDOakmmifXVnmUmA1EebzfY137WbX9KAgAC5I4A=
Date: Tue, 3 Mar 2026 00:57:18 +0000
Message-ID: <aaYwWwGHdoc1uMCu@shinmob>
References: <20260212-bcache-v4-0-215f3fde1c84@suse.de>
 <37e2c5a5-d797-4176-98c7-0e43abaa1af8@flourine.local>
In-Reply-To: <37e2c5a5-d797-4176-98c7-0e43abaa1af8@flourine.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|DM6PR04MB6825:EE_
x-ms-office365-filtering-correlation-id: 25760c98-5f18-4be8-b7a4-08de78bfd1c5
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|19092799006|38070700021;
x-microsoft-antispam-message-info:
 XDN3MMZeI6p8L9Pi2GfWbRclNmE/ViSw/AUFSrj+MbvYL7Te9VKRZdLprgtT1lXxTfr0WyUoa8VlAoK/D07iX/evUroqRJak0sEpMXwf6sici2om/btxOar67V1fKTFrKTxQx/+5a0UlZO+q2brYyJUdZrSdqHcHg0SWbGeNKNiT6IYJUBqHqj+o5vokLpN5f3/+ya90c3+cXgzziwGqar3yP+A0QEpPMmLlvl5MJ0Vj9CoLZ7bRrM9dl67pfgCMhXFhpSyA47arjm8hJpeYW44yw+xSXBtqjInsn9NTo1dt0c0NJH9ptBUggu7g5tEF9Abkq/MupltgamQsb0y1hNnX7t5trZTVzZAMJ6IbKYOQJpX/zW/5m7XgyV4FvAViqGARsFlysx2yqv7ghbMO5COgj29FzW/UwzzQSxx7jYnwKLf/bOyHxiZySmsN9KNJTc7c4YJ5F98s0NjZfYoM/Z+U6UBvW6i0cQU4MhPqtDQoqIAaNVSFcZc14FlnYwUeNekDj0uu7QJd/BZ+VQwJCyJHLsmbzvSg3a4LCvY+yewC/bvuxAB/gISGcNFSBJ+2+pI0RftGY9Bjh4U4H9LKN/vZp+CNBZpgzaDLKxyBVtiyB19uznT2UUrQmD9zSsUeZP+ywJya31298szACqJBLS1XfRCI3o/PptcdC8Cc9iNVEaf2ADvwlYY6nub4sHAWSK/AagUUkGWUyotiF+VTOBadmH4cIOcG8xgFuK34R3JCtu36hXx9YRPUL4kspbj+lXHiyb5v93SJHLs2fG9rOcZNoTeTofmKwtzFVPq1F42OhE4BLIgset5NfavEoICg
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ZEMsb1aDOzxoIXw23EpPeZuMDKuH0D8+m+GfEyeHVNLSVxtSL7sQ9c55BmVX?=
 =?us-ascii?Q?FO8aLNGgCPL8N1PKlurrbve7dYmil7nLiRbyueom8Ds5QawohloK/4dNwCfm?=
 =?us-ascii?Q?lyqQ5iqIRspoEkbiFAY+fvFUUcHDsWMgLqxd+8QZki188TJ3UFHNvoF/smC+?=
 =?us-ascii?Q?C4eMd57SRUbgH17EQ9JNS8cGeCoELIeV8TBcFvdKmHle5rrz685aiBIMM291?=
 =?us-ascii?Q?K673rSDwKqm7sH5LwNcD8Dr7bRJtiQ6waT+7A1Orm4QRw7oAsHvGEFm9koUq?=
 =?us-ascii?Q?9aKERPHqnrczQkyeAO8ROdyaLUDvNDanxj/7DS6VZrDC5cdnw8W1ooNb1cJ0?=
 =?us-ascii?Q?QhshP7xbyqpO+qGDS1xPioJenKls206rXH/xprQkVR7+4gsmI7mmK4QlK4uN?=
 =?us-ascii?Q?oGQijOMYw4FwwvXMrtu6gexg1Fov9E54q07h07FepYTv7d/u0zbONcTgpBx+?=
 =?us-ascii?Q?Bb7giNa12Uvqh8OiMvZl7I9Nfikfr02i2Bi+45iVsBAoli4YcMvJInO/PzsG?=
 =?us-ascii?Q?Ur3n3heqt3WpsGG9X7412wd8+ebWlYRsX6VVpIEYZimS7mjzpkDGej7CX6HB?=
 =?us-ascii?Q?Y8MuNOkR9Zr0UMDdhdOFK7vLJD0rMsXrH3P/WJVK/6xUsAoO9QA7eWiVUpxd?=
 =?us-ascii?Q?Qv0wJbYXrFyyJ5bSfvEI25ph5xpRAuHoshRaBYOY4LXo/mA4r6VUtaJo5sPb?=
 =?us-ascii?Q?KiVKNmKlHhZpAJENdnk56mQ1wMCduVDSFDqaeIBTeDNYUV/IMMi18ET7i4mw?=
 =?us-ascii?Q?DuSjkxpaYuYog//Ul/vax/f0dTzIkSdFRdjQmvHOM0KhqwXcioFUh1ZZTLiV?=
 =?us-ascii?Q?D9w7FkXeDUiaegOtc8CuUWRhPPnNfWsJPpn/1ZXlFoXopEgyRLdVXGxrTqje?=
 =?us-ascii?Q?Qb44jyzdMWNFm2Bq9Z8W2CUdKUe1hPpzstdPx3oG9IxCuIEl32R94p7BhDsN?=
 =?us-ascii?Q?ZzCWY5aqb52MGGPWhCrNmxcup32Gvb+KFBH+Gi9siLfd4qlOHNdikE2Ey80c?=
 =?us-ascii?Q?qppyZFUj4Ex0K8HmHvoMg81urefBJ/07pzyo1PlXgC8iPV90O8s8/4lRBfw5?=
 =?us-ascii?Q?dvTPk9yLctiSMtC0LFixJudjyEMmPVbPhCz1ijhbITe45Zl1r/JjGfkd9Tu8?=
 =?us-ascii?Q?3NqoEXbbi/j0My5FAOM9xcM9MtnownSERApBajab97GL+WuSisW4DPK6c91A?=
 =?us-ascii?Q?GhzG0dOMq+V0gwaFQNckDjt3fz6BFw+xYD55qsB7WqTq/dEGN9Q+bA2j/ZWH?=
 =?us-ascii?Q?pgsTfsSRUPbYaOlLyUModJPfigVzgfZMuObQxhgz5mmyD6Q7Iz3yssrx3oGu?=
 =?us-ascii?Q?KjXTod02xuMDBgd3/r3jc5n9XY+zh5BKlr2M/m1LzZJWSOfNzOAjPpjUobvb?=
 =?us-ascii?Q?goKFSKZbL1x5iW7QRu47ayDlnFceWgJJCH/4cbQwSXpRItKnnDrfu+dgwOLj?=
 =?us-ascii?Q?PewjhogACgB9+osLh/axYdkQxkMFKPj0qzn+RerTNietHBGD/l6FDgdNWvpG?=
 =?us-ascii?Q?cJKu8j0xnxx4AU9q1/y3HB2UlvglyQ2SuWYb5TbAL9oiCzrDPC4t6rD/vKZ9?=
 =?us-ascii?Q?r7XzxphyZQK9qKBJ9LD43jMubOFksf/hVIoQ5bAiQye91Q28sRj8V7LjTXXO?=
 =?us-ascii?Q?PbbiVEI+rggRFxYXGsOjP/3vOtWAHxhBHFWcUVSzEjwSkOlICx0he5o6t0gM?=
 =?us-ascii?Q?mcClO7510n1t5XaDSSGYlP8o8nPLKBqFwz/lRPEhb6q44vlNNf2BGt/OZ0ed?=
 =?us-ascii?Q?z6Jst24Dcemyrv+SO6bwqUAgPv+AgCQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BD93249224C9294587577C44454AB01A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	NvLtDDoUhNf3GATdQScwH1dvrq9jgpnX0NrsSDMCLetjwAyjp5ngkPZqIQzoUMSLeofGyH1gL5ZpBJWjCzCyf1Tbn/k8k3Zf6yfJTvQ6t6FpciLdKgGqeEE4jKjNmF7Tf0MgW3E7qT8QP8DXd8Ho6ylzK8hoSUKiHo6BG4zkUXzlEGhOI2vfFvvXwX0XiBoCMJGOFiqVuDZtcxB3hBIv+EhYc4sjhqt4czYdkVfQ1Kw2aYHI96c9+OSq5wZcc0qFSrPTTMM6j0px2k1h1NDkJX5xAbpLQgHAVQ+IfHZ/oG+QLT/m9SHrbPWE6beG3SpvucazySA5E7nVMTGvlMRyFQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X1GLpj11OrS32OIymtLCGwcOo+wa9NLJGy5RlD5j/kZUlCaB+d414SD4D0GJ9qaRaSKiJU5m0te1ACCnnloKiotQJAfkkKfQYVzEy6zkTG8L1pv4JQfk5cuKB3bJl6k/haqrOG8A/4eNnQYcaoM3K2JxxMWVoDCmaCRx9m7F24ILMTnVYooVZI/X74y1gDyyxfCu4wzfIi1xljQYnMt05Sc2ajsiJ+7UsbNbLyXB06QSqwgTausn3Vv/U6gLNXyNUb3l06Hy2oeNk8d5c8I2LOBSL6tDYkjtHLC30Y3ImRNCD+tgeMichZpT3K1IJyrJsI+JJfLxO5s6q8LeUx5hbdWXQgD+95PLgMMho+4V0CnEPeWRP8TXfkfzh/StVqTR8u8chpa/nxSUsQdjyGtNnvEy7/m/8zl46t1Ao5DdF4EiF4Dl/tciepyJCVLA/+spT3x0FdSkwkISJt3qWnLpts04AQrcdhRmL2w9vp94E+D9aH2/YefapdHh3My0s5yTdwBVIntMVcLeXRL7Om9/IeJVD5yRTQ73L1nNY/mM/jLr9PnCtHAk0p9JfPxsN0ZxaeAb68hHU2u6zC8H0I6wjsTv30lhjgSp8ds5GRywIoILzt1Tvh80PRCiC8RwYrNe
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25760c98-5f18-4be8-b7a4-08de78bfd1c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2026 00:57:18.6621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QRJUTmXp8z/6CqZCx5m8/aPfqFbRCnAqvBGmPeadd6msOSzQ4IXsQGOzyAVGdF188sAx2o9ADpJOmKwXiZNZ6VPm7Ss0UdbeNLL7Tqi89RQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6825

On Mar 02, 2026 / 14:54, Daniel Wagner wrote:
> On Thu, Feb 12, 2026 at 04:23:30PM +0100, Daniel Wagner wrote:
> > I've updated the v3 version with the feedback from Shinichiro for v2.
> > Shinichiro, please note I did rewrite some of the logic in v3, thus som=
e of your
> > comments didn't apply. But hopefully I don't made a big mess :)
>=20
> ping

Daniel, I wonder if my replies [1][2] reached your mail box.

[1] https://lore.kernel.org/linux-block/aZQZkjEUw9VnVauX@shinmob/
[2] https://lore.kernel.org/linux-block/aZQcH-d-ZcgtMoJb@shinmob/

Today, I tried this patch series again on v7.0-rc2 kernel with the
TEST_CASE_DEV_ARRAY below:

  TEST_CASE_DEV_ARRAY[bcache/*]=3D"/dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /=
dev/nvme4n1"

And found that new files named "nvme?n1" are created in the current directo=
ry.
Do you see the files created in your environment?

Also I saw the failure with the message "ERROR: Accounting leak detected!" =
as I
noted in [2].=
