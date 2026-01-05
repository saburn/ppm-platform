-- Enable Realtime for all tables
-- Copy and paste this into Supabase SQL Editor

ALTER PUBLICATION supabase_realtime ADD TABLE public.portfolios;
ALTER PUBLICATION supabase_realtime ADD TABLE public.programmes;
ALTER PUBLICATION supabase_realtime ADD TABLE public.projects;
ALTER PUBLICATION supabase_realtime ADD TABLE public.tasks;
ALTER PUBLICATION supabase_realtime ADD TABLE public.resources;
ALTER PUBLICATION supabase_realtime ADD TABLE public.risks;

-- Verify it worked
SELECT schemaname, tablename 
FROM pg_publication_tables 
WHERE pubname = 'supabase_realtime';