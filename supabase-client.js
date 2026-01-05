// Supabase Client Configuration
const SUPABASE_URL = 'https://lliaofstnyfhvkwkyfcm.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_hqGzCnomaVhT7l_xtkephQ_DHdrSuqj';

// Initialize Supabase client
const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Authentication helpers
const auth = {
    // Sign up new user
    async signUp(email, password, fullName) {
        try {
            const { data, error } = await supabase.auth.signUp({
                email,
                password,
                options: {
                    data: {
                        full_name: fullName
                    }
                }
            });
            if (error) throw error;
            return { success: true, data };
        } catch (error) {
            console.error('Sign up error:', error);
            return { success: false, error: error.message };
        }
    },

    // Sign in existing user
    async signIn(email, password) {
        try {
            const { data, error } = await supabase.auth.signInWithPassword({
                email,
                password
            });
            if (error) throw error;
            return { success: true, data };
        } catch (error) {
            console.error('Sign in error:', error);
            return { success: false, error: error.message };
        }
    },

    // Sign out
    async signOut() {
        try {
            const { error } = await supabase.auth.signOut();
            if (error) throw error;
            return { success: true };
        } catch (error) {
            console.error('Sign out error:', error);
            return { success: false, error: error.message };
        }
    },

    // Get current user
    async getCurrentUser() {
        try {
            const { data: { user }, error } = await supabase.auth.getUser();
            if (error) throw error;
            return user;
        } catch (error) {
            console.error('Get user error:', error);
            return null;
        }
    },

    // Check if user is authenticated
    async isAuthenticated() {
        const user = await this.getCurrentUser();
        return !!user;
    }
};

// Database helpers
const db = {
    // Portfolios
    portfolios: {
        async getAll() {
            const { data, error } = await supabase
                .from('portfolios')
                .select('*')
                .order('created_at', { ascending: false });
            if (error) throw error;
            return data;
        },
        async create(portfolio) {
            const user = await auth.getCurrentUser();
            const { data, error } = await supabase
                .from('portfolios')
                .insert([{ ...portfolio, owner_id: user.id }])
                .select();
            if (error) throw error;
            return data[0];
        },
        async update(id, updates) {
            const { data, error } = await supabase
                .from('portfolios')
                .update(updates)
                .eq('id', id)
                .select();
            if (error) throw error;
            return data[0];
        },
        async delete(id) {
            const { error } = await supabase
                .from('portfolios')
                .delete()
                .eq('id', id);
            if (error) throw error;
            return true;
        }
    },

    // Programmes
    programmes: {
        async getAll(portfolioId = null) {
            let query = supabase
                .from('programmes')
                .select('*')
                .order('created_at', { ascending: false });
            
            if (portfolioId) {
                query = query.eq('portfolio_id', portfolioId);
            }
            
            const { data, error } = await query;
            if (error) throw error;
            return data;
        },
        async create(programme) {
            const user = await auth.getCurrentUser();
            const { data, error } = await supabase
                .from('programmes')
                .insert([{ ...programme, owner_id: user.id }])
                .select();
            if (error) throw error;
            return data[0];
        },
        async update(id, updates) {
            const { data, error } = await supabase
                .from('programmes')
                .update(updates)
                .eq('id', id)
                .select();
            if (error) throw error;
            return data[0];
        },
        async delete(id) {
            const { error } = await supabase
                .from('programmes')
                .delete()
                .eq('id', id);
            if (error) throw error;
            return true;
        }
    },

    // Projects
    projects: {
        async getAll(programmeId = null) {
            let query = supabase
                .from('projects')
                .select('*')
                .order('created_at', { ascending: false });
            
            if (programmeId) {
                query = query.eq('programme_id', programmeId);
            }
            
            const { data, error } = await query;
            if (error) throw error;
            return data;
        },
        async getById(id) {
            const { data, error } = await supabase
                .from('projects')
                .select('*')
                .eq('id', id)
                .single();
            if (error) throw error;
            return data;
        },
        async create(project) {
            const user = await auth.getCurrentUser();
            const { data, error } = await supabase
                .from('projects')
                .insert([{ ...project, owner_id: user.id }])
                .select();
            if (error) throw error;
            return data[0];
        },
        async update(id, updates) {
            const { data, error } = await supabase
                .from('projects')
                .update(updates)
                .eq('id', id)
                .select();
            if (error) throw error;
            return data[0];
        },
        async delete(id) {
            const { error } = await supabase
                .from('projects')
                .delete()
                .eq('id', id);
            if (error) throw error;
            return true;
        }
    },

    // Tasks
    tasks: {
        async getAll(projectId = null) {
            let query = supabase
                .from('tasks')
                .select('*')
                .order('created_at', { ascending: false });
            
            if (projectId) {
                query = query.eq('project_id', projectId);
            }
            
            const { data, error } = await query;
            if (error) throw error;
            return data;
        },
        async create(task) {
            const user = await auth.getCurrentUser();
            const { data, error } = await supabase
                .from('tasks')
                .insert([{ ...task, owner_id: user.id }])
                .select();
            if (error) throw error;
            return data[0];
        },
        async update(id, updates) {
            const { data, error } = await supabase
                .from('tasks')
                .update(updates)
                .eq('id', id)
                .select();
            if (error) throw error;
            return data[0];
        },
        async delete(id) {
            const { error } = await supabase
                .from('tasks')
                .delete()
                .eq('id', id);
            if (error) throw error;
            return true;
        }
    },

    // Resources
    resources: {
        async getAll(projectId = null) {
            let query = supabase
                .from('resources')
                .select('*')
                .order('created_at', { ascending: false });
            
            if (projectId) {
                query = query.eq('project_id', projectId);
            }
            
            const { data, error } = await query;
            if (error) throw error;
            return data;
        },
        async create(resource) {
            const user = await auth.getCurrentUser();
            const { data, error } = await supabase
                .from('resources')
                .insert([{ ...resource, owner_id: user.id }])
                .select();
            if (error) throw error;
            return data[0];
        },
        async update(id, updates) {
            const { data, error } = await supabase
                .from('resources')
                .update(updates)
                .eq('id', id)
                .select();
            if (error) throw error;
            return data[0];
        },
        async delete(id) {
            const { error } = await supabase
                .from('resources')
                .delete()
                .eq('id', id);
            if (error) throw error;
            return true;
        }
    },

    // Risks
    risks: {
        async getAll(projectId = null) {
            let query = supabase
                .from('risks')
                .select('*')
                .order('created_at', { ascending: false });
            
            if (projectId) {
                query = query.eq('project_id', projectId);
            }
            
            const { data, error } = await query;
            if (error) throw error;
            return data;
        },
        async create(risk) {
            const user = await auth.getCurrentUser();
            const { data, error } = await supabase
                .from('risks')
                .insert([{ ...risk, owner_id: user.id }])
                .select();
            if (error) throw error;
            return data[0];
        },
        async update(id, updates) {
            const { data, error } = await supabase
                .from('risks')
                .update(updates)
                .eq('id', id)
                .select();
            if (error) throw error;
            return data[0];
        },
        async delete(id) {
            const { error } = await supabase
                .from('risks')
                .delete()
                .eq('id', id);
            if (error) throw error;
            return true;
        }
    }
};

// Real-time subscriptions
const realtime = {
    // Subscribe to table changes
    subscribe(table, callback) {
        return supabase
            .channel(`${table}_changes`)
            .on('postgres_changes', 
                { event: '*', schema: 'public', table: table },
                callback
            )
            .subscribe();
    },

    // Unsubscribe from channel
    unsubscribe(channel) {
        supabase.removeChannel(channel);
    }
};

// Export for use in other files
window.supabaseClient = {
    supabase,
    auth,
    db,
    realtime
};

console.log('✅ Supabase client initialized successfully!');