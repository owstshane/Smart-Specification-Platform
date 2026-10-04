# Device Type ID Standard and Library Restructure

**Status: DRAFT FOR SIGN-OFF. Nothing has been applied to the database.**
Prepared 4 Oct 2026 from Shane's review request, the live global library (127 types) and the latest project schedule (approx. 250 types).

---

## 1. Decisions already agreed (Shane, 4 Oct 2026)

1. **Global library holds families, projects assign the number.** The global library stops carrying variant numbers. A family is the generic thing (SPK-IC, in-ceiling speaker). When a family is pulled into a project and a product chosen, the project assigns the next number for that family: SPK-IC-1, SPK-IC-2. The same product can be number 1 on one project and number 3 on another.
2. **Pre-wire is a placement flag, not a device type.** No more -PREP twin types. "Pre-wire only" is set where the device is placed; schedules, exports and GA pins show a Pre-wire badge, and pre-wire placements are excluded from power and network load calculations.
3. **Accessories in two stages.** Now: mounts and wallboxes become standalone families with their own prefixes (MNT, WBX). Later stage: "goes with" links so placing a display offers its mount and wallbox and they share the GA position.
4. **Cinema keeps the C- prefix.** C SEED folds into normal families with C SEED as the product.
5. **Existing projects are grandfathered.** They keep their current copied codes untouched. The new standard applies to the global library and to new pulls only.

---

## 2. The format

```
FAMILY  =  FUNCTION - QUALIFIER(S)          (global library)
TYPE    =  FUNCTION - QUALIFIER(S) - N      (assigned in the project)
DEVICE  =  FUNCTION - LOCATION - NN         (physical unit, assigned at placement)
```

Example, end to end:

| Level | Example | Meaning |
|---|---|---|
| Family (global) | SWX-24P | Any 24-port PoE switch |
| Products (global catalogue) | Meraki MS130-24P, Catalyst C9300-24P | Approved choices for that family |
| Project type | SWX-24P-1 | This project's chosen 24-port switch (the Meraki) |
| Physical device | SWX-Z1-01 | First switch in rack zone Z1 |

### Rules

1. **The prefix always says what the thing is.** Never a brand, never a system name. SWX is a switch wherever it lives (IT rack, security enclosure, AV network).
2. **No product details in type codes.** Model numbers, brand names and wattages live on the product, not the type. AMP-8-2K8 becomes AMP-8CH-1 with "Powersoft Unica 8M 2K8" as the product.
3. **Qualifiers describe the engineering requirement**, the things that make products interchangeable: mounting (IC, IW, FS, WM, DM, TT), size in inches (65, 98), ports (24P, 48P), channels (2CH, 8CH), zones (4Z, 8Z), rack height in rack units (38U, 44U), card form (-C), exterior rating (EXT), served discipline (SEC, LT). Rack widths and depths (600, 800, 1000mm) stay on the product: they are brand-specific (US brands are built in inches), while RU height is universal.
4. **Families are broad on purpose.** Two different dome cameras are one CAM-DOME family with two products; the project numbers (CAM-DOME-1, CAM-DOME-2) do the telling-apart. Merging families is safe because the split happens per project.
5. **The variant number is always last and only exists in projects.** The global library never carries one.
6. **Numbering is per family per project**, assigned automatically when a product is chosen, starting at 1.
7. **Left and right are placements, not types.** The latest project had SBAR-L and SBAR-R as separate types with the identical product. Under this standard that is one project type placed twice.

### Prefix dictionary

| Prefix | Meaning | Prefix | Meaning |
|---|---|---|---|
| AMP | Amplifier | MNT | Mount (display, camera, intercom) |
| AP | Wireless access point | NVR | Network video recorder (future) |
| AVOIP | AV-over-IP (DEC, ENC, FRAME; -C = card) | OS | Occupancy sensor |
| C- | Cinema namespace (C-SPK, C-PROC...) | PB | Push button |
| CAM | Camera | PC | Computer / peripheral |
| CB | Cabin box | POE | PoE injector / extender |
| CONF | Conferencing | PRN | Printer |
| CTRL | Control system (processor, interface) | PROC | AV / audio processor |
| DISP | Display / videowall | PWR | Power (UPS, PDU, conditioner, surge) |
| DOCK | Docking accessory | RACK | Equipment rack |
| ENC | Equipment enclosure | REM | User remote / touch panel / tablet |
| FBR | Fibre infrastructure | RLY | Relay |
| FW | Firewall / UTM | SBAR | Soundbar |
| ICOM | Intercom | SEC | Security head-end (panel, station) |
| KP | Keypad (KP-LT lighting, KP-SEC access) | SHD | Window treatments (shades) |
| LAN | Structured cabling outlet | SHORE | Shore connection |
| LIFT | Motorised lift | SPD | Surge protection device |
| LT | Lighting (fixtures, panels, modules) | SPK | Loudspeaker |
| | | SRC | AV source |
| | | SUB | Subwoofer |
| | | SWX | Network switch |
| | | TEL | Telephone |
| | | WBX | Wallbox / back box |

New prefixes can be added, but only through this document so the dictionary stays curated.

---

## 3. Full mapping: current 127 global types to the new families

Actions: **Rename** (1 to 1), **Merge** (becomes a product under a shared family), **Retire** (replaced by a flag or placement). Rows marked **(check)** are judgement calls to confirm at sign-off.

### Access Control & Surveillance (25 rows, 16 families)

| Current ID | New family | Action / note |
|---|---|---|
| CAM-BULLET-1 | CAM-BULLET | Rename. Product: Axis Q1808-LE |
| CAM-DOME-1 | CAM-DOME | Merge. Product: Axis P3277-LVE |
| CAM-DOME-2 | CAM-DOME | Merge. Product: Axis M3086-V |
| CAM-DOME-2-MNT | MNT-CAM | Merge. Product: Axis TM3209 recessed mount |
| CAM-PANO-1 | CAM-PANO | Merge. Product: Axis P3748-PLVE |
| CAM-PANO-2 | CAM-PANO | Merge. Product: Axis P4707-PLVE |
| CAM-POLE-MNT | MNT-POLE | Rename. Product: Stone Poles SP-SM12FL |
| CAM-PTZ-1 | CAM-PTZ | Rename. Product: Axis Q6135-LE |
| CAM-PTZ-1-MNT | MNT-CAM | Merge. Product: Axis T91D61 wall mount |
| CAM-THERMAL-1 | CAM-THERM | Rename. Product: Axis Q1972-E |
| CB-1 | CB | Rename (cabin box, product TBD) |
| SCS-CTR | SEC-CTR | Rename (station controller) **(check)** |
| SEC-DISP | DISP-SEC | Rename (a display is a display) |
| SEC-GS-MNT | MNT-ICOM | Merge. Product: custom gooseneck stand |
| SEC-INTERCOM | ICOM | Rename. Product: 2N IP Verso 2.0 |
| SEC-INTERCOM-MNT | MNT-ICOM | Merge. Product: Steel Cut gooseneck kit |
| SEC-KP | KP-SEC | Merge. Product: 2N Access Unit 2.0 |
| SEC-KP-BUTTONS | KP-SEC | Merge. Product: Essex K1-26 **(check)** |
| SEC-POE-CASE | SPD-POE | Rename (10GbE PoE surge protector) |
| SEC-POE-IN | POE-INJ | Rename (90W PoE injector) |
| SEC-RELAY | RLY-SEC | Rename |
| SEC-SCS | SEC-CMS | Rename (monitoring station with touchscreen) |
| SEC-SWX-8 | SWX-8P | Rename (a switch is a switch, served discipline noted in description) |
| SEC-UPS | PWR-UPS | Merge. Product: Xtreme Power J60-600 |
| SEC-WIEGAND | ICOM-MOD | Rename. Product: 2N Wiegand module |

### Audio Visual System (36 rows, 30 families)

| Current ID | New family | Action / note |
|---|---|---|
| AMP-1 | AMP-1CH | Rename. Product: James M1000 (sub amp) **(check channel count)** |
| AMP-2 | AMP-2CH | Rename. Product: Powersoft Duecanali 1604 DSP |
| AMP-3 | AMP-3CH | Rename. Product: Wisdom SA-3 **(check channel count)** |
| AMP-16 | AMP-16CH | Rename. Product: Storm Audio PA 16 |
| AMP-4-CRS2K | AMP-4CH-LS | Merge. Product: Coastal Source CRS2K (landscape) |
| AMP-4-CRS8K | AMP-4CH-LS | Merge. Product: Coastal Source CRS8K |
| AMP-8-NAX | AMP-8Z | Rename (8-zone streaming amp). Product: Crestron DM-NAX-8ZSA |
| AMP-PROCESSOR | PROC-AV | Rename. Product: Storm ISP Evo 20 |
| DISP-32 | DISP-32 | Keep (owner supply) |
| DISP-65 | DISP-65 | Keep. Product: Samsung QN65QN990F |
| DISP-CM | MNT-DISP | Merge. Product: Future Automation CM ceiling mount |
| DISP-CSEED-165-M1 | DISP-UF | Merge (unfolding display). Product: C SEED M1 165" |
| DISP-CSEED-201-HLR | DISP-UF | Merge. Product: C SEED 201 HLR |
| DISP-VW | DISP-VW | Keep. Product: Eleusis 185" Clarity |
| LIFT-7-HZ | LIFT-HZ | Rename. Product: Future Automation LSM-HZ-FP6 |
| NVX-360 | AVOIP-DEC | Merge. Product: Crestron DM-NVX-360 |
| NVX-D30 | AVOIP-DEC | Merge. Product: Crestron DM NVX-D30 |
| NVX-384-C | AVOIP-ENC-C | Rename (encoder card). Product: Crestron DM-NVX-384C |
| NVX-CHASSIS | AVOIP-FRAME | Rename. Product: Crestron DMF-CI-8 |
| SPK-1-IC | SPK-IC | Merge. Product: B&W CCM7.5 S2 (8") |
| SPK-2-IC | SPK-IC | Merge. Product: B&W CCM682 (6") |
| SPK-3-IC | SPK-IC-EXT | Merge. Product: B&W Marine 6 |
| SPK-4-IC | SPK-IC-EXT | Merge. Product: James VXQ48R |
| SPK-5-WM | SPK-IW | Rename. Product: Wisdom L75i |
| SPK-6-IW | SPK-IW-EXT | Rename. Product: Coastal Source RZ310 |
| SPK-7-FS | SPK-FS-EXT | Rename. Product: Coastal Source 12.0 Line Source |
| SPK-HP | SPK-HP | Keep (headphones, product TBD) |
| SPK-SB-C | SBAR | Rename. Product: Wisdom P38i. L/C/R become placements, not types |
| SRC-ATV | SRC-ATV | Keep. Product: Apple TV 4K |
| SRC-MEDIA-SERVER | SRC-MEDIA | Rename. Product: Eleusis Clio |
| SRC-NAX-4Z | SRC-AUD-4Z | Rename (audio streaming source, 4 zones). Product: Crestron DM-NAX-4ZSP |
| SRC-SAT | SRC-SAT | Keep (owner supply) |
| SRC-XBOX | SRC-GAME | Rename. Product: Microsoft Xbox |
| SUB-1-IW | SUB-IW | Rename. Product: JL Audio IWS-113 |
| SUB-2-IC | SUB-IC | Rename. Product: James PP-10-M |
| SUB-3-FS | SUB-FS-EXT | Rename. Product: Coastal Source B18SW15BN |

### Central Systems (2 rows, 2 families)

| Current ID | New family | Action / note |
|---|---|---|
| RACK-1 | RACK-44U | Rename (44RU floor rack; width/depth on the product). Product: Middle Atlantic ERK-4425LRD |
| RACK-2 | RACK-WM-16U | Rename (16RU wall-mount hinged). Product: Middle Atlantic EWR-16-22SD |

### Control System (8 rows, 8 families)

| Current ID | New family | Action / note |
|---|---|---|
| CTRL-C2N-UNI8IO | CTRL-IO | Rename. Product: Crestron C2N-UNI8IO |
| CTRL-PROCESSOR | CTRL-CPU | Rename. Product: Crestron CP4 |
| REM-10-DM | REM-TP10-DM | Rename. Product: Crestron TS-1070 |
| REM-10-WM | REM-TP10-WM | Rename. Product: Crestron TSW-1070 |
| REM-BUTTON-1 | PB-VOL | Rename (shower audio volume button) **(check)** |
| REM-HR | REM-HR | Keep. Product: Crestron HR-310 |
| REM-IPAD | REM-IPAD | Keep. Product: iPad Air 11" |
| REM-IPAD-DOCK-DM | REM-IPAD-DOCK | Rename. Product: Basalte Eve+ |

### IT System (24 rows, 22 families)

| Current ID | New family | Action / note |
|---|---|---|
| AP | AP | Keep. Product: Meraki CW9178I |
| AP-EXT | AP-EXT | Keep. Product: Meraki CW9177I |
| AP-SPARE | (retired) | Retire: "spare preposition" becomes AP placed with the Pre-wire flag |
| LAN-1 | LAN-1P | Rename (avoids clashing with project numbering) |
| LAN-2 | LAN-2P | Rename |
| NET-FIBRE-HOUSING | FBR-HSG | Rename. Product: Corning CCH-02U |
| NET-FIBRE-PANEL | FBR-PNL | Rename. Product: Corning CCH LC panel |
| NET-FIREWALL | FW | Rename. Product: Meraki MX250 |
| NET-SWX-24P | SWX-24P | Rename. Product: Meraki MS130-24P |
| NET-SWX-24P-AV | SWX-24P-AV | Rename. Product: Catalyst C9300-24P |
| NET-SWX-48POE | SWX-48P | Rename. Product: Meraki MS130-48X |
| PC | PC | Keep |
| PC-DOCK | PC-DOCK | Keep |
| PC-MON | PC-MON | Keep |
| PRN-1 | PRN | Rename |
| SHORE-CON | SHORE-CON | Keep |
| SRC-CONF | CONF-SYS | Rename |
| SRC-CONF-CAM | CONF-CAM | Rename |
| SRC-CONF-MIC | CONF-MIC | Rename |
| TEL-1-DM | TEL-DM | Merge (desk phone) |
| TEL-2-DM | TEL-DM | Merge |
| TEL-1-WM | TEL-WM | Merge (wall phone) |
| TEL-2-WM | TEL-WM | Merge |
| TEL-3-DM-TECH | TEL-TECH | Rename **(check: ID says desk, description says wall)** |
| TEL-4-WIFI | TEL-WIFI | Rename |

### Lighting Control (22 rows, 14 families)

| Current ID | New family | Action / note |
|---|---|---|
| LT-HQP7-2 | LT-CPU | Rename. Product: Lutron HQP7-2 |
| LT-HQP7-RF | LT-GW-RF | Rename. Product: Lutron HQP7-RF |
| LT-QSPS-DH | LT-PSU | Rename. Product: Lutron QSPS-DH-1-75-H |
| LT-HQ-LV21 | ENC-LT-LV | Rename. Product: Lutron HQ-LV21-120 |
| LT-PD8-65A-120L3-20 | LT-PNL | Rename. Product: Lutron PD8-65A DIN panel |
| LT-LQSE-4A5-120-D | LT-PMOD-DIM | Rename. Product: Lutron LQSE-4A5-120-D |
| LT-LQSE-4S8-120-D | LT-PMOD-SW | Rename. Product: Lutron LQSE-4S8-120-D |
| LT-DI-CV-24V320W | LT-DRV | Rename (LED driver). Product: Diode LED DI-CV-24V320W |
| LT-KETRA-D3 | LT-DL | Merge (downlight). Product: Ketra D3 |
| LT-HW-D2TW-RANIA | LT-DL | Merge. Product: Lutron D2 Rania |
| LT-D2-TRIM | LT-TRIM | Rename. Product: Lutron D2 flangeless trim |
| LT-KETRA-CS-VIABT | LT-EXT | Rename (exterior fixture). Product: Coastal Source VIA bullet |
| LT-KETRA-CS-Cable-1 | LT-ACC | Merge (accessories family). Product: CS 2-way splitter |
| LT-KETRA-CS-Cable-2 | LT-ACC | Merge. Product: CS 25' extension |
| LT-PDT-DS-1 | LT-ACC | Merge. Product: Lutron terminal block |
| LT-PDW-D-DV | LT-ACC | Merge. Product: Lutron dimming harness |
| LT-PDW-S-DV | LT-ACC | Merge. Product: Lutron switching harness |
| LT-PDW-QS-8 | LT-ACC | Merge. Product: Lutron QS link harness |
| LT-QS-WLB | LT-ACC | Merge. Product: Lutron wire landing board |
| LT-KP-BLACK-NOVA | KP-LT | Merge. Product: Black Nova Aria 12-button |
| LT-HQWT-B-P4W-CWH | KP-LT | Merge. Product: Lutron Palladiom 4-button |
| LT-LOS | OS | Rename (occupancy sensor). Product: Lutron LOS-CDT-500 |
| LT-SHADES | SHD-PKG | Rename (budget placeholder package) |

### Motorised Window Treatments (3 rows, 2 families)

| Current ID | New family | Action / note |
|---|---|---|
| LT-QSPS-30PNL-NPM | SHD-PNL | Merge. Product: Lutron QSPS-30PNL-NPM |
| LT-QSPSY-10PNL | SHD-PNL | Merge. Product: Lutron QSPSY-10PNL |
| LT-WIN-PS-5CC-R | SHD-PSU | Rename. Product: Lutron WIN-PS-5CC-R |

### Power, UPS & Battery (5 rows, 4 families)

| Current ID | New family | Action / note |
|---|---|---|
| PWR-COND | PWR-COND | Keep. Product: RoseWater HUB20 |
| PWR-PDU-12 | PWR-PDU | Merge. Product: WattBox 12-outlet |
| PWR-PDU-8 | PWR-PDU | Merge. Product: WattBox 8-outlet |
| PWR-SURGE | PWR-SURGE | Keep |
| PWR-UPS-1 | PWR-UPS | Merge. Product: 360 Power Quality TI-H100-50R |

**Net result: 127 types become 103 families, 1 retired, 24 rows become products under a shared family. No product data is lost; every make and model moves with its row.**

---

## 4. Gap review: latest project schedule vs the global library

Shane shared the latest project's device schedule (approx. 250 rows, 4 Oct 2026). Comparing it to the global library after the Section 3 restructure, the rows fall into four buckets.

### 4a. Covered by placement behaviour, not types (approx. 50 rows)

- All **-PREP rows** (approx. 45): become the Pre-wire placement flag.
- **DAS-ANT-SPARE**: a spare location is a pre-wire placement of DAS-ANT.
- **SRC-ATV-8** ("x8"): a quantity of SRC-ATV, not a type.
- **SBAR-L / SBAR-R**: identical product, left and right are placements of one SBAR type.
- **KP-E** (elevator keypad): same Black Nova Aria product, the location is the placement.

### 4b. New products under families that already exist (approx. 40 rows)

Examples: NVX-363 and NVX-385 under AVOIP-DEC; Powersoft Unica 4L (5K4, 9K4) under AMP-4CH; Wisdom SA-2 under AMP-2CH; the extra James, Coastal and Wisdom speakers and subs under SPK-IC / SUB-IC / SUB-IW; Wisdom Cinema Line 4 and C38MX3 under SBAR; Wattbox 2-port under PWR-PDU; Basalte Eve+ wall dock under REM-IPAD-DOCK; Lutron SeeTouch, Black Nova BOH and the Maestro sensor-switch under KP-LT; Faradite and Steinel sensors under OS; Essex K1 (SKP) already lands in KP-SEC; Crestron CP4N under CTRL-CPU; display size variants under their DISP families; Eleusis videowall sizes under DISP-VW; C SEED M1 110/137 under DISP-UF; Xtreme J60 already lands in PWR-UPS.

### 4c. Proposed NEW families (approx. 90)

**Racks and enclosures:** RACK-ACC (brush panels etc.), PATCH-24P, ENC-EXT (IOIOBox), ENC-LT, ENC-SEC, ENC-BMS, ENC-CTRL.

**Displays:** DISP-27, DISP-55, DISP-75, DISP-85, DISP-98; mirror TVs per size, DISP-27-MIR, DISP-32-MIR, DISP-43-MIR, DISP-98-MIR (agreed 4 Oct 2026).

**Display accessories:** WBX-DISP (UB22/UB27/WB80 as products; MNT-DISP already exists for the PS mounts), LIFT-VT (vertical panel lift), LIFT-ARM (articulated arm).

**Cinema (C- namespace):** C-PROC (Storm ISP Elite), C-DCP (Dolby CP950A), C-DSP (Meyer Galaxy), C-AMP (Meyer MPS-488X), C-PROJ (Barco), C-SCREEN (Stewart + masking), C-SPK (Bluehorn, ULTRA-X23), C-SUB (X-1100C, X-400C), C-VPROC (madVR Envy), C-CONTENT (Betty Box), C-SMS (GDC media server), C-SEAT-IF (seating serial interface).

**Audio distribution:** AMP-8CH (the Unica 8M range as products), AMP-PRE (Lyngdorf pre-amp), DSP (Q-SYS Core X20r), PAGE (Q-SYS paging touchscreen), CLK-PTP (grandmaster clock). AMP-8-ALCHIMIA **(check: ID says 8, description says 4-channel)**.

**Speakers and connection points:** SPK-FS (interior floorstanding; exterior stays SPK-FS-EXT), SPK-UW (underwater), SUB-FS (interior), CON-DJ, CON-SPK, CON-SUB (performance connection points).

**Sources and video:** SRC-BT (Bluetooth wall plate), SRC-MOVIE (Kaleidescape Strato player) and SRC-MOVIE-SVR (Kaleidescape Terra server, agreed 4 Oct 2026), PROC-VID (Novastar videowall processor), CTRL-GW-RF (RF gateway).

**IT:** SWX-CORE, SVR (server reservation), LAN-2P-FB (floorbox outlet), WBX-AP (Wall-Smart), AP-EXT-D (directional exterior AP) **(check: or a product under AP-EXT?)**.

**Lighting and shades:** LT-GW-DMX (QSE-CI-DMX), LT-PMOD-DALI, WBX-KP; shade families SHD-BS (blackout shade), SHD-BD (blackout drapery), SHD-SS (solar shade), SHD-SD (solar drapery), SHD-BSC (bug screen), SHD-BC (bug curtain).

**Security:** CAM-CORNER, CAM-COVERT, CAM-LPR (license plate), CAM-TURRET, RADAR, SEC-PNL (DSC alarm panel), DACP and DACP-EXT (Mercury access panels), LOCK (cobalt/mortice provisions), DOOR-EA (electrically assisted door provision), WBX-ICOM, DRONE (drone defence) **(check prefix)**, SEC-RF (RF transceiver) **(check)**, and a sensor set under the SNS- prefix (agreed 4 Oct 2026, replacing the old DS / WB / PAN / ART / OBM / UWS one-offs): SNS-DOOR, SNS-H2O, SNS-PANIC, SNS-ART (Fortecho), SNS-BEAM (optical beam), SNS-WIND.

**Door buttons:** PB-2B, PB-3B (Meljac, button count as qualifier), WBX-PB.

**Power:** PWR-BATT (RoseWater SC40 battery expansion; the RoseWater hubs land as products under PWR-UPS and PWR-COND).

**Coms / DAS (new discipline):** DAS-SDR, DAS-ANT, DAS-ANT-YAGI, DAS-PLX (esaplexer), DAS-RU (remote unit), DAS-POI as one family with the five band units (700H / 700L / AMPS / AWS-3 / PCS) as products (agreed 4 Oct 2026).

### 4d. Remaining open questions

Decided 4 Oct 2026: mirror TVs per size; SNS- prefix for security sensors; one DAS-POI family with bands as products; Kaleidescape split as SRC-MOVIE (Strato) and SRC-MOVIE-SVR (Terra). Still open:

1. AP-EXT-D: own family or a product under AP-EXT?
2. Prefixes for drone defence and the security RF transceiver.
3. AMP-8-ALCHIMIA: ID says 8, description says 4-channel (confirm which).

Adding these is a content exercise (library entries plus products), separate from the restructure build. Recommended order: restructure the existing 127 first, then import the gap list as new families once the model is live.

---

## 5. What happens after sign-off (build stages)

1. **Database migration.** Rename and merge the global families, move merged rows into the product catalogue, back up the prior state in bak_ tables with a rollback script (same approach as the July baseline). Existing projects keep their copied codes; the links back to global rows already exist and are preserved.
2. **New pull flow.** Pulling a family into a project asks which approved product (or TBD), then assigns the next number for that family in the project. The Project Catalogue tab becomes the numbered assignment schedule (Device Type, Description, Manufacturer, Model), the sheet you would issue.
3. **Pre-wire flag.** Placement-level "Pre-wire only" with badges on schedules, exports and GA pins, excluded from Zone Summary loads.
4. **Matching updates.** Feature Matrix links, GA icon auto-matching and room templates match on the family rather than the exact project code.
5. **Import and export** updated for the family and numbered-type model.
6. **Later stage (agreed, not in this batch):** "goes with" links between families so a display offers its mount and wallbox and they share a GA position.
