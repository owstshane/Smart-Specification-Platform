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
- `global_products` — device_type_id, make, model, part_number, network_role, avip_role, audio_role, lan_ports, poe_ports, poe_type, poe_budget_watts, power_types, power_watts, heat_btu, ups_protected, speaker_channels, spk_watts, weight_kg, width_mm, depth_mm, height_mm, notes
- `system_groups` — name, code, sort_order
- `device_categories` — system_group, code, description
- `global_room_templates` — name, description, item_count, item_summary
- `global_room_template_items` — template_id, device_type_id, quantity, notes, sort_order

### Project-Specific
- `project_equipment` — project_id, global_equipment_id, device_type_id, description, category_code, system_group, spec_ref, network_role, avip_role, audio_role, lan_ports, poe_ports, poe_type, power_types, power_watts, heat_btu, ups_protected, speaker_channels, spk_watts, make, model, comments, **change_status, change_cr_id, change_cr_ref**
- `equipment_instances` — project_id, device_id, device_type_id, description, room_id, rack_zone_id, quantity, installation_type, notes, **change_status, change_cr_id, change_cr_ref**
- `project_products` — project_id, device_type_id, make, model, part_number, and full product spec fields (project-specific product catalogue)
- `room_templates` — project_id, name, description
- `room_template_items` — template_id, device_type_id, quantity, notes, sort_order
- `project_team` — project_id, member_name
- `project_integrators` — project_id, company_name, disciplines (text array), sort_order

### Feature Matrix
- `feature_categories` — project_id, name, sort_order
- `features` — project_id, category_id, name, sort_order, quantity_tracked (boolean)
- `feature_device_types` — feature_id, device_type_id (many-to-many link)
- `project_feature_matrix` — project_id, room_id, feature_id, ticked (boolean), quantity (integer)

### Change Control
- `change_requests` — project_id, cr_number, title, type (formal/internal), status, description, impact, cost_impact, internal_approved_by, internal_approved_date, owner_approved_by, owner_approved_date, revision_id
- `project_revisions` — project_id, revision_number, revision_type, status, issued_by, issued_date, notes
- `change_log` — project_id, area, action, summary, cr_id, changed_by, created_at

---

## Application Structure

### Navigation
**Sidebar — Workspace:** All Projects
**Sidebar — Current Project:** Project Info | Layout & Zones | Equipment | Feature Matrix | Change Control
**Sidebar — Standalone:** Import / Export
**Sidebar — Global:** Groups & Categories | Device Types | Product Catalogue | Room Templates

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
- ✅ Project Info — 3-column card layout + stats row + Change Control widget (Current Revision, Open CRs, Last Issued)
- ✅ Layout & Zones — Decks, Rooms, Rack Zones with full CRUD
- ✅ Equipment — 6 tabs: Project Library, Project Catalogue, Equipment Schedule, Equipment Matrix, Zone Summary, Room Templates
- ✅ Equipment Schedule — placed devices with change-status badges (Added/Modified/Removed), soft-delete when CR active, Show Removed toggle
- ✅ Equipment Matrix — room × device-type visual grid showing what's placed where
- ✅ Zone Summary — Network (LAN/PoE), Audio (amp channels/power), AV over IP, Power (UPS Load vs Mains Load) — all with demand vs supply and expandable item lists
- ✅ Feature Matrix — manage features/categories, tick cells, optional quantity, green/amber/empty states, Build from Library, Sync from placement, Excel export
- ✅ Change Control — full CR and revision workflow (see detail below)
- ✅ Global — Device Types, Product Catalogue, System Groups & Categories, Room Templates
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

### Item Change Tracking
- `change_status`: null (baseline) / 'added' / 'modified' / 'removed'
- Badges shown on Equipment Schedule and rooms; historical record stays even after CR approved/closed
- Show Removed toggle on Equipment Schedule reveals soft-deleted items

### Revisions
- Draft → Issued lifecycle; revision numbers follow R0.1 / R0.2 → R1 / R1.1 pattern
- Auto-suggests next revision number when creating
- After issuing, prompts to start the next draft + pre-opens Link CRs modal for unlinked approved CRs
- Link CRs modal: assign approved/closed CRs to a specific revision

### Change Log
- All key actions logged to `change_log` with area, action, summary, user email, and CR reference if active
- Viewable on Change Control → Change Log tab, filterable by area

---

## Pending Backlog (Priority Order)

1. ⬜ Specification section — core document builder (major feature, not started)
2. ⬜ Export Centre — Word/PDF spec, formatted CSV/Excel schedules
3. ⬜ Change Order Management — formal CO document flow (distinct from CR tracking)

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
- All confirm dialogs use custom openConfirm() modal — no native browser confirm() anywhere
- File delivered as index.html for direct GitHub Pages deployment
