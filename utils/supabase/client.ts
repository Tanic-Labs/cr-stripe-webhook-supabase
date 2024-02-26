import * as supabase from "https://esm.sh/@supabase/supabase-js@2";

export const supabaseClient = supabase.createClient(
  Deno.env.get("SUPABASE_URL"),
  Deno.env.get("SUPABASE_TOKEN")
);