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
- `global_equipment` — device_type_id, description, category_code, system_group, spec_ref, network_role, avip_role, audio_role, lan_ports, poe_ports, poe_type, power_types (array), power_watts, heat_btu, ups_protected, speaker_channels, spk_watts
- `global_products` — device_type_id, make, model, part_number, network_role, avip_role, audio_role, lan_ports, poe_ports, poe_type, poe_budget_watts, power_types, power_watts, heat_btu, ups_protected, speaker_channels, spk_watts, weight_kg, width_mm, depth_mm, height_mm, notes, price_min, price_max, currency
- `system_groups` — name, code, sort_order
- `device_categories` — system_group, code, description
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
- `spec_documents` — project_id, title, discipline (avit/security/navigation/radio/lighting/combined), doc_code, status, sort_order — **many per project** (one standalone spec per discipline; "combined" spans several)
- `spec_chapters` — document_id, name, sort_order (per-document free-form chapter headings; replaces system-group grouping)
- `spec_sections` — document_id, chapter_id (null = preamble), library_section_id, title, content (HTML), sort_order, is_auto_pulled
- `spec_change_log` — document_id, section_id, action (added/modified/removed), description, cr_id, changed_by, created_at
- `spec_section_library` — discipline, chapter_name, category_code, title, content (HTML), sort_order (global reusable templates, tagged by discipline + chapter)

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
- ✅ Zone Summary — Network (LAN/PoE), Audio (amp channels/power), AV over IP, Power (UPS Load vs Mains Load) — all with demand vs supply and expandable item lists
- ✅ Feature Matrix — manage features/categories, tick cells, optional quantity, green/amber/empty states, Build from Library, Sync from placement, Excel export
- ✅ Change Control — full CR and revision workflow (see detail below)
- ✅ Contract Award — record award against an integrator with ceremony flow; advances project phase to Engineering; shown as tile on Project Info
- ✅ CR Cost Schedule (Change Orders) — per-CR cost items, CO total, pending queue, Estimated/Agreed states (see detail below)
- ✅ Pricing — budget_price on project equipment; price_min/price_max/currency on global and project products; shown in Equipment Schedule
- ✅ Specification — two-pane authoring (section tree + Quill rich-text editor), chapters by system group with auto-numbering, section CRUD + reorder, dirty-state tracking, spec change log, Pull from Spec Library (see detail below)
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

### Structure (multi-document, per discipline)
- A project has **many specifications** (`spec_documents`), one per discipline (AV/IT, Security, Navigation, Radio, Lighting) or a single "Combined" document. Disciplines list = `SPEC_DISCIPLINES` const in the JS.
- "Split vs combined" is just how many documents you create — same building blocks either way. A combined doc pulls chapters from several disciplines into one document.
- Each document has its own **chapters** (`spec_chapters`, free-form), and each chapter holds **sections** (`spec_sections`). Preamble = sections with no chapter.
- Document bar at the top of the Specification page switches between the project's specs (`renderSpecDocBar`); New / rename / delete specification supported.
- New Specification can "seed standard chapters and sections from the Spec Library for this discipline" (`seedSpecFromLibrary`).
- **Auto-numbering:** Preamble sections = 1, 2, 3…; then each chapter is numbered, sections `N.M`. Computed at render time (`computeSpecNumbers`), never stored.
- Library "Pull" is discipline-filtered; pulling a template auto-creates its chapter in the target document if missing.

### Authoring (Specification page)
- Two-pane layout: section tree (left) + Quill rich-text editor (right)
- Quill toolbar: headers (H1–H3), bold/italic/underline, ordered/bullet lists, clean
- Section CRUD: add (per chapter via + button), delete (confirm), reorder (move up/down within chapter via sort_order swap)
- Dirty-state tracking: unsaved-changes dot + "Saved ✓" flash; switching sections with unsaved edits prompts discard confirm
- Content stored as HTML in `spec_sections.content`

### Spec Change Log
- Every add/modified/removed action logged to `spec_change_log` (action, description, changed_by, cr_id if a CR is active)
- Collapsible viewer at the bottom of the Specification page

### Spec Library (Global)
- `spec_section_library` holds reusable standard SMART text templates (discipline, chapter_name, category_code, title, content, sort_order)
- Managed on Global > Spec Library with full CRUD + its own Quill editor
- "Pull from Spec Library" on a project spec imports standard sections in one click (sets `is_auto_pulled`)

---

## Pending Backlog (Priority Order)

1. ⬜ Export Centre — Word/PDF spec output, formatted Excel/CSV schedules; spec authoring now built, so this is the next logical step
2. ⬜ CO Document generation — produce a formal Change Order PDF/Word document from a CR's cost schedule (distinct from the tracking already built)

(Spec Builder authoring — formerly backlog #1 — is now built; see What's Built and the Specification — Detail section.)

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
- **Spec Builder multi-document (May 2026):** Reworked to many specs per project, one per discipline (spec_chapters table added; spec_sections moved from system_group to chapter_id; library tagged by discipline + chapter_name). See "Specification — Detail".
- **Spec Library seeded (May 2026):** Global library pre-populated with 52 generalised templates derived from the Defy AV/IT (39) and Security (13) specs, with [placeholders], contractor-supplies-everything default, and no em-dashes. Navigation/Radio/Lighting disciplines exist but have no library content yet (no standalone SMART source spec found except Defy NAV R0.4, not yet mined). Next: Export Centre (Word/PDF output)
