
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include "vpd.h"

char *vpd_label( void ) {
    return "pseudo HV-VMM L0.61 for " PIP;
}

char *vpd_path( int n ) {
    /* Remember - this will change with CVMM L0.6 (i2c-1) */
    /* It changed - and I didn't remember... sigh */
    return "/sys/devices/platform/amba/ff030000.i2c/i2c-1/1-0052/eeprom";
}

/*
 * Configuration: pseudo HV-VMM L0.61
 */
void vpd_init( vpd_t *vpd ) {
    vpd->length       = 0x03FE;          /* 0000: length of block0 */
    vpd->version      = 0x0107;          /* 0002: VPD version 2.41 */
    vpd->block_length = 0x03FC;          /* 0004: block length */
    vpd->block_id     = 0x00;            /* 0006: block ID */
    vpd->_res_1       = 0x00;            /* 0007: reserved, set to 0x00 */

    F( vpd->vpd_id,   ""             );  /* 0008: VPD ID */
    F( vpd->pos_ext,  ""             );  /* 000A: POS ID extension */
    F( vpd->pos_id,   ""             );  /* 000C: POS ID */
    F( vpd->mtm,      ""             );  /* 000E: machine type / model, left-justified, pad with 0x20 */
    N( vpd->msn,      MSN            );  /* 0015: machine serial right-justified, pad with '0' */   /* PIP# */
    F( vpd->asset_id, ""             );  /* 001C: asset ID, left-justified, pad with 0x20 */
    F( vpd->card_pn,  "P-HV-VMM"     );  /* 003C: card part number, left-justified, pad with 0x20 */
    F( vpd->card_fru, "f1-EC8"       );  /* 0048: card FRU, left-justified, pad with 0x20 */
    N( vpd->card_sn,  ""             );  /* 0054: card serial number, right-justified, pad with '0' */
    F( vpd->card_psn, "805177"       );  /* 005A: card serial number prefix, left-justified, pad with 0x20 */
    F( vpd->mfg,      "ICSS"         );  /* 0060: system manufacturer, left-justified, pad with 0x20 */

    vpd->_res_2       = 0x00;            /* 0064: reserved, set to 0x00 */
    vpd->hw_rev       = 0x3D;            /* 0065: hardware revision */
    vpd->phy_a        = 'T';             /* 0066: physical characteristic: PCB raw card mfg */

    F( vpd->phy_b,    "3H"           );  /* 0067: physical characteristic: PCB raw material */

    vpd->phy_c        = 8;               /* 0069: physical characteristic: PCB layers */
    vpd->phy_d        = 0x3E;            /* 006A: physical characteristic: PCB thickness, in mils */

    F( vpd->mfg_dc,   "2135"         );  /* 006B: MFG date card, YYWW */
    Z( vpd->emac,     ""             );  /* 006F: Ethernet MAC (52:54:00:c4:a6:37) */
    Z( vpd->uuid,     ""             );  /* 009F: UUID (123e4567-e89b-12d3-a456-426614174000) */

    vpd->typecode     = ' ';             /* 00AF: type code */

    F( vpd->sciic,    ""             );  /* 00B0: "static component internal interface characteristics" */
    Z( vpd->block,    ""             );  /* 00C0: block0, use block1 if port I/F characteristics being used */

    vpd->block1       = 0x0400;          /* 00C8: block1 offset */
    vpd->block2       = 0x0800;          /* 00CA: block2 offset */
    vpd->block3       = 0x0C00;          /* 00CC: block3 offset */
    vpd->block4       = 0x1000;          /* 00CE: block4 offset */
    vpd->block5       = 0x1400;          /* 00D0: block5 offset */
    vpd->block6       = 0x1800;          /* 00D2: block6 offset */
    vpd->block7       = 0x1C00;          /* 00D4: block7 offset */
    vpd->_res_3       = 0x00;            /* 00D6: reserved, set to 0x00 */
    vpd->subcode      = 0x00;            /* 00D7: type subcode */
    vpd->ina_en       = 0x00000000;      /* 00D8: INA enterprise number */
    vpd->ina_pid      = 0x0000;          /* 00DC: INA product ID */

    Z( vpd->_res_4,   ""             );  /* 00DE: reserved, set to 0x00 */

    vpd->consume      = 0x0004;          /* 00F0: max power consumed in 1 watt increments */
    vpd->produce      = 0x003C;          /* 00F2: max power produced in 1 watt increments */

    Z( vpd->_res_5,   ""             );  /* 00F4: reserved, set to 0x00 */

    F( vpd->mfg_id,   ""             );  /* 0100: subsystem mfg ID, left-justified, pad with 0x20 */

    Z( vpd->clei,     ""             );  /* 0104: CLEI code assignment */
    Z( vpd->_res_6,   ""             );  /* 010E: reserved, set to 0x00 */
    F( vpd->oem_vpd,  ""             );  /* 0280: OEM base VPD */
    F( vpd->oem_ext,  ""             );  /* 0340: OEM extended VPD */
    Z( vpd->_res_7,   ""             );  /* 03C0: reserved, set to 0x00 */
}
