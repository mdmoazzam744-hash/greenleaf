-- Greenleaf Plant Care App - Supabase Schema & Sample Data
-- Run this in your Supabase Dashboard -> SQL Editor

-- 1. Plants table
create table if not exists public.plants (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  emoji text not null default '🪴',
  room text not null,
  water_every_days integer not null check (water_every_days > 0),
  last_watered_at timestamptz not null default now(),
  sunlight text not null default 'Bright indirect light',
  care_tip text not null default 'Check the top of the soil before watering and enjoy watching it grow.',
  created_at timestamptz not null default now()
);

-- 2. Watering log table
create table if not exists public.watering_log (
  id uuid primary key default gen_random_uuid(),
  plant_id uuid not null references public.plants(id) on delete cascade,
  plant_name text not null,
  watered_at timestamptz not null default now(),
  note text
);

create index if not exists idx_watering_log_plant_id
  on public.watering_log (plant_id);

create index if not exists idx_watering_log_watered_at
  on public.watering_log (watered_at desc);

-- 3. Row Level Security policies for anon/authenticated app access
alter table public.plants enable row level security;
alter table public.watering_log enable row level security;

drop policy if exists "Allow public read plants" on public.plants;
create policy "Allow public read plants"
  on public.plants for select
  to anon, authenticated
  using (true);

drop policy if exists "Allow public insert plants" on public.plants;
create policy "Allow public insert plants"
  on public.plants for insert
  to anon, authenticated
  with check (true);

drop policy if exists "Allow public update plants" on public.plants;
create policy "Allow public update plants"
  on public.plants for update
  to anon, authenticated
  using (true)
  with check (true);

drop policy if exists "Allow public delete plants" on public.plants;
create policy "Allow public delete plants"
  on public.plants for delete
  to anon, authenticated
  using (true);

drop policy if exists "Allow public read watering_log" on public.watering_log;
create policy "Allow public read watering_log"
  on public.watering_log for select
  to anon, authenticated
  using (true);

drop policy if exists "Allow public insert watering_log" on public.watering_log;
create policy "Allow public insert watering_log"
  on public.watering_log for insert
  to anon, authenticated
  with check (true);

-- 4. Seed the 8 sample plants (skips any already added by name)
insert into public.plants (name, emoji, room, water_every_days, last_watered_at, sunlight, care_tip)
select v.name, v.emoji, v.room, v.water_every_days, v.last_watered_at, v.sunlight, v.care_tip
from (
  values
    ('Money Plant', '🍀', 'Living Room', 3, now() - interval '3 days', 'Bright indirect light', 'Let the top inch of soil dry slightly between waterings and wipe the glossy leaves gently.'),
    ('Aloe Vera', '🪴', 'Bedroom Sill', 14, now() - interval '9 days', 'Warm sunny window', 'Water deeply but infrequently, and make sure the pot drains well so roots stay crisp.'),
    ('Snake Plant', '🌿', 'Bedroom', 10, now() - interval '7 days', 'Low to bright light', 'Thrives on gentle neglect—avoid pouring water into the centre rosette of leaves.'),
    ('Tulsi', '🌱', 'Balcony', 1, now() - interval '1 day', 'Direct morning sun', 'Keep the soil evenly moist and pinch off flower spikes to encourage lush fragrant leaves.'),
    ('Rose', '🌹', 'Garden', 2, now() - interval '2 days', 'Full sunlight (6+ hrs)', 'Water at the base in the morning rather than on the petals to keep blooms fresh and vibrant.'),
    ('Mint', '🍃', 'Kitchen', 2, now() - interval '2 days', 'Partial sun to bright light', 'Loves consistently damp soil and regular snipping from the top for bushy regrowth.'),
    ('Peace Lily', '🌸', 'Living Room', 4, now() - interval '4 days', 'Soft filtered shade', 'Droops dramatically when thirsty and perks right back up soon after a refreshing drink.'),
    ('Cactus', '🌵', 'Study Desk', 21, now() - interval '9 days', 'Direct bright sunlight', 'Allow the sandy soil to dry completely before watering lightly around the base.')
) as v(name, emoji, room, water_every_days, last_watered_at, sunlight, care_tip)
where not exists (
  select 1 from public.plants p where p.name = v.name
);
