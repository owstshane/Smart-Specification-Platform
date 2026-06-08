# SMART Advisers Specification Platform — Claude Code Briefing

## What This Is
A single-file HTML web application for **Smart Technology Advisers** (smartadvisers.com / smart.yachts), an independent superyacht AV/IT technology consultancy run by Steve Puckering. The platform is used by a team of 7+ people on desktop and tablet devices to manage multiple simultaneous active projects across multi-year lifecycles.

The app is a **single HTML file** (`index.html`) with all CSS and JavaScript inline. It connects to a **Supabase** backend for all data storage.

**Live URL:** https://owstshane.github.io/Smart-Specification-Platform/

---

## Tech Stack
- **Frontend:** Single HTML file — vanilla JS, no frameworks, inline CSS
- **Backend:** Supabase (Postgres, RLS enabled)
- **Hosting:** GitHub Pages
- **Supabase URL:** https://ezpmgpftfqifruyfkcbs.supabase.co
- **Supabase Anon Key:** eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV6cG1ncGZ0ZnFpZnJ1eWZrY2JzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUzMTA0NTYsImV4cCI6MjA5MDg4NjQ1Nn0.eHJo_C7iC3-S9hPwduNg4VFV4R-ebsweak6wZZwuzK8

---

## Database Tables

### Core
- `projects` — project_code, name, category (Yacht/Residential), type (New Build/Refit), status, phase, length_metres, start_date, target_completion, builder, build_location, architect, owners_rep, management_team, interior_designer, exterior_designer, scope (jsonb array), notes, flag, year
- `decks` — project_id, name, deck_id, deck_order
- `rooms` — deck_id, name, room_id, room_number, position, frame_number, rack_zone_id, notes, **change_status, change_cr_id, change_cr_ref**
- `rack_zones` — project_id, name, zone_id, rack_count, colour, notes

### Global Library
- `global_equipment` — device_type_id, description, category_code, subcategory_code, system_group, spec_ref, spec_text (features/functions override), network_role, avip_role, audio_role, lan_ports, poe_ports, poe_type, power_types (array), power_watts, heat_btu, ups_protected, speaker_channels, spk_watts
- `global_products` — device_type_id, make, model, part_number, network_role, avip_role, audio_role, lan_ports, poe_ports, poe_type, poe_budget_watts, power_types, power_watts, heat_btu, ups_protected, speaker_channels, spk_watts, weight_kg, width_mm, depth_mm, height_mm, notes, price_min, price_max, currency
- `system_groups` — name, code, sort_order
- `device_categories` — system_group_id, code, name, sort_order, spec_text (category-level features/functions)
- `device_subcategories` — category_id, code, name, sort_order, spec_text (sub-category level, e.g. Loudspeakers under Audio Equipment)
- `global_room_templates` — name, description, item_count, item_summary
- `global_room_template_items` — template_id, device_type_id, quantity, notes, sort_order

### Project-Specific
- `project_equipment` — project_id, global_equipment_id, device_type_id, description, category_code, system_group, spec_ref, network_role, avip_role, audio_role, lan_ports, poe_ports, poe_type, power_types, power_watts, heat_btu, ups_protected, speaker_channels, spk_watts, make, model, comments, budget_price, **change_status, change_cr_id, change_cr_ref**
- `equipment_instances` — project_id, device_id, device_type_id, description, room_id, rack_zone_id, quantity, installation_type, notes, **change_status, change_cr_id, change_cr_ref**
- `project_products` — project_id, device_type_id, make, model, part_number, and full product spec fields + price_min, price_max, currency (project-specific product catalogue)
- `room_templates` — project_id, name, description
- `room_template_items` — template_id, device_type_id, quantity, notes, sort_order
- `project_team` — project_id, member_name
- `project_integrators` — project_id, company_name, disciplines (text array), sort_order

### Feature Matrix
- `feature_categories` — project_id, name, sort_order
- `features` — project_id, category_id, name, sort_order, quantity_tracked (boolean)
- `feature_device_types` — feature_id, device_type_id (many-to-many link)
- `project_feature_matrix` — project_id, room_id, feature_id, ticked (boolean), quantity (integer)

### Change Control & Commercial
- `change_requests` — project_id, cr_number, title, type (formal/internal), status, description, impact, cost_impact, internal_approved_by, internal_approved_date, owner_approved_by, owner_approved_date, revision_id, **co_total_value, co_currency, priced_at, co_agreed_by, co_agreed_date**
- `cr_cost_items` — cr_id, item_type (equipment/labour/installation/drawing/other/pending), description, quantity, unit_price, line_value (GENERATED ALWAYS AS quantity*unit_price STORED), notes, sort_order
- `contract_awards` — project_id, integrator_id, contract_value, currency, award_date, discipline, notes
- `project_revisions` — project_id, revision_number, revision_type, status, issued_by, issued_date, notes
- `change_log` — project_id, area, action, summary, cr_id, changed_by, created_at

### Specification
- `spec_section_library` — discipline, **position** (front/back), title, content (HTML), sort_order. **Now holds document-level sections only** (system_group_id always null): **Front** sections become "Section 1: General Requirements" (Project Overview, Terminology, etc.); **End** (back) sections are appended after the system sections (Testing/Commissioning, Standards/Codes, Approved Manufacturers, Owner Supply, Special Conditions). The old per-group/category template rows were purged. Managed on Global > Spec Library. (Legacy chapter_name/category_code columns retained but unused.)
- `project_spec_overrides` — project_id, scope_type ('preamble'/'group_general'/'group_execution'/'category'/'subcategory'/'device'), scope_key (target id/code), content, title_override, **is_custom + parent_type + parent_key + part + sort_order** (reserved for Phase B custom sections), sort_order. **Per-project text overrides**: generation prefers an override over the global/taxonomy text; editing a block in the preview writes here, never touching globals. Unique on (project_id, scope_type, scope_key) where not custom.
- `spec_documents` / `spec_sections` / `spec_change_log` — **LEGACY, no longer used.** Tables of the retired two-pane authoring editor. Generation reads none of them; the editor JS was deleted. Tables left in place (not dropped) but inert.

---

## Application Structure

### Navigation
**Sidebar — Workspace:** All Projects
**Sidebar — Current Project:** Project Info | Layout & Zones | Equipment | Feature Matrix | Change Control
**Sidebar — Current Project:** … | Specification
**Sidebar — Standalone:** Import / Export
**Sidebar — Global:** Groups & Categories | Device Types | Product Catalogue | Room Templates | Spec Library

### Equipment Page Tabs
Project Library | Project Catalogue | Equipment Schedule | Equipment Matrix | Zone Summary | Room Templates

### Layout & Zones Page Tabs
Decks | Rooms | Rack Zones

### Change Control Page Tabs
Change Requests | Revisions | Change Log

---

## Roles System (Important)
Devices have three role fields that drive Zone Summary calculations:

- **network_role:** `none` / `endpoint` (requires LAN ports) / `infrastructure` (provides LAN ports)
- **avip_role:** `none` / `requires` / `provides`
- **audio_role:** `none` / `requires` (needs amp channels) / `provides` (is an amp)

Network role drives show/hide of LAN/PoE fields in modals:
- Requires LAN → show LAN Ports, PoE Ports, PoE Type
- Provides LAN → show LAN Ports, PoE Ports, PoE Budget (W)
- None → hide all network fields

Audio role drives show/hide of amp channel fields.

AVoIP role is a simple demand/supply headcount in Zone Summary — no port-level modelling. Physical signal ports (HDMI, IR, RS-232 etc.) are not modelled; cable scheduling is a future feature.

---

## Key Development Rules
1. **Plan fully before building** — agree structure before any code
2. **Validate JS** before delivering — `node -e "new Function(code)"`
3. File must always have **exactly 1 `<style>` tag**, no duplicate functions
4. **`<style>` tags inside JS template literals** must use unicode escapes or be avoided
5. Never patch a broken file — roll back and rebuild cleanly
6. Steve is not a developer — plain English explanations always

---

## What's Built and Working

- ✅ All Projects dashboard — cards, search, filter by status/type/category
- ✅ Project Info — 3-column card layout + stats row + Change Control widget (Current Revision, Open CRs, Last Issued) + Contract Award tile
- ✅ Layout & Zones — Decks, Rooms, Rack Zones with full CRUD
- ✅ Equipment — 6 tabs: Project Library, Project Catalogue, Equipment Schedule, Equipment Matrix, Zone Summary, Room Templates
- ✅ Equipment Schedule — placed devices with change-status badges (Added/Modified/Removed), soft-delete when CR active, Show Removed toggle, budget prices shown
- ✅ Equipment Matrix — room × device-type visual grid showing what's placed where; empty columns hidden by default
- ✅ Zone Summary — Network (LAN/PoE), Audio (amp channels/power), AV over IP, Power (UPS Load vs Mains Load), Thermal (Heat Load BTU/h) — all with demand vs supply and expandable item lists; calc shared with spec generation via computeZoneLoads()
- ✅ Feature Matrix — manage features/categories, tick cells, optional quantity, green/amber/empty states, Build from Library, Sync from placement, Excel export
- ✅ Change Control — full CR and revision workflow (see detail below)
- ✅ Contract Award — record award against an integrator with ceremony flow; advances project phase to Engineering; shown as tile on Project Info
- ✅ CR Cost Schedule (Change Orders) — per-CR cost items, CO total, pending queue, Estimated/Agreed states (see detail below)
- ✅ Pricing — budget_price on project equipment; price_min/price_max/currency on global and project products; shown in Equipment Schedule
- ✅ Specification — the page IS the live, generated CSI spec rendered inline (no editor, no modal). Built from equipment + global taxonomy text + per-project overrides. Every block (preamble, group General/Execution, category, sub-category, device, End sections) has a Standard/Project-override badge + Edit (inline) + Revert. Edits save per-project to `project_spec_overrides`; globals untouched. Buttons: Download Word (CSI), Room-by-Room (Word), Device Schedule (Excel), + Front/End custom section. (See detail below.)
- ✅ Global — Device Types, Product Catalogue, System Groups & Categories, Room Templates, Spec Library (standard SMART text templates)
- ✅ Import / Export — full coverage of all sections, both global and project
- ✅ Authentication — login/logout, JWT proactive refresh mid-session, retry on 401

---

## Change Control — Detail

### CR Workflow
- **Types:** Formal (CR-001, CR-002…) and Internal (IC-001, IC-002…) — separate numbering sequences
- **Statuses:** Draft → Submitted → (Internal Approved) → Approved → Closed | Rejected
- **Approval:** Internal sign-off (name + date) then Owner sign-off (name + date) → sets status to Approved
- **Rejection:** Clears all change_status / change_cr_id / change_cr_ref on linked equipment and rooms (reverts to baseline)

### Active CR Mode
- "Work under this CR" button on any CR card activates it globally
- Persistent red banner across all pages: "Logging changes to CR-001 — [title]" + Stop button
- While active: saves to equipment/rooms auto-stamp change_status + change_cr_id + change_cr_ref
- Deleting placed equipment while CR is active → soft-delete (change_status='removed') instead of hard-delete
- `activeCRId` and `activeCRType` stored in sessionStorage so they survive page navigation

### Item Change Tracking
- `change_status`: null (baseline) / 'added' / 'modified' / 'removed'
- Badges shown on Equipment Schedule and rooms; historical record stays even after CR approved/closed
- Show Removed toggle on Equipment Schedule reveals soft-deleted items

### Equipment Cost Linking
- Placing equipment under an active **formal** CR → prompts to add to CR cost schedule (pre-filled from catalogue price)
- Removing equipment (soft-delete) under active formal CR → prompts to add a credit line
- Swapping a product or editing budget_price under active formal CR → prompts to log the price delta
- Skipping the cost prompt creates a `pending` placeholder item (unit_price=0, notes='Skipped — awaiting pricing')
- Price lookup hierarchy: `project_products` (price_min+price_max midpoint) → `project_equipment.budget_price` → manual entry
- Price source shown in prompt label for transparency

### CR Cost Schedule (Change Order)
- Formal CRs only (internal CRs never have commercial value)
- Line item types: equipment / labour / installation / drawing / other / pending
- `line_value` is a generated column (quantity × unit_price) — never written directly
- CO total excludes `pending` items; footer shows "(excl. N pending)" when applicable
- Pending items show as amber rows with "Set price →" button to resolve inline
- **Pricing state:** "Estimated: £X" (amber badge) until cost schedule is formally agreed; then "✓ Agreed: £X" (green badge)
- Agreeing records co_agreed_by (name) + co_agreed_date on the change_request row
- `computeCOTotal(crId)` helper: filters out pending items, sums line_value

### Contract Award
- One award record per project (`contract_awards` table)
- New awards trigger a ceremony: form → confirmation modal showing value/contractor/implications
- Confirmation modal offers "Advance phase to Engineering" checkbox (hidden if project already at Engineering or later)
- Editing an existing award saves quietly (no ceremony)
- Award shown as a tile on Project Info page

### Revisions
- Draft → Issued lifecycle; revision numbers follow R0.1 / R0.2 → R1 / R1.1 pattern
- Auto-suggests next revision number when creating
- After issuing, prompts to start the next draft + pre-opens Link CRs modal for unlinked approved CRs
- Link CRs modal: assign approved/closed CRs to a specific revision

### Change Log
- All key actions logged to `change_log` with area, action, summary, user email, and CR reference if active
- Viewable on Change Control → Change Log tab, filterable by area

---

## Specification — Detail

### The model: generation is king; the page IS the spec
- The platform GENERATES the spec from data; it is not an authoring tool. The old two-pane editor (`spec_documents`/`spec_sections`/Quill/library pull) was **retired and its code deleted**.
- The Specification page renders the assembled CSI spec **inline** (no modal). `loadSpecification()` just calls `previewCsiSpec()`.
- **Document order:** Section 1 General Requirements (Front library sections) → per System Group in use `N. / N.1 General / N.2 Products / N.3 Execution` → **End** library sections (Testing, Standards, Approved Manufacturers, Owner Supply, Special Conditions) → Annex A (Equipment Schedule by Location: rooms + technical spaces) → Annex B (Rack Zone / Technical Schedule).
- **Text precedence:** project override (`project_spec_overrides`) > global/taxonomy text. Taxonomy text = device type > sub-category > category for Products; `system_groups.general_text`/`execution_text` for General/Execution; `spec_section_library` for Front/End sections.
- Auto-numbering is computed at render in `_assembleCsiSpec`; never stored.

### Edit-in-place (per-project overrides)
- Every editable block is wrapped in `.spec-block[data-block]` with a registered meta entry (`_specEditBlocks`). The preview decorates each with a **Standard / Project-override** badge + **Edit** + **Revert** (`_decorateSpecBlocks`).
- `specEditBlock` opens an inline editor; `_specEditMode` picks the widget: **lines** (one-per-line textarea) for taxonomy text, **quill** (rich editor) for prose preamble, **html** (raw HTML textarea) for sections containing a `<table>` (so tables survive). Preamble/End blocks also allow a heading rename (`title_override`).
- `specSaveBlock` upserts a row in `project_spec_overrides`; `specRevertBlock` deletes it. Both re-run `previewCsiSpec(true)` (scroll preserved). Globals are never modified.

### Spec Library (Global) — now document-level sections only
- `spec_section_library` holds reusable standard SMART **document-level** sections (system_group_id always null), each with a **position**: **Front** (Section 1 General Requirements) or **End** (after the system sections).
- Managed on Global > Spec Library: columns Discipline / Position / Title / Preview / Actions; editor has Discipline, Position, Sort Order, Title, Content (Quill). 6 Front + 5 End AV/IT sections seeded (End ones generalised with [placeholders], brand/location specifics removed, no em-dashes; the Approved Manufacturers + Owner Supply tables are editable templates to fill per project via override).
- Front/End sections are editable in the live preview exactly like any other block (scope_type `preamble`).

---

## Pending Backlog (Priority Order)

**Spec generation** — CSI Word generator, room-by-room schedule, rack-zone inclusion, Annex B, on-screen inline preview, **per-project edit-in-place overrides**, Front/End library sections, **hierarchical auto-numbering**, **contents-sidebar navigator**, **generic vs discipline-specific library**, hover edit controls, **Phase B project custom sections** (Front/End, add/edit/delete), and full **dead-code/CSS removal** are all BUILT and working (see decisions log). Remaining:
1. ⬜ Make the project-specific tables (Approved Manufacturers, Owner Supply) data-driven rather than HTML templates.
2. ⬜ Fill gaps — Lighting and Radio category/general/execution text; revisit Security (deferred).
3. ⬜ Product compliance checking (bigger) — tag products with capabilities, flag placements that miss a requirement; promote spec_text lines to atomic checkable items.
4. ⬜ Phase B+ — custom sub-sections attached within a specific system group (current custom sections are top-level Front/End only).

**Done:**
- ✅ Excel device-schedule annex — `generateDeviceScheduleExcel()` (button on the Specification page) builds a 2-sheet .xlsx via SheetJS: "Device Schedule" (per location + device type, qty aggregated, key specs) + "Summary by Type" (total qty per device type).
- ✅ CSI cover page + contents page (Word export only) — `_assembleCsiSpec` returns `wordBody` = `_specCoverHtml()` (project title page) + `_specContentsFromBody()` (static contents from numbered h1/h2, annex sub-headings excluded) + body. The Word download paths use `wordBody`; the on-screen preview uses `body`. A live page-numbered Word TOC is left to the user (tip included on the contents page).

**Other backlog:**
7. ⬜ CO Document generation — formal Change Order PDF/Word from a CR's cost schedule.

**Where to resume:** spec generation lives in the JS as `_assembleCsiSpec()` (builds the HTML body, applies overrides, registers `.spec-block` editable blocks + custom sections via `renderCustoms()`, then numbers the main body with `_numberSpecHtml()`; shared by export + preview), `generateCsiSpec()` (downloads Word), `previewCsiSpec(keepScroll)` (renders inline into the Specification page; `loadSpecification` calls it; also runs `_buildSpecToc()`), `generateRoomSpec()`. Inline editing: `_decorateSpecBlocks` / `specEditBlock` / `specSaveBlock` / `specRevertBlock`, with `_specEditMode` = lines | quill | html. Custom sections (Phase B): `addCustomSection(part)` / `specDeleteCustom`. Contents sidebar: `_buildSpecToc` / `_specTocGo`. Per-zone engineering loads come from shared `computeZoneLoads()`. Schedule HTML is shared `_equipScheduleHtml()` / `_groupedEquipList()`. Text precedence: project override > device type > sub-category > category. Taxonomy: System Group > Category > Sub-category > Device Type. For SaaS later: tenancy = add `org_id` to the global tables, NOT per-project copies (decided).

---

## Important Decisions Log
- Scope and team managed via project Edit modal (not inline)
- Pull from Library → modal (not navigate away); individual quickPullToProject also available
- Layout & Zones consolidates Decks+Rooms+Rack Zones into one page with 3 tabs
- Feature matrix: features are per-project, grouped by categories, rooms as rows, features as columns
- Feature cells: tick + optional quantity; three states (green/amber/empty); quantity-tracked features support double-click to edit quantity
- Feature auto-tick: triggered by device type match in room (many device types per feature via feature_device_types table)
- Sync fills empty cells only — manual ticks never overwritten
- Change badges (Added/Modified/Removed) persist after CR approval — intentional historical record
- Formal CRs = CR-### numbering; Internal changes = IC-### (separate sequences, avoids client confusion with gaps)
- Formal CRs = commercial Change Orders; internal CRs never carry cost items
- CO pricing state derived from co_agreed_by being null (Estimated) vs set (Agreed) — no separate status column needed
- Pending cost items excluded from CO total — a CR with only pending items shows no value badge until resolved
- Physical port types (HDMI, IR, RS-232 etc.) are NOT modelled — cable scheduling is a future feature; current roles system covers power/network/audio/AVoIP only
- All confirm dialogs use custom openConfirm() modal — no native browser confirm() anywhere
- File delivered as index.html for direct GitHub Pages deployment
- **Code review (May 2026):** Full audit completed; bugs fixed (token refresh race, CSS variable gaps, null crash in modalAddDiscipline); performance fixes (feature matrix pre-built Maps, template apply inner loop); batch DB ops (savePlacement, fmSeedFromLibrary, saveModalIntegrators, saveCRRevisionLinks all converted to single bulk requests); dead code removed (ccFmtDateTime duplicate, ieActiveTab unread variable)
- **global_products DB fix (May 2026):** audio_role, avip_role, ups_protected columns were missing from global_products table — added via migration; all default to 'none'/false
- **Spec Builder (May 2026):** Authoring built (4 tables, two-pane Quill editor, system-group chapters, auto-numbering, change log, global library + pull). Section numbers computed at render, not stored. Content is HTML. RLS also enabled on contract_awards, cr_cost_items, contractor_pricing in the same change.
- **Spec Builder multi-document (May 2026):** Reworked to many specs per project, one per discipline. Within a document, sections are grouped by **System Group (main) + Category (sub-section)** pulled from Groups & Categories, each group leading with a Scope of Supply overview; front matter is Preamble. (An interim "free-form chapters" model was tried and dropped; spec_chapters table removed.) See "Specification — Detail".
- **Spec Library seeded (May 2026):** Global library populated with 39 generalised AV/IT templates derived from the Defy AV/IT spec, tagged by system group + category, with [placeholders], contractor-supplies-everything default (Owner Supply = airtime + Apple Business Manager only), and no em-dashes. Security content was drafted then removed pending a rethink (revisit later). Navigation/Radio/Lighting disciplines exist but have no library content yet.
- **Spec direction pivot (Jun 2026):** Decided the platform should GENERATE the spec from equipment data rather than be an in-app rich-text editor. Word stays the master; the app produces (a) a room-by-room write-up (terse schedule grouped by System Group, CSI-style: device definitions written once, rooms reference them), and (b) a device schedule annex (Excel). Reusable "features and functions" text lives at **category level** (`device_categories.spec_text`) as the primary, with **device-type override** (`global_equipment.spec_text`); generation prefers device-type text, falls back to category. Phase 1 done: spec_text on categories + device types + editors; 35 AV/IT category texts seeded.
- **Spec taxonomy: sub-categories added (Jun 2026):** Hierarchy is now **System Group → Category → Sub-category → Device Type**, mirroring spec numbering depth (e.g. 4.10 Audio Equipment → Loudspeakers). New `device_subcategories` table (with its own spec_text); `global_equipment.subcategory_code` + `project_equipment.subcategory_code` link device types/placements to a sub-category. Spec text precedence for generation: device type > sub-category > category. AV regrouped to match the Defy spec: new **Audio Equipment** category with Amplification/Loudspeakers/Subwoofers as sub-categories; **Display Equipment** gains Displays/Mounting/Lifts/Videowalls (the old flat AV-AMP/AV-SPK/AV-SUB/AV-MNT categories were promoted to sub-categories and removed). Groups & Categories page now manages sub-categories; Device Type modal has a sub-category picker. Lighting/Radio/Security category text still blank (Security to revisit). Atomic requirement-items + product compliance checking remain a future option.
- **Spec generation Phase 2 done (Jun 2026):** Room-by-Room Word generator built (`generateRoomSpec` in the JS, button on the Specification page). Produces a downloadable `.doc` (HTML-based, opens in Word) from the project's placed equipment: **Part 1** lists each room (deck order) with equipment grouped by System Group, terse "Qty x Description (example: make model)"; **Part 2** is the device specifications, grouped System Group > Category > Sub-category, printing the spec_text (precedence device type > sub-category > category) and the device types in use with example product. Example make/model pulled from project_products then project_equipment. Generation is fully client-side (no backend).
- **Spec generation Phase 2b: CSI format (Jun 2026):** Decided to follow US **CSI SectionFormat** (Part 1 General, Part 2 Products, Part 3 Execution). Mapping: **General** = system group text (`system_groups.general_text`) + shared front matter (the spec_section_library preamble rows = Section 1 General Requirements); **Products** = the category/sub-category/device-type spec_text (features & functions); **Execution** = `system_groups.execution_text` (install/test/commission/training); **room-by-room schedule** = Annex A. Added `system_groups.general_text` + `execution_text` (editor on the System Group modal). `generateCsiSpec()` outputs Section 1 General Requirements, then per system group in use N.1 General / N.2 Products / N.3 Execution, then Annex A. Both generators (CSI + room-by-room) have buttons on the Specification page. Seeded general/execution text for the 6 AV-side groups (Lighting/Radio/Security blank).
- **Spec generation Phase 2c: rack zones + Annex B + heat + preview (Jun 2026):** Review of the generators found a correctness hole — both dropped equipment placed in **rack zones** (the schedule filter required `room_id`), so head-end/rack kit and rack-only system groups never appeared. Fixed: the equipment schedule now lists rack zones as **Technical Spaces** alongside rooms (Annex A renamed "Equipment Schedule by **Location**"; same in the room-by-room doc). New **Annex B: Rack Zone / Technical Schedule** in the CSI doc — per-zone engineering loads (LAN/PoE ports req vs avail, PoE budget, amp channels/power, AVoIP, UPS/mains/total power, heat), with a note pointing to the GA drawing for physical locations. Added **heat_btu aggregation** (was on devices but never summed) — new Thermal/Heat Load row on the on-screen Zone Summary and in Annex B. Refactors: extracted shared `computeZoneLoads()` (Zone Summary UI + generator share one calc) and `_equipScheduleHtml()`/`_groupedEquipList()` (de-duped the room/zone schedule HTML); removed dead `_buildWordDoc` + `deviceListHtml`. Also added an **on-screen CSI preview**: split `generateCsiSpec()` into `_assembleCsiSpec()` (returns the body) + a thin downloader, added `previewCsiSpec()` which renders the assembled spec in a Word-styled modal (`.spec-preview-doc`) with a Download Word button. Confirmed: the rich-text editor (spec_documents/spec_sections/Quill/library pull) is orphaned — generation reads NONE of it; left in place for now, to be retired once edit-in-place from the preview lands. Next: edit-in-place from preview; then Excel device-schedule annex; later cover/contents/numbering polish, requirement-items + product compliance.
- **Spec generation Phase 3: edit-in-place + inline page + library repurpose + dead-code removal (Jun 2026):** The Specification page IS now the live generated spec, rendered inline (no modal, no editor). Added **per-project overrides** (`project_spec_overrides` table): generation applies override > global precedence and wraps each editable unit in `.spec-block`; the preview shows a Standard/Project-override badge with Edit + Revert on every block (preamble, group General/Execution, category, sub-category, device, End sections). `specEditBlock` picks an editor by `_specEditMode`: one-per-line textarea (taxonomy text), Quill (prose preamble), or raw-HTML textarea (sections with a `<table>`, so tables survive); preamble/End blocks can also rename their heading (`title_override`). Saves upsert to `project_spec_overrides`, never touching globals; revert deletes the row. **Spec Library repurposed**: purged the 33 dead per-group/category rows, added a `position` column; it now holds document-level **Front** (Section 1 General Requirements) and **End** sections only, simplified page + editor (Discipline/Position/Title/Content). Seeded 5 generalised standard **End** sections (Testing & Commissioning, Standards & Codes, Approved Manufacturers, Owner Supply, Special Conditions) with [placeholders], brand/location specifics removed, no em-dashes; the two project-specific tables are editable templates. **Decided** (SaaS question): keep the global taxonomy shared and add per-project text via the override layer (NOT per-project taxonomy copies); multi-tenancy later = `org_id` on the globals. **Removed ~26k chars of dead code** — the entire retired two-pane editor + pull/seed cluster (34 functions: renderSpecDocBar, selectSpecDocument, renderSpecTree, the spec_documents/spec_sections CRUD, computeSpecNumbers, the change-log viewer, the library pull modal, specGroupsInUse/specCatsForGroup/slPopulateCats, etc.); `spec_documents`/`spec_sections`/`spec_change_log` tables remain but are inert. Next: Phase B project custom sections (table already has is_custom/parent_type/part columns); then Excel annex, polish, content gaps.
- **Spec generation Phase 3b: numbering, navigator, generic library, polish (Jun 2026):** **Hierarchical auto-numbering** — the builder emits headings without numbers and a single `_numberSpecHtml()` pass numbers the main body (h1 `N.`, h2 `N.M`, h3 `N.M.P`, h4 deeper); annexes are built after the pass so they keep their own scheme (Annex A/B + room/zone numbering). **Section navigator** — the Specification page is a contents sidebar (`#spec-toc`, `_buildSpecToc`/`_specTocGo`) listing every h1/h2, click smooth-scrolls. **Edit-on-hover** — block bars hidden until hover; overridden blocks keep their bar visible. **Spec Library = document-level sections with a `position` (front/back) and `discipline` (a code or null = generic).** Generation pulls `system_group_id is null AND (discipline is null OR discipline = avit)` so generic + the discipline's own sections both appear; library filter has a "Generic / shared" option. End sections (Testing, Standards, Approved Manufacturers, Owner Supply, Special Conditions) re-tagged Generic; AV/IT opening Front sections stay AV/IT; the duplicate Front "Owner Supply Items" stub was deleted (the detailed Generic End one supersedes it). **Removed ~8k chars of orphaned editor CSS.** Decided (SaaS): per-project text via overrides + add `org_id` to globals later, NOT per-project taxonomy copies.
- **Spec generation Phase B: project custom sections (Jun 2026):** "+ Front section" / "+ End section" buttons on the Specification page add a project-only section (`addCustomSection(part)` inserts an `is_custom` row in `project_spec_overrides` with scope_type 'custom', part front/end, sort_order). Front customs render as top-level numbered sections after General Requirements; End customs after the End library sections; both before the annexes. Custom blocks carry a blue "Custom" badge with Edit + Delete (`specDeleteCustom`) rather than Revert; editing reuses the inline editor (`renderCustoms()` in `_assembleCsiSpec` registers them). Top-level only for now; custom sub-sections within a system group remain a future Phase B+ (the table's `parent_type`/`parent_key`/`part` columns support it).
