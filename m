Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C766615A864;
	Tue, 17 Feb 2026 07:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771314171; cv=fail; b=S/MQZdo4d1KLcG4GwxX297d9d56gVXAMz0WJrrcejGK5kOsl8xCGARU8wjVSl9tQ7qaG3Ta3mDkFZ798E9yLK9S56RjH/z6WIaJ3wZOZAS3umzHsYNkvD4lryvm8gwsFK29GAR7QdjO/qZ4oWrXdZ2ISsZ29mPegSHFGVAtwgNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771314171; c=relaxed/simple;
	bh=UFiqeazZpMU/NWsJwrRzVQQJm3brG7giSeSD84jMSio=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qhgqZJ7mEDLALDdhsqyDCc9kI/852Ep0jUdXb0ou0ToBpQzggnUN8E0f/keMbL+9x+C0sNNlLPoL6s/P2TP47aP3nGZiXLCEVYPXea6fZO8x5UhpRI9gANDQgwITtyZZRGFbWfkxyjHRv0FzTaWZM01sdSf9i/l52tKhf3Eg80M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=e/MFBYej; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ZBUDOyAB; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="e/MFBYej";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZBUDOyAB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1771314169; x=1802850169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UFiqeazZpMU/NWsJwrRzVQQJm3brG7giSeSD84jMSio=;
  b=e/MFBYej4W77uy0AZ08718Q2naKaXKJA5UQGrSB1WfM/3/ZXxuZcZ88H
   gtSjblhgxhE5udPfdA6yI7ENncKqOLLCfCDPxW30rh3wHamYLAcGCv+ki
   kOmrqa2VUvsX69zciQi0+NzfY2DDU6cvOeRz3IUopiGZmhxwmFPlyKR3M
   zjS1daLVDPL8K4yW8q3tP0mtvwSIdZt/dPyXHzWEaNH96o/515A1B5JdK
   dwiR8Kejy+Izlco5yMBqw6V09ZlT9eHiaZ3MPv386RqG6P8jFEhHsd8e3
   mXEdsBttVtM740llaiLpjiUSCnQ5JDkl3pkPQhjt2G4SrB7YUsoyf4pXo
   w==;
X-CSE-ConnectionGUID: k8geeySjTNuCiBpX03IojQ==
X-CSE-MsgGUID: r0LiwBfCRm+M1TmxATgz/Q==
X-IronPort-AV: E=Sophos;i="6.21,295,1763395200"; 
   d="scan'208";a="139978329"
Received: from mail-westus3azon11010002.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.2])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Feb 2026 15:42:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HV6x5K67AH/V3FgsmO03Evp8FOd2E1wAxB+MsKOLDh4G1dHdXZJ8u3TEylJo9EMjM5xiP5yR32nGfm7f9d2PKZ2TFXDqvKPYoDAThtRysDk8ufMjy3wn1EcVJ+VlyTIb9VfGApxdq7TWYEycoyQobdXa4dDtTCZ41aHZt7OMc1DPMdJ16ZiVFxKg3aLhEjzIVm/0kXk1suocWHqJZDgh1w/y/GUvNNkwA0/VQ3RijtwwrIZuDnvZrBnPT2cq7w+CkuolfxIQV6ApkOCsizTEclIoEU39YWjM+Ovwi2Z2MlSpm2FJ7Ll93jxffzyyPdJrDWwdYih3BafaNkDKzI9Iwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ekD2hTmHDeoxUoGa7VMJrPmGi1rhKivgZf53k4h8Yyc=;
 b=WjCAKNIw9rQeV6ObvrY59zgFThth7T3pErAgeJK+Fv+9eyQ3tMuXPdneKQZzwiJiqVVmOV/Vhe6k+l/wf7lKNLri28U3WWS9r6v5jW3JzOjbHhVVMew30k+YQ40g/xlxmm7qvefLIUp/3kBpIigIv5vPn632d/MltyizdgUr6/jjN07KS81aiOziOG62eUvd3v9LA1JxoBoykX8tH5gbLvutK8c2myQfosEHpUycVq8JGdUsvGEBBN5qZoL1FKFX4aWkhvcXI7KYGrdHCyQsBQtkJ92/TLfRxN/Msu+cyR4tfmLDNxS8ePNgW+RWhL3fv74mS2entl3F6uldWL+/8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekD2hTmHDeoxUoGa7VMJrPmGi1rhKivgZf53k4h8Yyc=;
 b=ZBUDOyAB8ZH+/70geuR95Vpab9xLUmoTWlK8+BRfeGCzGI2OqzZNgjXPxmvuilMyycwg8vPWSSx8JgLxm0XqyEN7SnOgBanyvLusq3IhzYG/UQzj6Qc18jIRXvTKlBdEjY0tIjPWfDgMCI/WJgiEhOnAkC8yBlYcmCwy1pXBcMw=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by DSWPR04MB9921.namprd04.prod.outlook.com (2603:10b6:8:35e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 07:42:42 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%5]) with mapi id 15.20.9611.008; Tue, 17 Feb 2026
 07:42:41 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Daniel Wagner <dwagner@suse.de>
CC: "hch@infradead.org" <hch@infradead.org>, Stephen Zhang
	<starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, Coly
 Li <colyli@fnnas.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v4 1/3] bcache: add bcache/001
Thread-Topic: [PATCH blktests v4 1/3] bcache: add bcache/001
Thread-Index: AQHcnDOeXeV1LJafM0ab7n+J2mERgrWGiXKA
Date: Tue, 17 Feb 2026 07:42:41 +0000
Message-ID: <aZQZkjEUw9VnVauX@shinmob>
References: <20260212-bcache-v4-0-215f3fde1c84@suse.de>
 <20260212-bcache-v4-1-215f3fde1c84@suse.de>
In-Reply-To: <20260212-bcache-v4-1-215f3fde1c84@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|DSWPR04MB9921:EE_
x-ms-office365-filtering-correlation-id: 12bda473-89ff-4fdc-e500-08de6df821b6
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|19092799006|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?UszQQyShmMKRAM35ThaNaAnfbeDR21E38H+AtnkEX0WpnklyeHESNApWTXM4?=
 =?us-ascii?Q?P7cX6hhbyznw3iN1BuGz9y9Um/p4XikkpEFhviCAQY+pdge/Kr10rVb4OARU?=
 =?us-ascii?Q?LMfDXe1NIsqiPTE15vdO0RTA98LU2vl+7rFmT50BhsYrNQzFSgb7HH3YHnqs?=
 =?us-ascii?Q?gdzpCZ9sQR2NRSnA+OEL/GqABjigHlGxkLCi/9xgbRJ+TX2A+3pYyMo8ctVE?=
 =?us-ascii?Q?Z2r0357h/PI63agsXBD71HyznmUGATKWGonBwhl89lktxsZaSGpwbJykl3YV?=
 =?us-ascii?Q?6gP+kc2WTzVbnmKcbRYbqvIrJbcZ0thCAKcm7JBEV/2P4AWvwAmIuS1PdtyA?=
 =?us-ascii?Q?t2q/1AV3/X+7R8N2MC+MByRpEpH0neYql8OCdtKtRCxS6G8P1/UKsAesCvPB?=
 =?us-ascii?Q?Pz174WQywtzyK2Mh7zunfXOJILgqS4Hd2T5e7OcHqJ8rt7LO4AyKD+D/Qnoj?=
 =?us-ascii?Q?Kkmz3+VU/M6dVooFGpaTDHxZh+diJJ42pPcZM/g58xUn8hRDZ7uDbepIuURh?=
 =?us-ascii?Q?gDg66JCYu7PVfg6uy2QivhqZsUrVtfQ4IsVLwVjuvpuAsFPrwkzZ5/kv+/t9?=
 =?us-ascii?Q?9ixw8cdzPhTvcFTvQxNJ+yjnjQ5K0ntErPN9ezAPrAJw+Zvudlsia/v9GMkT?=
 =?us-ascii?Q?AflVeTRcfuBnf/pVp19gP23mrnDyWWeFlcNYykd8FqIs8LZB7W/7FThXi5k0?=
 =?us-ascii?Q?QgtqVZT7UEoP5X+Wze7+ma/DMNXVFVstSbiMNQX6JnxdJUwR4NAkVw2lYOf6?=
 =?us-ascii?Q?G+u45lOpiuAZKXf1uCh2SXiXAALSV99OOHddVP/oEoQ2hWpDiYD851t+hK1F?=
 =?us-ascii?Q?ZbTJa9RH7hy05YQkJ6PULSJrChi4ZqG434guj/435Hf8v0+40Ew3LduabDdR?=
 =?us-ascii?Q?7ATF6duUjgqZRKD4w9zdfZr3QaxaswxVo/tBh1RHA2259slSz7L+K0o6AIwU?=
 =?us-ascii?Q?PrKU3MmUldGh5NAjqq1lv2Rt+Ma4AUFJtbU7SV/zBlwaq2gXq6jQKM8p+yLb?=
 =?us-ascii?Q?MWKsKz7QkJQrjwk6lCrEZHZTUeuCEqKvDHAQwqDWbF86wkRs0mPoWFwXsjxn?=
 =?us-ascii?Q?QqiqPzXsoQlNi5v8hwQJvLGXBwEw4zVaNeRTx+dGa5HUqLlk2V3jTryQEALk?=
 =?us-ascii?Q?9pK2sZVQVxqe7WAPoBF9bhNuo60LQu0n/jxVCUWXB1zlq2dJ9/kLMVSdtiQV?=
 =?us-ascii?Q?yTOSLgp1fK+tjcAq/pRT+ANBaxeVNAnMQVmthEAkj3WSJdRRcqi3gQvpIHku?=
 =?us-ascii?Q?+XwrALc23w7naLRG6Q3s0s+HNA7plsDt9c6lkRs7Tirp/ErDX/soLLkrZQes?=
 =?us-ascii?Q?bVi184MfCTKzbgoHdtteMBIr9ubzFtraIeVbbdXg9tvRiro4hXXkGYCpi2Rw?=
 =?us-ascii?Q?de4zzS0MBf6MBtTpqOj0so3/yw/WYQhaVqI2zgDzXbszJxxVezwJ6ZZzlqjQ?=
 =?us-ascii?Q?ey915g9oB9i2yT9Zoui9aSW/JEW4B4IHPIa25yF6QoKdgES2ffA/lHyxxvzU?=
 =?us-ascii?Q?9gnet8M2d+CD0H7Fg4X8ApohYmoXeUU8S1q/miytn3t8BveqfCNIP+h8xLTv?=
 =?us-ascii?Q?LGWpyz1JOSVtU2vjTbz5VD19kyK0FpglraA+YlNodl8E5gWmMLM9qhRQ59v8?=
 =?us-ascii?Q?cw0/Q01FMSugCD88u6MHAfs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?k1GMhG0DgdE9kINjb1yC1DwRQDgf1yvoemqcjfYe8qRUhT9tL7XwBUx6u6fS?=
 =?us-ascii?Q?BhtZVHB68zchb+NmfN4eu7qKT/9JzKwzOef/KfqoM9yKmAoeq4pcHK0UpMX0?=
 =?us-ascii?Q?a902UR3oMGIcloRGM5ZIP21lEMh/Sb56S2l2//L7vc0YY2Y+xohrwaT6W7sO?=
 =?us-ascii?Q?OS1dLluuTjqlGfHs0vOz5rbBmjuRJtmPJbn1m1BJwaOa5glPDjSC3deHzwsQ?=
 =?us-ascii?Q?YzXz1zEpFPDJgcHut25/8+BLxVFZ/lFTJgdfTuCspd0uJsgdIQ14KUZQNSAx?=
 =?us-ascii?Q?ogQFFNkqfJCe/aSKUOB1uYzENMXgiauErvDoJFrylreUfeQgLUGAou94hOzW?=
 =?us-ascii?Q?19WH3GS+duX+SZvpcvitJ0XqT5cFhNdUG0obYN/nJqvkmb+gke4+91wYUeHR?=
 =?us-ascii?Q?zhTx3QhpRFI2btOJG7b/XBeYaGJDP24dEJaCq8Hd9cXbgSXkJ3gJ+YNNikrU?=
 =?us-ascii?Q?Vv4dlVvbjAc7WDZAyeUnxjO6+gQu8MHBIhiwJyNRMtmXyoPQEv+0lQIDiQ2y?=
 =?us-ascii?Q?QrZQEsk8bYVqTWxBGk4CDNQTXpk06hiE1ylS3r+BRbIS/6kKq/v1rNhnBVp6?=
 =?us-ascii?Q?ia8JNOFMGpuAPU9qZxpgR8Hslk3ZSzoMNTMyyrbEtpZ6mbCENKUog0u+UmtL?=
 =?us-ascii?Q?+CZcE400zIq+PlPq57TzmdpOIl5yytD3Vkhf2SlvFUxqOXh79+p544BS6awj?=
 =?us-ascii?Q?ykC8sfok2R1mrcTerLFJT9pKU7HGI9K3Y/wZ9jhM1x5wD4uNw1nFW//M3hrh?=
 =?us-ascii?Q?8DalZhdP9ttnwpd4Tk97yaP2yptQDUFqmF/oZgDVaagP7SugcGecsCnsV6vC?=
 =?us-ascii?Q?6wAoIBt6HcJlLhd5R23hiPgwYI4/7DP9OAOTdTfOntTtHL4BWphsJUKYmth4?=
 =?us-ascii?Q?mKUKjvlJgOMjIeQ3am5ObsmzTrgVEows5AnKMV9/S9i7mExvn73jNGlDwnCE?=
 =?us-ascii?Q?My6rJ6ATVz5bnVRDI0lrQACi7TZOhLa7hccorvyGZA8OyBXX4dqUrb1t6Klp?=
 =?us-ascii?Q?2F3u0rQI8vXBsoThcy6BmMt2oPCg5jCBx74Kxy9ZaL6xjcUjm4hbd4EBdDKw?=
 =?us-ascii?Q?JkSgcZMeC6j0wr6NW1JWWdHhhpqsd1S38g7MyXopQ/BV6p1wgjUC5xii8ofo?=
 =?us-ascii?Q?zfz6EELiIfKzZm+ZF7Y7V4gIyopvV8OyeRK9VQouX6/aFqQrQYz1rQToJZ0z?=
 =?us-ascii?Q?6AUEoOY0+r68CPlqpeXWVuq4VjLeIH2nzwjVv2UMgD4wP5qJZIu6aJvokaMd?=
 =?us-ascii?Q?MN0q7focbm71euxu8TWgE1ft6Cu3sWxRFRt/J887f5slS6HqUmK8CLKJ+c1H?=
 =?us-ascii?Q?EEkkExJZlDE/WGRxd7beZ+XVIbQPPwjE+7dKIM+ytzh4cpTnzWvPYRsEFyfg?=
 =?us-ascii?Q?N8klzmF266Je9fRBejV2Phvzd2bHWfSNuME+72M/bIuBrGYpiZEznR9jZNzV?=
 =?us-ascii?Q?CkqJlpFnZyP84fYzuatclw9DFwr6N1xU1gHUx3FqU7HImYfd6rNB4RHbBgHR?=
 =?us-ascii?Q?HwY+0aykctsfIWn4Ioa1waSB0Rs32P8n3kRFcZxvfXHDV1xrUVtOW9vtJg5D?=
 =?us-ascii?Q?jBURYiF118r0bw1oIMAoTMGb4dkHxw5sPk298da6C4UuEnpSLTb+FpZT8qOA?=
 =?us-ascii?Q?Xbb0ZHpl5cgBfu97MiYDNsiUNooscs3QtAKK1ge2nG8gpwwcnfs8wOJEw2Fr?=
 =?us-ascii?Q?se+RUu3LLtdyfkrYJgsmCVH3G02wVWoyXo60DAGsrRwMiD37r00/0GZvP8To?=
 =?us-ascii?Q?MBRI30Xw3dOXlrHT+cWwMS0EX9sVCdA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32D00A657F75BA4D8E79EB4439693DF9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OtmnKhNJoLCvbG2VsUpjwUmGcQcYwjX56ie5h9JWWE2ZnVyPYsfAPCUfWlvPj8mzD4BdVoyaAcbSPdZ6WnQYLR359l8a4bvz7NyRENsYK4GiQXX95mauvdpbl9T4cXo/3OpbSWzV656+rvr0uvJmV27nGDdvKmmens6FRk8JIk8ZR4FuogBwFIOCK50oPN+QMsMOzsnLynm+LoDm72gMcdBJxDHAOR47ZwhoxhOU8pzeCEsR9NrUCo3uZaghDmC2EtgGOyf95urBe1UJs/p+o6hJu111rHKkvhtrZNI+pMKl7le2Q5mNBkn14VYgmGvogq8rMuiJK+x+F0LV+iJUQdfko0o9zFWf25JXfdGmO6MFjrPyZXTbxHnbkZZBnGth8esTakFqdWtWy1+JVlZpaGVWdr/V+NbOim3v9d4Iv8ukDKgNtVc59WzuD60mgofRpABP9GGHP/jIXDB2O0Mk6yc/ZHqXFhOibj/ZKvy7Bo8quI6m69xH27EOucPajJwc11IlZGqIaEupA8T9BySEUq2Gc1Y0+xJ/aVJZkHYRW+2SJvdhFsP8M1NQyk8oofwLYDDO6XA0xYv/EW9SGmVL6+FbOC9PXENsMxI2F+7Q85OIdI8C+d5bDbfw0cSd5DrU
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12bda473-89ff-4fdc-e500-08de6df821b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2026 07:42:41.7505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6pDt29LeaSaX7qZcKXJTRBRxkLwWMGPzhUoUU4mJiGesbIiIREtT41DLFMqF7CKiUPUcnlvz6wgDf8gQHC3BdQ0CHjzWo958o2Inf3+VF7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR04MB9921

Thanks. I ran this test case and it passes in my environment. Good.

Please find my comments in line. Most of them are nit ones, and I do no
care them much. Just wanted to hear your opinion about my comment on partpr=
obe.

On Feb 12, 2026 / 16:23, Daniel Wagner wrote:
[...]
> diff --git a/tests/bcache/001 b/tests/bcache/001
> new file mode 100755
> index 000000000000..7258d87566cb
> --- /dev/null
> +++ b/tests/bcache/001
[...]
> +test_device_array() {
> +	echo "Running ${TEST_NAME}"
> +
> +	if [[ ${#TEST_DEV_ARRAY[@]} -lt 3 ]]; then
> +		SKIP_REASONS+=3D("requires at least 3 devices")
> +		return 1
> +	fi
> +
> +	_setup_bcache "${TEST_DEV_ARRAY[@]}"
> +
> +	local bcache_nodes

Nit: I think "local -a bcache_nodes" is the better.

[...]

> diff --git a/tests/bcache/rc b/tests/bcache/rc
> new file mode 100644
> index 000000000000..cfd4094c2fe0
> --- /dev/null
> +++ b/tests/bcache/rc
> @@ -0,0 +1,375 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-3.0+
> +# Copyright (C) 2026 Daniel Wagner, SUSE Labs
> +
> +. common/rc
> +
> +declare BCACHE_DEVS_LIST
> +
> +BCACHE_MAX_RETRIES=3D5
> +
> +group_requires() {
> +	_have_kernel_options MD BCACHE BCACHE_DEBUG AUTOFS_FS
> +	_have_program make-bcache
> +	_have_crypto_algorithm crc32c
> +}
> +
> +_bcache_wipe_devs() {
> +	local devs=3D("$@")
> +	local dev
> +
> +	for dev in "${devs[@]}"; do
> +		# Attempt a clean wipe first
> +		if wipefs --all --quiet "${dev}" 2>/dev/null; then
> +			continue
> +		fi
> +
> +		# Overwrite the first 10MB to clear stubborn partition tables or metad=
ata
> +		if ! dd if=3D/dev/zero of=3D"${dev}" bs=3D1M count=3D10 conv=3Dnotrunc=
 status=3Dnone; then
> +			echo "Error: dd failed on ${dev}" >&2
> +		fi
> +
> +		# Wipe the Tail (Last 5MB)
> +		# bcache often places backup superblocks at the end of the device.
> +		local dev_size_mb
> +		dev_size_mb=3D$(blockdev --getsize64 "$dev" | awk '{print int($1 / 102=
4 / 1024)}')
> +
> +		if [ "$dev_size_mb" -gt 10 ]; then
> +			local seek_pos=3D$((dev_size_mb - 5))
> +			dd if=3D/dev/zero of=3D"${dev}" bs=3D1M count=3D5 seek=3D$seek_pos co=
nv=3Dfsync status=3Dnone
> +		fi
> +
> +		# Refresh kernel partition table & wait for udev
> +		partprobe "$dev" 2>/dev/null

I think _have_program partprobe is required, or can we replace it with
"blockdev --rereadpt"?

> +		udevadm settle
> +
> +		# Try wiping again after clearing the headers
> +		if ! wipefs --all --quiet --force "${dev}"; then
> +			echo "Warning: Failed to wipe ${dev} even after dd." >&2
> +		fi
> +	done
> +}
> +
> +_bcache_register() {
> +	local devs=3D("$@")
> +	local dev timeout=3D0
> +
> +	while [[ ! -w /sys/fs/bcache/register ]] && (( timeout < 10 )); do
> +		sleep 1
> +		(( timeout ++ ))
> +	done
> +
> +	if [[ ! -w /sys/fs/bcache/register ]]; then
> +		echo "ERROR: bcache registration interface not found." >&2
> +		return 1
> +	fi
> +
> +	for dev in "${devs[@]}"; do
> +		local tmp_err
> +
> +		tmp_err=3D"/tmp/bcache_reg_$$.err"
> +		if ! echo "${dev}" > /sys/fs/bcache/register 2> "${tmp_err}"; then
> +			local err_msg
> +
> +			err_msg=3D$(< "${tmp_err}")
> +			if [[ "${err_msg}" !=3D *"Device or resource busy"* ]]; then
> +				echo "ERROR: Failed to register ${dev}: ${err_msg:-"Unknown error"}"=
 >&2
> +			fi
> +		fi
> +		rm -f "${tmp_err}"
> +	done
> +}
> +
> +_create_bcache() {
> +	local -a cdevs=3D()
> +	local -a bdevs=3D()
> +	local -a ARGS=3D()
> +	local -a created_devs=3D()
> +	local bucket_size=3D"64k"
> +	local block_size=3D"4k"

Nit: I think "local dev" can be added here.

> +
> +	while [[ $# -gt 0 ]]; do
> +		case $1 in
> +			--cache)
> +				shift
> +				# Collect arguments until the next flag or end of input
> +				while [[ $# -gt 0 && ! $1 =3D~ ^-- ]]; do
> +					cdevs+=3D("$1")
> +					shift
> +				done
> +				;;
> +			--bdev)
> +				shift
> +				# Collect arguments until the next flag or end of input
> +				while [[ $# -gt 0 && ! $1 =3D~ ^-- ]]; do
> +					bdevs+=3D("$1")
> +					shift
> +				done
> +				;;
> +			--bucket-size)
> +				bucket_size=3D"$2"
> +				shift 2
> +				;;
> +			--block-size)
> +				block_size=3D"$2"
> +				shift 2
> +				;;
> +			--writeback)
> +				ARGS+=3D(--writeback)
> +				shift 1
> +				;;
> +			--discard)
> +				ARGS+=3D(--discard)
> +				shift 1
> +				;;
> +			*)
> +				echo "WARNING: unknown argument: $1"
> +				shift
> +				;;
> +		esac
> +	done
> +
> +	# add /dev prefix to device names
> +	cdevs=3D( "${cdevs[@]/#/\/dev\/}" )
> +	bdevs=3D( "${bdevs[@]/#/\/dev\/}" )
> +
> +	# make-bcache expects empty/cleared devices
> +	_bcache_wipe_devs "${cdevs[@]}" "${bdevs[@]}"
> +
> +	local -a cmd
> +	cmd=3D(make-bcache --wipe-bcache \
> +			--bucket "${bucket_size}" \
> +			--block "${block_size}")
> +	for dev in "${cdevs[@]}"; do cmd+=3D("--cache" "${dev}"); done
> +	for dev in "${bdevs[@]}"; do cmd+=3D("--bdev" "${dev}"); done
> +	cmd+=3D("${ARGS[@]}")
> +
> +	local output rc
> +	output=3D$("${cmd[@]}" 2>&1)
> +	rc=3D"$?"
> +	if [[ "${rc}" -ne 0 ]]; then
> +		echo "ERROR: make-bcache failed:" >&2
> +		echo "$output" >&2
> +		return 1
> +	fi
> +
> +	local cset_uuid
> +	cset_uuid=3D$(echo "$output" | awk '/Set UUID:/ {print $3}' | head -n 1=
)
> +	if [[ -z "${cset_uuid}" ]]; then
> +		echo "ERROR: Could not extract cset UUID from make-bcache output" >&2
> +		return 1
> +	fi
> +
> +	local -a bdev_uuids
> +	mapfile -t bdev_uuids < <(echo "$output" | awk '
> +	  $1 =3D=3D "UUID:" { last_uuid =3D $2 }
> +	  $1 =3D=3D "version:" && $2 =3D=3D "1" { print last_uuid}
> +	')
> +
> +	_bcache_register "${cdevs[@]}" "${bdevs[@]}"
> +	udevadm settle
> +
> +	for uuid in "${bdev_uuids[@]}"; do
> +		local link found
> +
> +		link=3D/dev/bcache/by-uuid/"${uuid}"
> +		found=3Dfalse
> +
> +		for ((i=3D0; i<BCACHE_MAX_RETRIES; i++)); do
> +			if [[ -L "${link}" ]]; then
> +				created_devs+=3D("$(readlink -f "${link}")")
> +				found=3Dtrue
> +				break
> +			fi
> +
> +			# poke udev to create the links
> +			udevadm trigger "block/$(basename "$(readlink -f "${link}" 2>/dev/nul=
l || echo "notfound")")" 2>/dev/null
> +			sleep 1
> +		done
> +
> +		if [[ "${found}" =3D=3D "false" ]]; then
> +			echo "WARNING: Could not find device node for UUID ${uuid} after ${BC=
ACHE_MAX_RETRIES}s" >&2
> +		fi
> +	done
> +
> +	printf "%s\n" "${created_devs[@]}"
> +}
> +
> +_remove_bcache() {
> +	local -a cdevs=3D()
> +	local -a bdevs=3D()
> +	local -a csets=3D()
> +	local -a bcache_devs=3D()
> +	local uuid
> +
> +	while [[ $# -gt 0 ]]; do
> +		case $1 in
> +			--cache)
> +				shift
> +				# Collect arguments until the next flag or end of input
> +				while [[ $# -gt 0 && ! $1 =3D~ ^-- ]]; do
> +					cdevs+=3D("$1")
> +					shift
> +				done
> +				;;
> +			--bdev)
> +				shift
> +				# Collect arguments until the next flag or end of input
> +				while [[ $# -gt 0 && ! $1 =3D~ ^-- ]]; do
> +					bdevs+=3D("$1")
> +					shift
> +				done
> +				;;
> +			--bcache)
> +				shift
> +				# Collect arguments until the next flag or end of input
> +				while [[ $# -gt 0 && ! $1 =3D~ ^-- ]]; do
> +					bcache_devs+=3D("$1")
> +					shift
> +				done
> +				;;
> +			*)
> +				echo "WARNING: unknown argument: $1"
> +				shift
> +				;;
> +		esac
> +	done
> +
> +	for dev in "${bcache_devs[@]}"; do
> +		local bcache bcache_dir
> +
> +		if mountpoint -q "${dev}" 2>/dev/null; then
> +			umount -l "${dev}"

Nit: The -q and -l options can be replaced with longer one for readability,
     --quiet and --lazy.

> +		fi
> +
> +		bcache=3D"${dev##*/}"
> +		bcache_dir=3D/sys/block/"${bcache}"/bcache
> +		if [ -f "${bcache_dir}"/stop ]; then
> +			echo 1 > "${bcache_dir}"/stop
> +		fi
> +	done
> +
> +	# The cache could be detached, thus go through all caches and
> +	# look for the cdev in there.
> +	local cset_path
> +	for cset_path in /sys/fs/bcache/*-*-*-*-*; do
> +		local cache_link match_found
> +
> +		match_found=3Dfalse
> +		for cache_link in "${cset_path}"/cache[0-9]*; do
> +			local full_sys_path _cdev cdev
> +
> +			full_sys_path=3D"$(readlink -f "$cache_link")"
> +			_cdev=3D"$(basename "${full_sys_path%/bcache}")"
> +
> +			for cdev in "${cdevs[@]}"; do
> +				if [ "${_cdev}" =3D=3D "$(basename "${cdev}")"  ]; then
> +					match_found=3Dtrue
> +					break 2
> +				fi
> +			done
> +		done
> +
> +		if [ "${match_found}" =3D false ]; then
> +			continue
> +		fi
> +
> +		cset=3D"$(basename "${cset_path}")"
> +		if [ -d /sys/fs/bcache/"${cset}" ]; then
> +			echo 1 > /sys/fs/bcache/"${cset}"/unregister
> +			csets+=3D("${cset}")
> +		fi
> +	done
> +
> +	udevadm settle
> +
> +	local timeout
> +	for cset in "${csets[@]}"; do
> +		timeout=3D0
> +		while [[ -d /sys/fs/bcache/"${cset}" ]] && (( timeout < 10 )); do
> +			sleep 0.5
> +			(( timeout++ ))
> +		done
> +	done
> +
> +	_bcache_wipe_devs "${cdevs[@]}" "${bdevs[@]}"
> +}
> +
> +_cleanup_bcache() {
> +	local cset dev bcache bcache_devs cset_path

Nit: I think 'bdev' can be added in the list above.

> +	local -a csets=3D()
> +
> +	read -r -a bcache_devs <<< "${BCACHE_DEVS_LIST:-}"
> +
> +	# Don't let successive Ctrl-Cs interrupt the cleanup processes
> +	trap '' SIGINT
> +
> +	shopt -s nullglob
> +	for bcache  in /sys/block/bcache* ; do
> +		[ -e "${bcache}" ] || continue
> +
> +		if [[ -f "${bcache}/bcache/backing_dev_name" ]]; then
> +			bdev=3D$(basename "$(cat "${bcache}/bcache/backing_dev_name")")
> +
> +			for dev in "${bcache_devs[@]}"; do
> +				if [[ "${bdev}" =3D=3D "$(basename "${dev}")" ]]; then
> +					echo "WARNING: Stopping bcache device ${bdev}"
> +					echo 1 > /sys/block/"${bdev}"/bcache/stop 2>/dev/null
> +					break
> +				fi
> +			done
> +		fi
> +	done
> +
> +	for cset_path in /sys/fs/bcache/*-*-*-*-*; do
> +		local cache_link match_found
> +
> +		match_found=3Dfalse
> +		for cache_link in "${cset_path}"/cache[0-9]*; do
> +			local full_sys_path cdev
> +
> +			full_sys_path=3D"$(readlink -f "$cache_link")"
> +			cdev=3D"$(basename "${full_sys_path%/bcache}")"
> +
> +			for dev in "${bcache_devs[@]}"; do
> +				if [ "${cdev}" =3D=3D "$(basename "${dev}")" ]; then
> +					match_found=3Dtrue
> +					break 2
> +				fi
> +			done
> +		done
> +
> +		if [ "${match_found}" =3D false ]; then
> +			continue
> +		fi
> +
> +		cset=3D"$(basename "${cset_path}")"
> +		if [ -d /sys/fs/bcache/"${cset}" ]; then
> +			echo "WARNING: Unregistering cset $(basename "${cset}")"
> +			echo 1 > /sys/fs/bcache/"${cset}"/unregister
> +			csets+=3D("${cset}")
> +		fi
> +	done
> +	shopt -u nullglob
> +
> +	udevadm settle
> +
> +	local timeout
> +	for cset in "${csets[@]}"; do
> +		timeout=3D0
> +		while [[ -d /sys/fs/bcache/"${cset}" ]] && (( timeout < 10 )); do
> +			sleep 0.5
> +			(( timeout++ ))
> +		done
> +	done
> +
> +	_bcache_wipe_devs "${bcache_devs[@]}"
> +
> +	trap SIGINT
> +}
> +
> +_setup_bcache() {
> +	BCACHE_DEVS_LIST=3D"$*"
> +
> +	_register_test_cleanup _cleanup_bcache
> +}
>=20
> --=20
> 2.53.0
> =
