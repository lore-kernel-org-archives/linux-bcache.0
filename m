Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C1D3233ED;
	Thu, 22 Jan 2026 09:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769073220; cv=fail; b=cULmqqDNgI92ltzSjwoJhhNURNam4kRVnABiz7JZKmc7GBsI2KMT6fIUB1VRG5Up9SFGcTg0kamSVY1kzVPBg1aKqO4oMwVr0sD5ylifWjSkFXkzdUAcHu8yYrdPKfLnbRfsPbNP42Id1ois+c6RVGRQ9LB0U5w1yMg6fDZ6ElY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769073220; c=relaxed/simple;
	bh=s2GjzWVa/yr2sQjM6hMki7wHjv7+QRReyfSxbV9v/Gs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AYn2k/4T3hDvhWBGhs76MGM+SEsdQ7ykMqA6Z3NT9CbYIxLd2o9J0he+EIRrtO6gydkVP3L82k2eir5vFsfrzNWMyAzM/rPjP+26r+or56g7VgbW/NnVBL63clJGQGDzYVkWIUnDgIn9XITEMHm/vgqmYv+iGQdymoL9uBd6aYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hsr2BrBo; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=F7nIPioA; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hsr2BrBo";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="F7nIPioA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769073218; x=1800609218;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s2GjzWVa/yr2sQjM6hMki7wHjv7+QRReyfSxbV9v/Gs=;
  b=hsr2BrBonQBr4xf/G0m5wV26LL7YaLELw23kOqGnYlhMhBurP7cfYxAL
   u1pjIg2qCe7qCKItzWQCbdVqCTFALE6CzRML9f9XFqu8QojwDBSVfrOcM
   Zy0jUavOEUPQYZtYzQpWjnhy+FdmYUlRwcAs0Bgt5IZSVPKUlU01Cvcyh
   hTdQXSj2Aojz6YwwxbAAy/af+BvkU0xDhzxX39nXjN70v8Njyi5YpaKHF
   oiqiJGtgO5d/5fYHg8juxPP+xdihFsx4ydgfuoxu69yduevOl6EADe/ze
   MGQJWmoD38iHCJG+i3WEo1qBsN1pVKyPs5hqKLhnX9gZdyWRAvpGf6rWb
   A==;
X-CSE-ConnectionGUID: P68wy+FqQRuOvokNGWGw9Q==
X-CSE-MsgGUID: j8C2SuxiTWyXXQxC23P7lg==
X-IronPort-AV: E=Sophos;i="6.21,245,1763395200"; 
   d="scan'208";a="138513377"
Received: from mail-northcentralusazon11013031.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.31])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jan 2026 17:13:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RdZK+UihGspLSdgFiazjb9uSXb3J1z8FifhzYsZPdWp+NLIJoSha2s76EoBP8se8MJhy5yJQl1hXu3G13tTQWJFdQx7gsYoJlklU90zf//zWR//Ov21HvGp3epU9MMVfOB/6pfd0BeP8rWzpl2FkKiLAQ/I5yaOTl8HOIFOotmvr0pu+G4NaOkvbHFoBoSthxETi+3wWTBedMWCHEh7mOmQzhBJzy9Sj3Bv4LFoGzHAkJJwI4GHanF3b0VqNRpqZFboxvrVunJ4Z/aQYpV/Sucs5h9N+F8oh8h6CfuPOSkwmm98SIxCdFYqvau1LBgaY0Z0/XaUsS9URmYZMADE99A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cbVb4k1YsVAekdNxxmXG3Fjdr0hkeGuEpxF7vyTTCTE=;
 b=P/rddVqJr98mMnHUzWDnH8N/o5EEfJ55Co/cdGGma4WL55NG1PEpRN8nv54w4zcuZrdMc9JHbgSI1ahV0AtLR7VUcF4WfI0eOp1Rm++nfNBRxdA06L9VLY9KxLvqWgDgtm2xsszeS4VD0d3KPbuhz6JzJeq8AH+BIol83NqYh92E1pdCp4dN7peH3660X871WwBpKYdrpljY0WfLmzZ+i7UOJeCU16EkYoUgrC9X/wmE/b23FoedeP5VohYLCK15n4061p2estj5O8bpPiyLexoLz70Uwxrqw8l2ypUu5doEOfW9yLVTPsfAlwxn+8HQFHojKP+nkXch379I7H+SjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbVb4k1YsVAekdNxxmXG3Fjdr0hkeGuEpxF7vyTTCTE=;
 b=F7nIPioA6Iza6hAJ3RpWL/vxH+ZTzW7pqhO/Hj4q87BL/lh2TpeZVuXk4lkUMsSBMjkGSv0d7rk8hdalo3G6ZQ8ZOksEaJt5wfmksyzU0c7t92Z8C2sudDzaOOpXbLjxlfBw9oKpqb07w/iDDiCJreNJLWz5/IfdHBLF73N3tPU=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by CO6PR04MB7844.namprd04.prod.outlook.com (2603:10b6:303:13d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.5; Thu, 22 Jan
 2026 09:13:27 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9564.001; Thu, 22 Jan 2026
 09:13:27 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "hch@infradead.org" <hch@infradead.org>
CC: Daniel Wagner <dwagner@suse.de>, Stephen Zhang <starzhangzsd@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests] bcache: add bcache/001
Thread-Topic: [PATCH blktests] bcache: add bcache/001
Thread-Index: AQHcihCxlNH0vo7br02hnaYhhV+fnbVcQsmAgABRjoCAASoMAIAALDYA
Date: Thu, 22 Jan 2026 09:13:27 +0000
Message-ID: <aXHbPWCf5SfycpBX@shinmob>
References: <20260120-bcache-v1-1-59bf0b2d4140@suse.de>
 <aXCGseCNoaX8rQ83@infradead.org>
 <512c18ed-feed-416d-9de6-c9183da98efc@flourine.local>
 <aXHFIM-8HrO-8cCO@infradead.org>
In-Reply-To: <aXHFIM-8HrO-8cCO@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|CO6PR04MB7844:EE_
x-ms-office365-filtering-correlation-id: 3579e06b-0c36-47a3-80fa-08de599680ef
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|19092799006|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?1XvqsenizFfDX+rdFOz43eU4RibdRE4u6cUzonp7fNefsCYU7FP8iHWofxYp?=
 =?us-ascii?Q?8MfcELYwfJluULuybxrIoFAkSKXKRTGhPJ/6o5lCkuWI9Aay3DOeFUvMCm93?=
 =?us-ascii?Q?45dx/C/2SlysIx+9S5kWAQmhBabaHc0ucKtQn3ntLoHsh5R9Av+D9CsgBcfw?=
 =?us-ascii?Q?TOBZC/PT+/YbFVNmIwErSIX1FJUILf4mbWKGeEM1JBT1Era9vAziNXrZEpUE?=
 =?us-ascii?Q?u7HgZM7qO4Ag95Shjd+d7okwbINW1/QLS3+rrk6I7MAYvLDaWKXZncKB1QbR?=
 =?us-ascii?Q?tf0eiYHhkoZayLi3ohevC66I/dHeiDWZX4y72gvL27gRC6grbLgT70kP9V86?=
 =?us-ascii?Q?PUet4mdIH04Opsir+KOhUyiypMoS1lj76Vhqpy71/mL86v3IkkGCOTTpZv+N?=
 =?us-ascii?Q?v72Rn68G2FprNgDU1wBj5uEV270MsPDTNPaBth3/QpmIpZBZlGwZ1GGkBHzw?=
 =?us-ascii?Q?Y0bguWWOso1jjyxct+hpu0PzTUEbiqWefw66z/2E7v4tmAWXY9X92VrOUoiB?=
 =?us-ascii?Q?wlhERaK3AmLmzGVP2Fny5pD6hqU9PC3kWD3dbz1R5Wwf/yKfljS0iB7qXCOS?=
 =?us-ascii?Q?QJNrl624aHKhMy1RJTUJ/NmMDP9xxGlJUJRFwtc4w8ty00hmaPhVQ/UgFVB1?=
 =?us-ascii?Q?zccRVk0DGvKLpi4Fv7aWVH99Y4rkaILlqvtYGJBxy00kWUV5tKNYOSTkfKDs?=
 =?us-ascii?Q?Xyjp0XgXEGT5cX3wsw1fYmLWoq/dnYZqYfJmCNdpaHL/WqfFQzUEOMiIRTYm?=
 =?us-ascii?Q?pvaPgO/7eppXu4a9v6vL2kWsGMBY751200atQ83s2cHBzSL6jdP1xmpn3XcT?=
 =?us-ascii?Q?6i8JPE4FkZkv4BnE5JWVoI3vTRAzF9yxCdNuDEbsVfydMUWgn/oztGniKblw?=
 =?us-ascii?Q?1EnPoG8+GdU96vSiucnwjhqmQvx/81+yIG8vMkG8/x5v1XFaFGbM0SL4cGyb?=
 =?us-ascii?Q?N5KImKvHDZu4YtpbfLpBJ8Ejl2myW6bv8MTwRlo4v/FmhjscfzWLB6x3i4dK?=
 =?us-ascii?Q?giNnplTC7tt3IHXrHL5PZ1Oi2yTHzaOVYOV3Q9Czz3KH5xtmJJSUprA87KCZ?=
 =?us-ascii?Q?Z4IkWiPicD3ppGCvmU1jTgfi37r58w034Z72HuyjWc0u6wV+Beae19VXgmXL?=
 =?us-ascii?Q?WHKnNmpvTyrbpkjEvjpLHI32R+jGBSC5HS1lhxxeMMJDiRbtNhY0NKX/Ervn?=
 =?us-ascii?Q?/kVyjleXbuFqG4ME3oAY2vOoRo83oM/qLOb3j/exX9AED/A3WKuiWr3ZAe00?=
 =?us-ascii?Q?tn9F9tziJRqz9Jyqa6IPJaKbE9h/NYRpPODIh2lKTTL8uTRawdL8Qx7yJ6BQ?=
 =?us-ascii?Q?3DbhiJUlPyjYVSqGHg6lpvJCbXSpA/PLehZzvWtY/8nHdSCZp8XiDq7P2myN?=
 =?us-ascii?Q?O5RDiNxYAzGTd0Q1VEtvxYoDl46qs+n1rBne1ftS62XohcbJx6Zgza0xvqDm?=
 =?us-ascii?Q?GbaQl0xqVbQsoTug00LCykRb5Vx58jaNjLs69C4XmLokU0468VHMapg1s6hz?=
 =?us-ascii?Q?22BXlSv3QAlJ9LeQTEX1ziE3BxyTcihLDWE1AJU+GN1IE67eArgHENhne2D5?=
 =?us-ascii?Q?SfVW0Lp+gTLTZAf4OqoPxGMZq267hm/ofqY71VFIzeeepg2mQLhSdLDg/abi?=
 =?us-ascii?Q?rfYdJV/n9qakPUDvUeoqO38=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?BdHC+eZlCuTBHY7PhvofsVkQY9RPzVnnadsgr6hSGjZCCrbJJo+TM/cN6EJS?=
 =?us-ascii?Q?YLMKuf4smQkIiw8FOL6ZHfkUcKy5IECMejA+5KGWGGbX/zPtke6K6iBJ+jJc?=
 =?us-ascii?Q?m9k6QKx8a/GV0pC/JyVod7rrGLJLICGKAqZ6S3ddVOcstrxZ1NUsmENYWeMM?=
 =?us-ascii?Q?JnLLsVH6VSUMKg+vtChZslNKTxucegZAOYZJIz50PN+IpgY+D/X15joTgPxm?=
 =?us-ascii?Q?misNoWuNMaZgnBRgEJyPz43d7HfRbSaj4qgrYWZDU6t1GXfRg7leipAZEdA5?=
 =?us-ascii?Q?NBduAU1iByrFt3gCwoOTvTPF/Ep+5+6dunlYFLuuttvt6iBCNaAln6MQO1jd?=
 =?us-ascii?Q?4eJ7feBIhnshYODmuvdTLOGjlSAa3kHYnSvMIrxEo4IrCpe7Aa6muxvzhEcj?=
 =?us-ascii?Q?k7pGjJw0QC9Tccoh/znu4GtPzQrzFDkjoFxbMv4mtnn+RfSpKHWjCib7Z+Uy?=
 =?us-ascii?Q?iFVyuog8cXgHSn+5hwHg7dNURrO1ewCuq6l4hiqB+RQy1D2XpG/QdUzCaAfO?=
 =?us-ascii?Q?b1d4lSbK4tM+O0QspxSWgQXtFPPKNakZagOG9WrMkYVWVmoqXRr9E6JeBEpV?=
 =?us-ascii?Q?xmlQjP/9I+cH7Lio8a2xaaFXDQ6Rr6Pia7sSfL8K7bYQLAhp3xDTn3eu3iYH?=
 =?us-ascii?Q?4oThIT9ASIicOvSA83GlEu/ooZQskD1WAjJNF3xTafZTVdL3fvHOQvkXoOD3?=
 =?us-ascii?Q?B8TC8J1LluH2LuOx3nRjiBEC4qbVSIlFrBra0qH9+2IX6s8vE2EO8vnl44OW?=
 =?us-ascii?Q?NmD8vhwyKiI7KwpIp1r/sv+Qv8umjqoAWznHjRgMMZP/bfftR69TYCgrdXrZ?=
 =?us-ascii?Q?OaBpK9W+yc8OHmx7KNuU/XnTgHQziYThPTn45ePniueXYAzLRfulDq4WWu1Q?=
 =?us-ascii?Q?hPoPNDE5mJqjWNmD8CdXP6tRt9PzAGPthUA3Eh1m3Ohmw8AxO667ry1gEbj8?=
 =?us-ascii?Q?Bxaj9WUjc8q/qmhT+81Wf4KYBkSTJHk8DZaa3mu7lVif11p3kgpWRznZtQ2K?=
 =?us-ascii?Q?N70JBd4nipwMQ1/V2EF8fmH22voPd1F7RuY+DzGtAe9Gjgy+CaWVBQn+hSt0?=
 =?us-ascii?Q?Bx+RjS4gR25tEUZ3MrKGNEyBVX2eN1e0K01re55+atbXjpCFasKrMzLgTDwV?=
 =?us-ascii?Q?ATngTRVNfe+gCWyYTUOcZ7qbZ0N/KEjU6AnLfYqYJqV9esZZHz4si+T32F6E?=
 =?us-ascii?Q?PGb2GLf8EEcxlBSKMvDjTMektu/9qgygYaaAfJ4kE8Vpd8onxtJ6KlTvfIGD?=
 =?us-ascii?Q?bPREE7cO6ALRdDswhl92/biWSjq6q9jgqHY/SUat4knVZAYsVI/kaVuYy+w7?=
 =?us-ascii?Q?UthYUg6TJcULZ4YpbRXoEVLaXrNQIAv++slxuTX+EG08QmD2w+4b2LvyPTQZ?=
 =?us-ascii?Q?zrUuYdeXDmn2HV768n0U0Axed1+oXXQf/TnOCrYx4yRzhMklq87H3p1NxnRa?=
 =?us-ascii?Q?gjf89eJYN2BI9peSqFavPCxvMnp+LgRi3pNUGuE+gnpOwuz2fVgpBd6xokXf?=
 =?us-ascii?Q?I/JzhHZNXFGNPS72GuqTCToZ6SlitFR15FMwPhmm05cTyA1EScZI6pyj7ZV3?=
 =?us-ascii?Q?xJed/F4floHq7FvdnGpo/1QQFEwKWPHIL9p3vXnXTqSXnMABoRqWTrPi4ywA?=
 =?us-ascii?Q?5sIoHEZ3GHszJ0/LKexXWjS6R4CIq/wIfjqBN0xkY3LlLTGpFJIaQVMWJLMq?=
 =?us-ascii?Q?IVrNXrId12NwiLcl3X15DoN15XvwQj+8IJ0AUqBqp16ijVulenBuCjAGZAVF?=
 =?us-ascii?Q?WxcTExEXmDD6m+FiynNL+zEUf/DVk0g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D11D52C5681D3347B0CA58FACD889445@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+iVFNvMcZl6egG4ForGkY2uMP8iCZh6zddE8nMQdAi4ezXxDfhsWfbEk+FYqdlUOy8RguwLBMV7/mNJIEWPyFBeGd/y+SYeuclfmPbFg8jdRGmcM/quCSzfL80yViETuW4DH3K+EEOhFQHbN1kn0/caU1Rs8e7AjOavdL+oUu+qvH4p3H+JKsTnjWNIqKYyJURQB8ducHK9mrtj52JamkIDEhJ2zb/XhP2LNL90hhRCbK73R+G/OWMhr4jKx3F9mWBJ0/z+sZZmdJuVol7l6SgZIw21azZdF5VcYcHcmwA8cL/0X8DQHtOs06JzqcZavWFZhUYwsuvXZnsjBuZknj3GXXw8phpQ7vtPl6HAELEmRZB5FXuntfOIR/1+1qxxo27zbVASsbnuBXP0EEXHdQmWOXUXMigiIQv309kK4AgmMdDunyj8Nw22XhJVLWjmqS4hRXD5+sbcfKQiM36psMUuHgcQUFRcuwXbJOml0nLRCxZYLDMxDMOHCkJsDHPRYH8bnXFEQZk5KN3t1zR5gYoCx+0ZqKfmwQkVGYvUJutmveKobECaIZHzurIbtb1PPGA31y+NuaXQ/WKHaLsnUnunw8G+AySkmEKNSO0Dqhod+FdAvpsxPcDhjFkM4nhCK
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3579e06b-0c36-47a3-80fa-08de599680ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2026 09:13:27.5694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LNYRlSxHkjEGQqpRQ9+DGqDJcBj1iZTAZ7lYFIz33u+LLfx+f4W4yns70Z/gPp3s51YsRd+DqODsoj0J5aWbI0bdnjmTziJiAUYYWA1mcH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7844

On Jan 21, 2026 / 22:35, Christoph Hellwig wrote:
> On Wed, Jan 21, 2026 at 01:48:27PM +0100, Daniel Wagner wrote:
> > Sure, I'll update the documentation.
> >=20
> > On this note, It took me a while to understand that using
> > TEST_DEVS=3D"/dev/nvme0n1 /dev/vdb /dev/vdc" is not populating the
> > TEST_DEV_ARRAY array.
> >=20
> > Commit 653ace845911 ("check, new: introduce test_device_array()")
> > explains why:
> >=20
> >     As to the test target devices defined in TEST_DEVS variable, blktes=
ts
> >     assumes that each test case with test_device() function is run for =
each
> >     single device defined in TEST_DEVS. On the other hand, it is sugges=
ted
> >     to support a test case for not a single device but multiple devices=
.
> >=20
> > Maybe we could add a default config with all options listed and
> > documented but commented out.
>=20
> The default config would be useful for sure.

Agreed. It can be the file named "config.example".

> But I also thing the TEST_DEVS vs TEST_DEV_ARRAY thing is weird, and the
> fact that you need to declare the array for multiple tests doesn't help.
>=20
> IMHO having a TEST_DEV_ARRAY should imply that normal single device tests
> pick the first one from it if not explicit TEST_DEVS is set, and tests
> using multiple devices can grab as many as they support from it.  That
> would mirror what SCRATCH_DEV_POOL does in xfstests, which works very
> well.
>=20
> I'd love to help with this, but I'm not sure my bash abilities are
> enough for this :(

When I introduced TEST_DEV_ARRAY, the motivation was the test case md/003. =
It
was the first test case that required multiple devices for testing. It test=
s
"NMVe Atomic Writes with MD devices". My assumption was that users wants to
specify test target devices unique to md/003 which are different devices fr=
om
other test cases (special NVMe with atomic write capability). Based on this
understanding, I introduced the associative array config option
TEST_CASE_DEV_ARRAY[X/0??]=3D"/dev/Y /dev/Z", which can specify test target
devices unique to each test case (or multiple test cases specified with reg=
ular
expression). I think this TEST_CASE_DEV_ARRAY fits the use case of md/003.

On the other hand, reading the comment above, I find there is another diffe=
rent
expectation for testing with multiple devices. As to bcache/* test cases, t=
he
test target devices can be common to other test groups. I can understand th=
at
something similar as SCRATCH_DEV_POOL of fstests is desired to reduce the n=
umber
of config options to specify. We maybe able to introduce the new config opt=
ion
"TEST_DEV_POOL", which will work as described above: for most of the test
cases with test_device() function, blktests can pick up only the first devi=
ce
from TEST_DEV_POOL. If the test case has test_device_array(), all devices i=
n
TEST_DEV_POOL can be provided to test_device_array() through TEST_DEV_ARRAY=
.
The user can specify only TEST_DEV_POOL, to cover both test cases with
test_device() and those with test_device_array().

I will try to find my time to prototype TEST_DEV_POOL to see if the expecta=
tion
can be fulfilled.=
