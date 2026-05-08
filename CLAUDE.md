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
- `rooms` — deck_id, name, room_id, room_number, position, frame_number, rack_zone_id, notes
- `rack_zones` — project_id, name, zone_id, rack_count, colour, notes

### Global Library
- `global_equipment` — device_type_id, description, category_code, system_group, spec_ref, network_role, avip_role, audio_role, lan_ports, poe_ports, poe_type, power_types (array), power_watts, heat_btu, ups_protected, speaker_channels, spk_watts
- `global_products` — device_type_id, make, model, part_number, network_role, avip_role, audio_role, lan_ports, poe_ports, poe_type, poe_budget_watts, power_types, power_watts, heat_btu, ups_protected, speaker_channels, spk_watts, weight_kg, width_mm, depth_mm, height_mm, notes
- `system_groups` — name, code, sort_order
- `device_categories` — system_group, code, description
- `global_room_templates` — name, description, item_count, item_summary
- `global_room_template_items` — template_id, device_type_id, quantity, notes, sort_order

### Project-Specific
- `project_equipment` — project_id, global_equipment_id, device_type_id, description, category_code, system_group, spec_ref, network_role, avip_role, audio_role, lan_ports, poe_ports, poe_type, power_types, power_watts, heat_btu, ups_protected, speaker_channels, spk_watts, make, model, comments
- `equipment_instances` — project_id, device_id, device_type_id, description, room_id, rack_zone_id, quantity, installation_type, notes
- `room_templates` — project_id, name, description
- `room_template_items` — template_id, device_type_id, quantity, notes, sort_order
- `project_team` — project_id, member_name
- `project_integrators` — project_id, company_name, disciplines (text array), sort_order

### Feature Matrix (NEW — recently added)
- `feature_categories` — project_id, name, sort_order
- `features` — project_id, category_id, name, sort_order
- `feature_device_types` — feature_id, device_type_id (many-to-many link)
- `project_feature_matrix` — project_id, room_id, feature_id, ticked (boolean), quantity (integer)

---

## Application Structure

### Navigation
**Sidebar — Workspace:** All Projects
**Sidebar — Current Project:** Project Info | Layout & Zones | Equipment | Feature Matrix
**Sidebar — Standalone:** Import / Export
**Sidebar — Global:** Groups & Categories | Device Types | Product Catalogue | Room Templates

### Equipment Page Tabs
Project Library | Equipment Schedule | Zone Summary | Room Templates

### Layout & Zones Page Tabs
Decks | Rooms | Rack Zones

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
- ✅ Project Info page — 3-column card layout (Scope, Timeline, Quick Access, Key Contacts, Integrators+Team)
- ✅ Layout & Zones — Decks, Rooms, Rack Zones with full CRUD
- ✅ Equipment — Project Library (pull from global), Equipment Schedule, Zone Summary, Room Templates
- ✅ Global — Device Types, Product Catalogue, System Groups & Categories, Room Templates
- ✅ Import / Export — full coverage of all sections, both global and project
- ✅ Feature Matrix — page shell, toolbar, Manage Features modal (Stage 1 & 2 complete)
- ✅ Authentication (login/logout)

---

## Feature Matrix — Current Build Status

**Stage 1 ✅** — Navigation, page shell, toolbar (search, deck filter, Manage Features, Sync, Export buttons), basic grid render

**Stage 2 ✅** — Manage Features modal with:
- Categories tab: add, rename, delete categories
- Features tab: add features with name, category, searchable multi-select device type linker
- Features list showing linked device types and manual/auto status

**Stage 3 🔄 IN PROGRESS** — Cell interaction:
- Click cell to toggle tick on/off
- Set optional quantity per cell
- Three visual states: ✅ Green (ticked + device placed), ⚠️ Amber (ticked manually, no device placed), Empty

**Stage 4 ⬜** — Sync from placement:
- Button reads placed equipment for project
- For each feature with linked device types, checks each room
- Fills empty cells only — never overwrites manual ticks
- Auto-quantity = count of matching devices placed

**Stage 5 ⬜** — Export:
- Clean Excel for client (rooms as rows, features as columns)
- Green ticks show ✓ + quantity
- Amber ticks flagged differently

---

## Pending Backlog (Priority Order)
1. 🔄 Feature Matrix Stage 3 — cell click interaction + quantity + visual states
2. ⬜ Feature Matrix Stage 4 — sync from placement
3. ⬜ Feature Matrix Stage 5 — export
4. ⬜ Zone Summary — add Power section (UPS Load vs Mains Load)
5. ⬜ Specification section — core document builder (major feature)
6. ⬜ Change Order Management
7. ⬜ Export Centre — Word/PDF spec, CSV schedules

---

## Important Decisions Log
- Scope and team managed via project Edit modal (not inline)
- Pull from Library → modal (not navigate away); individual quickPullToProject also available
- Layout & Zones consolidates Decks+Rooms+Rack Zones into one page with 3 tabs
- Feature matrix: features are per-project, grouped by categories, rooms as rows, features as columns
- Feature cells: tick + optional quantity; three states (green/amber/empty)
- Feature auto-tick: triggered by device type match in room (many device types per feature via feature_device_types table)
- Sync fills empty cells only — manual ticks never overwritten
- File delivered as index.html for direct GitHub Pages deployment
