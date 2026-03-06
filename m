Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D31256C6C;
	Fri,  6 Mar 2026 12:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772800077; cv=fail; b=StJo/5tZeTYpJ3elDrTJtc5MFFzODeQQGygF/n+HTioiNKPSPLypDP2Vyx9laE4tWEjQF+4aH3BQoA5RyDwLnQflbcQk/4CIARJSUc6DruHqr8n85INJyoSlyBZb96gF3B7dulYxmRKCNWdy/UfcJLu46rbcsRGxS35aGPqKe90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772800077; c=relaxed/simple;
	bh=2C2zkn+HE7PmYT7pZxiRR/4sjVe4TgBRj5SDWcUIOMU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LTzhM8DqigYfM3OH9n7RfqapFvWzx5QNuAhfdQHjeqere0yp2ldu7thylNQcoW9OAcNjP3k5dXv9Q3hNaFzXQZRwgwuOT5kkQdg39I9z/9vRwP7PBKBIKk242LwW/37vp2EYAyOpJz7jMWgLdAvEe8zAkb+10ukkR/XuRDVKRdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=RK9t8vJf; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=LH/Q5rBc; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RK9t8vJf";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LH/Q5rBc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772800075; x=1804336075;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2C2zkn+HE7PmYT7pZxiRR/4sjVe4TgBRj5SDWcUIOMU=;
  b=RK9t8vJf29zoNZSLkzchUXVI+qQI2MCHjm1YVRAF9LfIlgmn/qxhxmxR
   7JofF1jOrNqN9z5sqZwPB0ylmMecWeFOcLWMcvdYOawon0Scwayrwlkgx
   1N3fV/q67F+YGVhF11+ZaFU+AlP9wACGTrp06xUGz99FIsIG0bSj/gJO6
   U9nqSjUQ6vuFgOVgVU0LdmxGCFNeyRb3ZDCmeNqorX9xEyifj+khgiX7n
   dJjYm0tjOMKQaXyLZRGe3LBsahbJJBYYqe6/CY+x/o30dsQvXJNIW/Xd9
   2Hb8JXAGGznJwm2OlzrMOuraM8Qym8FXIQDMN42fUFxK0ggOAc2umno/1
   Q==;
X-CSE-ConnectionGUID: phgwawRoSiuZqrPA3VH4qw==
X-CSE-MsgGUID: uoPD0EpXRCaB1JXElTwO3A==
X-IronPort-AV: E=Sophos;i="6.23,104,1770566400"; 
   d="scan'208";a="143166192"
Received: from mail-westusazon11012050.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.50])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Mar 2026 20:27:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oBQV8gKEjg0NV80T5B0TKNBcaNDQIz8tfTqu2mLTdbIlozTSDH/mthGwEDd+pmieApAoY63wLphz2c/wu06ViyENSYLMHTfOaUF98oc+j2L6GnvfzDAyisDMfX0m3DnWM6igl/CVxcTGEYEb3kNmarg2aIL7xxSsD7hQn+LBUwVy6AQq/AyUY6O5lqIuhrPqBvYAisgY6fRkS7sIBxhe+znSO3xymQNyZTnRaRPZXsQMyLe3gzcEvnwClCRfAzShg8L+cjHRSPkVW1cUQUTfcuMTha2D07mBVdPvJmw+t8mN0smW0vPJJ1jT8jW5pfZW6Lrk4t8Pp773Gd5V3MaBEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D6hzbMeS47RZvZ/i4RLifLHhYr8Lb6mzwSJvyfmO2NM=;
 b=lEynT4mPawcHvYWk2gwPljGHXAdg6F+bvJxhwdWq7523DShrRkOLnR7XFEKpvVhwXX+wc6y1J0hdwlGemeSJudd+V7PYdHscpbloedz0sbWr1UfGjHxgSssLiTn86X7kJdOT/tQQm8ibKKN89l9sJ5gIa94GJXcWf53214UZCtdDuJLWZLGRPYUnQTJYOlXZvWF3C0e5NcbBYSMGhagq/a7FB/DTgJgJG5ktRxXPc1ZtUvTuNqrb3+KdYllkGcynGTQfOA1nkmMDGBDzV9fYn4W/8C68R+ktcExu2UD6c1yZSIgoa7CSiU93t9xbPZKg30ROWVyYv2oRjilS8HvWXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6hzbMeS47RZvZ/i4RLifLHhYr8Lb6mzwSJvyfmO2NM=;
 b=LH/Q5rBc71fgXvGDTAw6O7eUGNuHYR8bUsRz03KvOfnuEhyCrOMYDW7i/OmpHllyTT4GgCHxg5hjVk6QH8zu20mqek8m4f8dAUMFYdFBGEdLIPpRlK72pXPlBH7E8UJYMIr1oIBb4BrvvY//No30j8oiGMl3Ck3mKdnXdOrYP8U=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by MN2PR04MB7037.namprd04.prod.outlook.com (2603:10b6:208:1eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Fri, 6 Mar
 2026 12:27:51 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9678.016; Fri, 6 Mar 2026
 12:27:51 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Daniel Wagner <dwagner@suse.de>
CC: "hch@infradead.org" <hch@infradead.org>, Stephen Zhang
	<starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, Coly
 Li <colyli@fnnas.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v5 2/3] bcache: add bcache/002
Thread-Topic: [PATCH blktests v5 2/3] bcache: add bcache/002
Thread-Index: AQHcrLEPQwqT05OYDUyRjU2eLOm8z7Whb+eA
Date: Fri, 6 Mar 2026 12:27:51 +0000
Message-ID: <aarFVqxrXF9Bah31@shinmob>
References: <20260305-bcache-v5-0-04cd4c9080d7@suse.de>
 <20260305-bcache-v5-2-04cd4c9080d7@suse.de>
In-Reply-To: <20260305-bcache-v5-2-04cd4c9080d7@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|MN2PR04MB7037:EE_
x-ms-office365-filtering-correlation-id: 8948e825-db95-4972-cf26-08de7b7bc8eb
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|19092799006|1800799024|376014|38070700021;
x-microsoft-antispam-message-info:
 GtBUMSqo+e582sXfRmQZ60rWdy+U2oD02UNZcXy7FKVpqoHq8aiO8L3kewnEF7W5hutc3AI7ThFskxcePJASF19cSCdZs/HC0dzVPaKV7Gq0jN1ssFBj2Vdt/qA3jdaBA0We3p5Z9XFyImHMaSJTpRKammJjvsgPXCOjFQ/yA4RNgPLmXToepPLbSUJb9/oy724YaZ2uE8LyYvH9GLdsfOKoYYrBEW7y51z04TzIvcSzE/eniwVkSu1vtsvn9vfJKjiMaXc0znC1CQNnTlI7IcCiJuCUV2taQIYzm9NoTL2IHCcHMavUldDBgbs9HMzqcIBqfZdTa/RGTmIKkEaxlidoB6YnsdJseJSNIV1FzjMFXRq3/arhpZc1R0ulB2NCwOWRc/IgfljcEI8hxgclAcVOTgQL4ug3Azh4EroxWWIAKnJt++8eG0vkXj7kNwV6YW8grK1RNbj4BBCVjekC6p5Fo7OzseHvX/1kTQu0eISMCBlYCD+zK+PGvqbi5zpFbFizY+qzoP6ZVcBAg1wO10pzKSSFycBBlcdvyG7aLMhraTK63CMfU89Ai2pvA0kZiV7t5jJ5R1zMwra7NCDFb60V5vaXaOQUdFR7vOmprnMerhSrhFv7Lxsk2LcNPBuPWA00Iz9MPPLCEY47SJ7zRtoRHqHUnk1/Gi+LnJmskJ7ZR7Su5H0IBubWYDOmNToa3ucGuAsd+kBWwV4IeuYtrUOzCCbg2zhpJpRtX36XJ/PdBl2+91iDBY+WsVl3SaoS
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?/K6kuJUALNbGS8gyt8N2Mqi0FFDJbWP+zceMNu/wPIkRx7admJr4JdwC2Jas?=
 =?us-ascii?Q?sm0E9y8DBv/Zl92B+Ucg1MjtaLOB/CIDFRL1y5z2MVFik4fHgvnhyzTs9F6u?=
 =?us-ascii?Q?Udk6GHF5oLE4UQzw2G+Tv2ulZ7jQuksJKwU+AVt8y3IIuvdwIZfIbZe8h9kg?=
 =?us-ascii?Q?a0VDjgHqDgNuA1btFsXdYXDwwdRJpZhWGHk2BAIS2qKUtByAGunOm9mVXzdK?=
 =?us-ascii?Q?X4pbralwYTuq/bkd+tT5G2twrQvKFncntKnghuSMHbXtCZmkCrFfg1+uz/YW?=
 =?us-ascii?Q?3zONeKMVfTAKWGe+zrFsBwyJ3/asxQ265MzrLedc0ep1WF4vtn7saW9eKZ5B?=
 =?us-ascii?Q?5GVV1AW1tn3LMj0T6SIxpKo4THyClvohcfuhJy95pnYsgFuPHAT6UqRsTXEN?=
 =?us-ascii?Q?QM/du3D7H7ihwFOLVmX8u7+NNx7Wl55zMJ8uJm1rn350ZFxh3oPYMHWC9OeZ?=
 =?us-ascii?Q?jGdp4/w9lFukQLb+cba6l4pNwFfe3nEpgZ9SBrNc04GuI2NqupyJCTx8IbQ3?=
 =?us-ascii?Q?nlspIRgHe3/qz4a06ffGOFKNEZonyTiCnhkWcSwjZ8T7bjaAPk6Qb88JRon+?=
 =?us-ascii?Q?3RuykcAJl2SZoSe4KSBqM2wXZGIVrCsxbv3bcz7G99lSUINOXb5VC9pYpwLP?=
 =?us-ascii?Q?T1KP1pwSAZpeuamVshcqtyI5MQHvxc+24W94aTvWz+DQVISCD8BiqVVrEC1K?=
 =?us-ascii?Q?EI9qMRKxRb24/cd9Y3UXHjk89xXJX3Mh6gFiyQuNBAFHekXAXcC5vtg/5f6b?=
 =?us-ascii?Q?n9zh/owptLa1DWfzZxdwO5f70+ctMXWGCBcrZmuyNqEEydoN9FPllE/fakHf?=
 =?us-ascii?Q?cfTFx+7NQkemVrF4SzUrJzbMQI12rd+tX/j6fKE1aEhiO3iy4LcvjcC7V1Au?=
 =?us-ascii?Q?G/9rwzmk2k9lew9BfQsAlfmgtWq+TyamipZg2Txrw9qYv3LAuni2sC0jDMN7?=
 =?us-ascii?Q?nK2RSCqEe7UmATFsK9g9RyEzVBm25b1ivFzbAh/ErNjmbyRMzZhbBGHieU8H?=
 =?us-ascii?Q?rcppWSqfTPNlRddI1EoJ24cbV0pB2ooW177YSIJHTqdMU71h+VGyGUQ/IW0W?=
 =?us-ascii?Q?/2PEtI54nsrVKrKN9pLKkHKGehE4LdOromiZBXFn9gAq0XUZVps7/rkYZpFu?=
 =?us-ascii?Q?T71FFBchyfoT1Z7DaK4bc0X85RRTf/M/4cic4hrKSImmKtmaJvSgHlqvNoFG?=
 =?us-ascii?Q?1yOaCEQyJip1nixiltHRlPf2JsXSe8yyf2Pj6Bnq29/Xqt3Kku6fprf+avPN?=
 =?us-ascii?Q?8/M+9W0mmK5iqCOkVdqSDUyTJmDcmFmC9SyCRjIxNH+qw8P1mrmhTetkVSbb?=
 =?us-ascii?Q?NHy7O8LGh0V+aQIkf35Wnn20yGxZjKRaAKfe3NHHwWClURmezATy0oWgc5eW?=
 =?us-ascii?Q?pSXjseZFjdr0XY8czBiDpNY32ETXvjjgrz6Cl54taa4zHIDCChz85LRmKcCI?=
 =?us-ascii?Q?m7TxO3r6m54rTIU2XabMN590+886cXaIEkXqzID2cfkhVfFeJVCQd+LAQz7b?=
 =?us-ascii?Q?EhTDyl2bSXwZYNZCElxPGDZaEHFAE/bDu/2z5Bq3pldywTxGIE0Rnzc5Fqi9?=
 =?us-ascii?Q?/Yhg5czcmIZjndzfngmxykvP7Y8Cg9wvEWQRkZq4engoyJhpnjDbYRMsI7hb?=
 =?us-ascii?Q?w3kqjFudzla7/ZogmiJVS5S6IiNfTAB7UIRVGs1Gk252GfZImvWTKD4HvmF7?=
 =?us-ascii?Q?OW396PJ8XhZv6xIGFJQPE6huJ1m0dq1dLeUwgPOxNY+M84A4/p5oxr01GoFI?=
 =?us-ascii?Q?FgF6ZIpbxUYr21oPUKEzKKnWNA3agFU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <865B602F5249C5438D7B098F790D4F81@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	bee+f5+XJVa7fwSVws0PU1zW+8cx6DUS3MBiygDO7m+i2NoGtQB5aH5vNexMGzPzSWIlqaBlTAmIQu7NboRf7C1IpQNpy3yfp4oDea6ImiqvoTKJkOJIWf1dlAmG+kvby1/rjw6zCsRnP86X2ABEDmuRAK8vKtBVtad2uLx/1vvRtYEELkuiRTtSNzFqLFcgj1CLElSJDGBeWH1g+efXkIqVCmRUVSWXxwV9Nzeq5xc7lKqgoUHYjwbS8gnoFnuFdlvLcsssSIhbbDkecH1yRp/hbnNtbkaXzSoyf2IX9a1C2RVQNuN+UcJbUU2J3WdR8/YadXXphi7U+6FUn0EE8A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DFE06wMOS+HSGj8wz5ycWpYHGyB8SZx60zSMir7aY1+gyX5OqLREy7vHyfkgJop/wNFxkmPLXxnOpfs4NwckZDiWfbhp6IPucG2sPFJc/+1dhoMEtIr/MgbN/cNwda0n6zIe2GremeoBQ63eSn6+7A63+vzX+WtXOOH08ENl5vl1fEqHa/Of5geIqib5SNgh6z1sKV6QPpY4GHl3ADhavwDLq6wFnrzabpumB424UjcELCJIQMKgfPwLWrWu4pjT4guGfkIKv7EQJyrLMSMWokJRqNjyp3Qr0v2mmAXTISmOEXHOMA9ggQI+xzUcvtOrQOm2MtjI171+MFXDqxnHdxxY+FUJSBP2yNu8AWrW76bbqL/jgJqxulaWQDXpSrTLtPEb12NqPdaMGtXqLoOoP6cA6WQq9og5rRvugqVgnq3Wd7dqwBjNV3KgtFgeHiGfx7G2sLPkX0GxxtOTnvGTiPOFEBFdM1LJIw9+aguDXJ1MaSelPCsZOdZ9cppNSNt/xACjW7uZXH39IGi+tqJfh3pJu8d2MFsEHAXsBcm+Wb89n+lqqG9TA63JgDMD+hIxJU5CuZRFs5/NOxPXXqNmkBgNVCfXAdDXzDGepLiPYCGV3yqG2VNrMac/YbwkLWKA
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8948e825-db95-4972-cf26-08de7b7bc8eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2026 12:27:51.4947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WLNjvdWcAl/4Rd9tOJqxHkqTHgpbIikTFukAQG7nVDV1aiMvjxWvY92EkzSyGK/DtrL3VH1mbsydFFtvwsA7bkc4is5KGpIEwd4oypH4MqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7037

On Mar 05, 2026 / 16:01, Daniel Wagner wrote:
> Add test case from Stephen Zhang [1][2], which is
>=20
> 1. Wait for fio to complete (wait $fio_pid)
> 2. Wait a few seconds for I/O to drain
> 3. Then check the utilization
>=20
> If utilization is still > 0% after I/O completes, then there's a real
> accounting leak.
>=20
> [1] https://lore.kernel.org/linux-bcache/CANubcdX7eNbH_bo4-f94DUbdiEbt04V=
xy1MPyhm+CZyXB01FuQ@mail.gmail.com/
> [2] https://lore.kernel.org/all/CANubcdU92Uv7wNdZH357LLTnfwPouekXNTPSjHnz=
YzK99-eZ9w@mail.gmail.com

Thanks for the updates. It's good that we do not need iostat :)

I ran this test case with v7.0-rc2 kernel, and it passes. Good.

I also ran this test case with older kernel without the kernel fix [1]. I
expected failure, but it passed. I ran the Stephen's original test script a=
nd it
did not fail either. So I guess my test environment does not fulfill the
conditions to recreate the failure. Daniel, did you observe this test case
failed with any older kernel?

Let me leave nit comments in line. If this patch does not respin, I can fol=
d in
the changes for the nit comments.

>=20
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  tests/bcache/002     | 78 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  tests/bcache/002.out |  2 ++
>  2 files changed, 80 insertions(+)
>=20
> diff --git a/tests/bcache/002 b/tests/bcache/002
> new file mode 100755
> index 000000000000..a50722ff9e0e
> --- /dev/null
> +++ b/tests/bcache/002
> @@ -0,0 +1,78 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-3.0+
> +# Copyright (C) 2026 Daniel Wagner, SUSE Labs
> +#
> +# Test based on Stephen Zhang <starzhangzsd@gmail.com> test case
> +# https://lore.kernel.org/linux-bcache/CANubcdX7eNbH_bo4-f94DUbdiEbt04Vx=
y1MPyhm+CZyXB01FuQ@mail.gmail.com/#t
> +#
> +# Test bcache for bio leaks in clone
> +
> +. tests/bcache/rc
> +
> +DESCRIPTION=3D"test bcache for bio leaks in clone"
> +
> +requires() {
> +	_have_fio

I forgot to mention that we need,

       _have_program bc

here. Let me fold-in this change.

> +}
> +
> +read_ticks() {
> +	local bdev_name=3D"$1"
> +	local stat_file
> +
> +	stat_file=3D"/sys/block/${bdev_name}/stat"
> +	awk '{print $10}' "$stat_file"
> +}
> +
> +get_utilization() {
> +	local bdev_name=3D"$1"
> +	local t1 t2
> +
> +	t1=3D"$(read_ticks ${bdev_name})"

Nit: for shellcheck, the line above should be,

	t1=3D"$(read_ticks "${bdev_name}")"

> +	sleep 1
> +	t2=3D"$(read_ticks ${bdev_name})"

Same here:

	t2=3D"$(read_ticks "${bdev_name}")"

> +
> +	# (t2 - t1) is the ms busy. Over 1000ms, (delta/10) gives percentage.
> +	echo "scale=3D2; ($t2 - $t1) / 10" | bc
> +}
> +
> +test_device_array() {
> +	echo "Running ${TEST_NAME}"
> +
> +	if [[ ${#TEST_DEV_ARRAY[@]} -lt 2 ]]; then
> +		SKIP_REASONS+=3D("requires at least 2 devices")
> +		return 1
> +	fi
> +
> +	_setup_bcache "${TEST_DEV_ARRAY[@]}"
> +
> +	local -a bcache_nodes
> +	local bcache_dev bdev_name fio_pid state

Nit: for shellcheck, unused 'fio_pid' should be dropped.

	local bcache_dev bdev_name state

> +
> +	mapfile -t bcache_nodes < <(_create_bcache \
> +				--cache "${TEST_DEV_ARRAY[0]##*/}" \
> +				--bdev "${TEST_DEV_ARRAY[1]##*/}" \
> +				--writeback)
> +
> +	bcache_dev=3D"${bcache_nodes[0]}"
> +	bdev_name=3D"$(basename "${bcache_dev}")"
> +	echo 1 > /sys/block/"${bdev_name}"/bcache/detach
> +
> +	state=3D"$(cat /sys/block/"${bdev_name}"/bcache/state)"
> +	echo "Device state: ${state}"
> +
> +	_run_fio_rand_io --filename=3D"${bcache_dev}" --time_base \
> +			--runtime=3D10 >> "$FULL" 2>&1=20
> +=09

Nit: a stray tab and a space in the above two lines.=
