-- ============================================================
--  Tennis Round-Robin Manager — Supabase Database Setup
--  Run this entire file in the Supabase SQL Editor
-- ============================================================

-- Create the main data table
create table if not exists tennis_data (
  key        text        primary key,
  value      jsonb       not null,
  updated_at timestamptz default now()
);

-- Insert the initial empty state row
insert into tennis_data (key, value)
values ('state', '{}'::jsonb)
on conflict (key) do nothing;

-- Enable Row Level Security
alter table tennis_data enable row level security;

-- Allow anyone to read data (public scorecard viewing)
create policy "Anyone can read"
  on tennis_data
  for select
  using (true);

-- Allow anyone to insert (required for upsert on first write)
create policy "Anyone can insert"
  on tennis_data
  for insert
  with check (true);

-- Allow anyone to update (score entry by authenticated users)
create policy "Anyone can update"
  on tennis_data
  for update
  using (true);
