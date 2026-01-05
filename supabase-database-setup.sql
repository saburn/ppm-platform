-- ============================================
-- SUPABASE DATABASE SETUP FOR PPM PLATFORM
-- ============================================
-- Copy and paste this entire SQL into Supabase SQL Editor
-- Go to: Supabase Dashboard → SQL Editor → New Query

-- ============================================
-- 1. CREATE TABLES
-- ============================================

-- User Profiles (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS public.user_profiles (
  id UUID REFERENCES auth.users PRIMARY KEY,
  full_name TEXT,
  avatar_url TEXT,
  role TEXT DEFAULT 'user',
  company TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Portfolios
CREATE TABLE IF NOT EXISTS public.portfolios (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  total_value DECIMAL(15,2) DEFAULT 0,
  health_score INTEGER DEFAULT 85,
  status TEXT DEFAULT 'active',
  owner_id UUID REFERENCES auth.users NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Programmes
CREATE TABLE IF NOT EXISTS public.programmes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  portfolio_id UUID REFERENCES public.portfolios ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  investment DECIMAL(15,2) DEFAULT 0,
  roi DECIMAL(10,2) DEFAULT 0,
  status TEXT DEFAULT 'active',
  health_score INTEGER DEFAULT 85,
  owner_id UUID REFERENCES auth.users NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Projects
CREATE TABLE IF NOT EXISTS public.projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  programme_id UUID REFERENCES public.programmes ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  budget DECIMAL(15,2) DEFAULT 0,
  spent DECIMAL(15,2) DEFAULT 0,
  status TEXT DEFAULT 'planning',
  progress INTEGER DEFAULT 0,
  health_score INTEGER DEFAULT 85,
  manager TEXT,
  sponsor TEXT,
  start_date DATE,
  end_date DATE,
  owner_id UUID REFERENCES auth.users NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tasks
CREATE TABLE IF NOT EXISTS public.tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES public.projects ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'todo',
  priority TEXT DEFAULT 'medium',
  assignee TEXT,
  due_date DATE,
  progress INTEGER DEFAULT 0,
  owner_id UUID REFERENCES auth.users NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Resources
CREATE TABLE IF NOT EXISTS public.resources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES public.projects ON DELETE CASCADE,
  name TEXT NOT NULL,
  role TEXT,
  department TEXT,
  utilization INTEGER DEFAULT 0,
  availability TEXT DEFAULT 'available',
  owner_id UUID REFERENCES auth.users NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Risks
CREATE TABLE IF NOT EXISTS public.risks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES public.projects ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  severity TEXT DEFAULT 'medium',
  probability TEXT DEFAULT 'medium',
  impact TEXT DEFAULT 'medium',
  status TEXT DEFAULT 'open',
  owner TEXT,
  owner_id UUID REFERENCES auth.users NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 2. ENABLE ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.portfolios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.programmes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.risks ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 3. CREATE RLS POLICIES
-- ============================================

-- User Profiles Policies
CREATE POLICY "Users can view own profile" 
  ON public.user_profiles FOR SELECT 
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" 
  ON public.user_profiles FOR UPDATE 
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" 
  ON public.user_profiles FOR INSERT 
  WITH CHECK (auth.uid() = id);

-- Portfolios Policies
CREATE POLICY "Users can view own portfolios" 
  ON public.portfolios FOR SELECT 
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can create portfolios" 
  ON public.portfolios FOR INSERT 
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own portfolios" 
  ON public.portfolios FOR UPDATE 
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete own portfolios" 
  ON public.portfolios FOR DELETE 
  USING (auth.uid() = owner_id);

-- Programmes Policies
CREATE POLICY "Users can view own programmes" 
  ON public.programmes FOR SELECT 
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can create programmes" 
  ON public.programmes FOR INSERT 
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own programmes" 
  ON public.programmes FOR UPDATE 
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete own programmes" 
  ON public.programmes FOR DELETE 
  USING (auth.uid() = owner_id);

-- Projects Policies
CREATE POLICY "Users can view own projects" 
  ON public.projects FOR SELECT 
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can create projects" 
  ON public.projects FOR INSERT 
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own projects" 
  ON public.projects FOR UPDATE 
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete own projects" 
  ON public.projects FOR DELETE 
  USING (auth.uid() = owner_id);

-- Tasks Policies
CREATE POLICY "Users can view own tasks" 
  ON public.tasks FOR SELECT 
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can create tasks" 
  ON public.tasks FOR INSERT 
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own tasks" 
  ON public.tasks FOR UPDATE 
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete own tasks" 
  ON public.tasks FOR DELETE 
  USING (auth.uid() = owner_id);

-- Resources Policies
CREATE POLICY "Users can view own resources" 
  ON public.resources FOR SELECT 
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can create resources" 
  ON public.resources FOR INSERT 
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own resources" 
  ON public.resources FOR UPDATE 
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete own resources" 
  ON public.resources FOR DELETE 
  USING (auth.uid() = owner_id);

-- Risks Policies
CREATE POLICY "Users can view own risks" 
  ON public.risks FOR SELECT 
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can create risks" 
  ON public.risks FOR INSERT 
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own risks" 
  ON public.risks FOR UPDATE 
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete own risks" 
  ON public.risks FOR DELETE 
  USING (auth.uid() = owner_id);

-- ============================================
-- 4. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX IF NOT EXISTS idx_portfolios_owner ON public.portfolios(owner_id);
CREATE INDEX IF NOT EXISTS idx_programmes_portfolio ON public.programmes(portfolio_id);
CREATE INDEX IF NOT EXISTS idx_programmes_owner ON public.programmes(owner_id);
CREATE INDEX IF NOT EXISTS idx_projects_programme ON public.projects(programme_id);
CREATE INDEX IF NOT EXISTS idx_projects_owner ON public.projects(owner_id);
CREATE INDEX IF NOT EXISTS idx_tasks_project ON public.tasks(project_id);
CREATE INDEX IF NOT EXISTS idx_tasks_owner ON public.tasks(owner_id);
CREATE INDEX IF NOT EXISTS idx_resources_project ON public.resources(project_id);
CREATE INDEX IF NOT EXISTS idx_resources_owner ON public.resources(owner_id);
CREATE INDEX IF NOT EXISTS idx_risks_project ON public.risks(project_id);
CREATE INDEX IF NOT EXISTS idx_risks_owner ON public.risks(owner_id);

-- ============================================
-- 5. CREATE FUNCTIONS FOR AUTO-UPDATING
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for all tables
CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON public.user_profiles 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_portfolios_updated_at BEFORE UPDATE ON public.portfolios 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_programmes_updated_at BEFORE UPDATE ON public.programmes 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON public.projects 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON public.tasks 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_resources_updated_at BEFORE UPDATE ON public.resources 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_risks_updated_at BEFORE UPDATE ON public.risks 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 6. INSERT SAMPLE DATA (OPTIONAL)
-- ============================================

-- Note: This will only work after you create your first user account
-- You can run this later after signing up

-- Sample Portfolio
-- INSERT INTO public.portfolios (name, description, total_value, health_score, owner_id)
-- VALUES ('Enterprise Portfolio', 'Main enterprise portfolio', 8400000, 85, auth.uid());

-- ============================================
-- SETUP COMPLETE! ✅
-- ============================================

-- Next steps:
-- 1. Go to Authentication → Enable Email provider
-- 2. Go to Database → Replication → Enable for all tables
-- 3. Test by creating a user account