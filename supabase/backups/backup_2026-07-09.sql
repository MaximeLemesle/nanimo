


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."gender_enum" AS ENUM (
    'male',
    'female',
    'unknown'
);


ALTER TYPE "public"."gender_enum" OWNER TO "postgres";


CREATE TYPE "public"."notification_type_enum" AS ENUM (
    'anniversary',
    'vaccine',
    'vet',
    'deworming',
    'custom'
);


ALTER TYPE "public"."notification_type_enum" OWNER TO "postgres";


CREATE TYPE "public"."subscription_status_enum" AS ENUM (
    'freemium',
    'premium'
);


ALTER TYPE "public"."subscription_status_enum" OWNER TO "postgres";


CREATE TYPE "public"."weight_unit_enum" AS ENUM (
    'kg',
    'g'
);


ALTER TYPE "public"."weight_unit_enum" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  begin
    insert into public.users (id_user, mail, user_name)
    values (
      new.id,
      new.email,
      coalesce(
        new.raw_user_meta_data ->> 'user_name',
        new.raw_user_meta_data ->> 'full_name',
        split_part(new.email, '@', 1)        -- fallback : partie avant le @
      )
    )
    on conflict (id_user) do nothing;         -- idempotent, ne casse pas si déjà là
    return new;
  end;
  $$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rls_auto_enable"() RETURNS "event_trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'pg_catalog'
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION "public"."rls_auto_enable"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."event_image" (
    "id_event_image" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "asset_path" "text" NOT NULL,
    "event_id" "uuid" NOT NULL
);


ALTER TABLE "public"."event_image" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."event_type" (
    "id_event_type" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "is_premium" boolean DEFAULT false NOT NULL,
    "code" "text"
);


ALTER TABLE "public"."event_type" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."events" (
    "id_event" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "title" "text" NOT NULL,
    "description" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "entry_date" timestamp with time zone NOT NULL,
    "event_type_id" "uuid"
);


ALTER TABLE "public"."events" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."health_diary" (
    "id_health_diary" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "is_sterilized" boolean DEFAULT false NOT NULL,
    "is_chipped" boolean DEFAULT false NOT NULL,
    "chip_number" "text",
    "last_deworming_at" "date",
    "last_vet_appointment" "date",
    "pet_id" "uuid" NOT NULL
);


ALTER TABLE "public"."health_diary" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."health_diary_vaccines" (
    "id_health_diary_vaccine" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "vaccine_name" "text" NOT NULL,
    "last_date" "date",
    "next_date" "date",
    "recurrence" integer,
    "dose_number" integer,
    "total_dose_number" integer,
    "health_diary_id" "uuid" NOT NULL
);


ALTER TABLE "public"."health_diary_vaccines" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."health_diary_weight_log" (
    "id_health_diary_weight_log" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "weight" numeric(6,2) NOT NULL,
    "logged_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "pet_id" "uuid" NOT NULL
);


ALTER TABLE "public"."health_diary_weight_log" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."notifications" (
    "id_notification" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "type" "public"."notification_type_enum" NOT NULL,
    "title" "text" NOT NULL,
    "description" "text",
    "pet_icon" "text",
    "sending_at" timestamp with time zone NOT NULL,
    "pet_id" "uuid" NOT NULL
);


ALTER TABLE "public"."notifications" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pet_icons" (
    "id_pet_icon" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "pet_icon_name" "text" NOT NULL,
    "asset_path" "text" NOT NULL,
    "is_premium" boolean DEFAULT false NOT NULL,
    "pet_species_id" "uuid"
);


ALTER TABLE "public"."pet_icons" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pet_race" (
    "id_pet_race" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "pet_race_name" "text" NOT NULL,
    "pet_species_id" "uuid" NOT NULL
);


ALTER TABLE "public"."pet_race" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pet_species" (
    "id_pet_species" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "species_name" "text" NOT NULL,
    "weight_unit" "public"."weight_unit_enum" DEFAULT 'kg'::"public"."weight_unit_enum" NOT NULL,
    "icon_key" "text" DEFAULT 'pets'::"text" NOT NULL
);


ALTER TABLE "public"."pet_species" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pets" (
    "id_pet" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "pet_name" "text" NOT NULL,
    "birthdate" "date",
    "gender" "public"."gender_enum",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "pet_race_id" "uuid",
    "pet_species_id" "uuid" NOT NULL,
    "pet_icon_id" "uuid"
);


ALTER TABLE "public"."pets" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pets_events" (
    "pet_id" "uuid" NOT NULL,
    "event_id" "uuid" NOT NULL
);


ALTER TABLE "public"."pets_events" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."recommended_vaccines" (
    "id_recommended_vaccine" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "category" "text" NOT NULL,
    "recurrence_days" integer NOT NULL,
    "pet_species_id" "uuid" NOT NULL
);


ALTER TABLE "public"."recommended_vaccines" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."subscription_config" (
    "id_subscription_config" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "plan_name" "text" NOT NULL,
    "max_images_per_event" integer NOT NULL,
    "max_pets" integer NOT NULL,
    "max_storage_in_mb" integer NOT NULL
);


ALTER TABLE "public"."subscription_config" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."users" (
    "id_user" "uuid" NOT NULL,
    "user_name" "text" NOT NULL,
    "mail" "text" NOT NULL,
    "subscription_status" "public"."subscription_status_enum" DEFAULT 'freemium'::"public"."subscription_status_enum" NOT NULL,
    "subscription_expires_at" timestamp with time zone,
    "id_subscription_config" "uuid"
);


ALTER TABLE "public"."users" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."users_pets" (
    "user_id" "uuid" NOT NULL,
    "pet_id" "uuid" NOT NULL
);


ALTER TABLE "public"."users_pets" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."vet_visits" (
    "id_vet_visit" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "title" "text" NOT NULL,
    "visited_at" "date" NOT NULL,
    "vet_name" "text",
    "clinic_name" "text",
    "pet_id" "uuid" NOT NULL
);


ALTER TABLE "public"."vet_visits" OWNER TO "postgres";


ALTER TABLE ONLY "public"."event_image"
    ADD CONSTRAINT "event_image_pkey" PRIMARY KEY ("id_event_image");



ALTER TABLE ONLY "public"."event_type"
    ADD CONSTRAINT "event_type_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."event_type"
    ADD CONSTRAINT "event_type_pkey" PRIMARY KEY ("id_event_type");



ALTER TABLE ONLY "public"."events"
    ADD CONSTRAINT "events_pkey" PRIMARY KEY ("id_event");



ALTER TABLE ONLY "public"."health_diary"
    ADD CONSTRAINT "health_diary_id_pet_key" UNIQUE ("pet_id");



ALTER TABLE ONLY "public"."health_diary"
    ADD CONSTRAINT "health_diary_pkey" PRIMARY KEY ("id_health_diary");



ALTER TABLE ONLY "public"."health_diary_vaccines"
    ADD CONSTRAINT "health_diary_vaccines_pkey" PRIMARY KEY ("id_health_diary_vaccine");



ALTER TABLE ONLY "public"."health_diary_weight_log"
    ADD CONSTRAINT "health_diary_weight_log_pkey" PRIMARY KEY ("id_health_diary_weight_log");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("id_notification");



ALTER TABLE ONLY "public"."pet_icons"
    ADD CONSTRAINT "pet_icons_pkey" PRIMARY KEY ("id_pet_icon");



ALTER TABLE ONLY "public"."pet_race"
    ADD CONSTRAINT "pet_race_pkey" PRIMARY KEY ("id_pet_race");



ALTER TABLE ONLY "public"."pet_species"
    ADD CONSTRAINT "pet_species_pkey" PRIMARY KEY ("id_pet_species");



ALTER TABLE ONLY "public"."pet_species"
    ADD CONSTRAINT "pet_species_species_name_key" UNIQUE ("species_name");



ALTER TABLE ONLY "public"."pets_events"
    ADD CONSTRAINT "pets_events_pkey" PRIMARY KEY ("pet_id", "event_id");



ALTER TABLE ONLY "public"."pets"
    ADD CONSTRAINT "pets_pkey" PRIMARY KEY ("id_pet");



ALTER TABLE ONLY "public"."recommended_vaccines"
    ADD CONSTRAINT "recommended_vaccines_pkey" PRIMARY KEY ("id_recommended_vaccine");



ALTER TABLE ONLY "public"."subscription_config"
    ADD CONSTRAINT "subscription_config_pkey" PRIMARY KEY ("id_subscription_config");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_mail_key" UNIQUE ("mail");



ALTER TABLE ONLY "public"."users_pets"
    ADD CONSTRAINT "users_pets_pkey" PRIMARY KEY ("user_id", "pet_id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id_user");



ALTER TABLE ONLY "public"."vet_visits"
    ADD CONSTRAINT "vet_visits_pkey" PRIMARY KEY ("id_vet_visit");



CREATE INDEX "idx_events_entry_date" ON "public"."events" USING "btree" ("entry_date");



CREATE INDEX "idx_health_diary_vaccines_next_date" ON "public"."health_diary_vaccines" USING "btree" ("next_date");



CREATE INDEX "idx_health_diary_weight_log_logged_at" ON "public"."health_diary_weight_log" USING "btree" ("logged_at");



CREATE INDEX "idx_health_diary_weight_log_pet_id" ON "public"."health_diary_weight_log" USING "btree" ("pet_id");



CREATE INDEX "idx_notifications_pet_id" ON "public"."notifications" USING "btree" ("pet_id");



CREATE INDEX "idx_notifications_sending_at" ON "public"."notifications" USING "btree" ("sending_at");



CREATE INDEX "idx_recommended_vaccines_pet_species_id" ON "public"."recommended_vaccines" USING "btree" ("pet_species_id");



CREATE INDEX "idx_vet_visits_pet_id" ON "public"."vet_visits" USING "btree" ("pet_id");



CREATE INDEX "idx_vet_visits_visited_at" ON "public"."vet_visits" USING "btree" ("visited_at");



ALTER TABLE ONLY "public"."event_image"
    ADD CONSTRAINT "event_image_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "public"."events"("id_event") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."events"
    ADD CONSTRAINT "events_event_type_id_fkey" FOREIGN KEY ("event_type_id") REFERENCES "public"."event_type"("id_event_type") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."health_diary"
    ADD CONSTRAINT "health_diary_pet_id_fkey" FOREIGN KEY ("pet_id") REFERENCES "public"."pets"("id_pet") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."health_diary_vaccines"
    ADD CONSTRAINT "health_diary_vaccines_health_diary_id_fkey" FOREIGN KEY ("health_diary_id") REFERENCES "public"."health_diary"("id_health_diary") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."health_diary_weight_log"
    ADD CONSTRAINT "health_diary_weight_log_pet_id_fkey" FOREIGN KEY ("pet_id") REFERENCES "public"."pets"("id_pet") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_pet_id_fkey" FOREIGN KEY ("pet_id") REFERENCES "public"."pets"("id_pet") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."pet_icons"
    ADD CONSTRAINT "pet_icons_pet_species_id_fkey" FOREIGN KEY ("pet_species_id") REFERENCES "public"."pet_species"("id_pet_species") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."pet_race"
    ADD CONSTRAINT "pet_race_id_pet_species_fkey" FOREIGN KEY ("pet_species_id") REFERENCES "public"."pet_species"("id_pet_species") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."pets_events"
    ADD CONSTRAINT "pets_events_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "public"."events"("id_event") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."pets_events"
    ADD CONSTRAINT "pets_events_pet_id_fkey" FOREIGN KEY ("pet_id") REFERENCES "public"."pets"("id_pet") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."pets"
    ADD CONSTRAINT "pets_pet_icon_id_fkey" FOREIGN KEY ("pet_icon_id") REFERENCES "public"."pet_icons"("id_pet_icon") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."pets"
    ADD CONSTRAINT "pets_pet_race_id_fkey" FOREIGN KEY ("pet_race_id") REFERENCES "public"."pet_race"("id_pet_race") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."pets"
    ADD CONSTRAINT "pets_pet_species_id_fkey" FOREIGN KEY ("pet_species_id") REFERENCES "public"."pet_species"("id_pet_species") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."recommended_vaccines"
    ADD CONSTRAINT "recommended_vaccines_pet_species_id_fkey" FOREIGN KEY ("pet_species_id") REFERENCES "public"."pet_species"("id_pet_species") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_id_subscription_config_fkey" FOREIGN KEY ("id_subscription_config") REFERENCES "public"."subscription_config"("id_subscription_config");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_id_user_fkey" FOREIGN KEY ("id_user") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."users_pets"
    ADD CONSTRAINT "users_pets_id_pet_fkey" FOREIGN KEY ("pet_id") REFERENCES "public"."pets"("id_pet") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."users_pets"
    ADD CONSTRAINT "users_pets_id_user_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id_user") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."vet_visits"
    ADD CONSTRAINT "vet_visits_pet_id_fkey" FOREIGN KEY ("pet_id") REFERENCES "public"."pets"("id_pet") ON DELETE CASCADE;



CREATE POLICY "Enable delete for users based on user_id" ON "public"."users_pets" FOR DELETE TO "authenticated" USING ((( SELECT "auth"."uid"() AS "uid") = "user_id"));



CREATE POLICY "Enable insert for authenticated users only" ON "public"."events" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."health_diary_vaccines" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."health_diary_weight_log" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."pets" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable insert for authenticated users only" ON "public"."users_pets" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Enable read access for all users" ON "public"."event_type" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."health_diary_vaccines" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."health_diary_weight_log" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."pet_race" FOR SELECT USING (true);



CREATE POLICY "Enable read access for all users" ON "public"."pet_species" FOR SELECT USING (true);



CREATE POLICY "Enable users to view their own data only" ON "public"."users_pets" FOR SELECT TO "authenticated" USING ((( SELECT "auth"."uid"() AS "uid") = "user_id"));



CREATE POLICY "Users can delete their pets health diary" ON "public"."health_diary" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "health_diary"."pet_id") AND ("up"."user_id" = "auth"."uid"())))));



CREATE POLICY "Users can insert their pets health diary" ON "public"."health_diary" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "health_diary"."pet_id") AND ("up"."user_id" = "auth"."uid"())))));



CREATE POLICY "Users can update their pets health diary" ON "public"."health_diary" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "health_diary"."pet_id") AND ("up"."user_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "health_diary"."pet_id") AND ("up"."user_id" = "auth"."uid"())))));



CREATE POLICY "Users can view their pets health diary" ON "public"."health_diary" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "health_diary"."pet_id") AND ("up"."user_id" = "auth"."uid"())))));



CREATE POLICY "Users manage vet visits of their pets" ON "public"."vet_visits" USING ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "vet_visits"."pet_id") AND ("up"."user_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "vet_visits"."pet_id") AND ("up"."user_id" = "auth"."uid"())))));



ALTER TABLE "public"."event_image" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "event_image of owned events" ON "public"."event_image" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ("public"."pets_events" "pe"
     JOIN "public"."users_pets" "up" ON (("up"."pet_id" = "pe"."pet_id")))
  WHERE (("pe"."event_id" = "event_image"."event_id") AND ("up"."user_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."pets_events" "pe"
     JOIN "public"."users_pets" "up" ON (("up"."pet_id" = "pe"."pet_id")))
  WHERE (("pe"."event_id" = "event_image"."event_id") AND ("up"."user_id" = "auth"."uid"())))));



CREATE POLICY "event_image_delete" ON "public"."event_image" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ("public"."pets_events" "pe"
     JOIN "public"."users_pets" "up" ON (("up"."pet_id" = "pe"."pet_id")))
  WHERE (("pe"."event_id" = "event_image"."event_id") AND ("up"."user_id" = "auth"."uid"())))));



CREATE POLICY "event_image_insert" ON "public"."event_image" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."pets_events" "pe"
     JOIN "public"."users_pets" "up" ON (("up"."pet_id" = "pe"."pet_id")))
  WHERE (("pe"."event_id" = "event_image"."event_id") AND ("up"."user_id" = "auth"."uid"())))));



CREATE POLICY "event_image_select" ON "public"."event_image" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ("public"."pets_events" "pe"
     JOIN "public"."users_pets" "up" ON (("up"."pet_id" = "pe"."pet_id")))
  WHERE (("pe"."event_id" = "event_image"."event_id") AND ("up"."user_id" = "auth"."uid"())))));



ALTER TABLE "public"."event_type" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."events" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "events_delete" ON "public"."events" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ("public"."pets_events" "pe"
     JOIN "public"."users_pets" "up" ON (("up"."pet_id" = "pe"."pet_id")))
  WHERE (("pe"."event_id" = "events"."id_event") AND ("up"."user_id" = "auth"."uid"())))));



CREATE POLICY "events_select" ON "public"."events" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ("public"."pets_events" "pe"
     JOIN "public"."users_pets" "up" ON (("up"."pet_id" = "pe"."pet_id")))
  WHERE (("pe"."event_id" = "events"."id_event") AND ("up"."user_id" = "auth"."uid"())))));



CREATE POLICY "events_update" ON "public"."events" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ("public"."pets_events" "pe"
     JOIN "public"."users_pets" "up" ON (("up"."pet_id" = "pe"."pet_id")))
  WHERE (("pe"."event_id" = "events"."id_event") AND ("up"."user_id" = "auth"."uid"())))));



ALTER TABLE "public"."health_diary" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."health_diary_vaccines" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."health_diary_weight_log" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."notifications" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."pet_icons" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."pet_race" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."pet_species" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."pets" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "pets_delete_own" ON "public"."pets" FOR DELETE USING ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "pets"."id_pet") AND ("up"."user_id" = "auth"."uid"())))));



ALTER TABLE "public"."pets_events" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "pets_events owned" ON "public"."pets_events" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "pets_events"."pet_id") AND ("up"."user_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "pets_events"."pet_id") AND ("up"."user_id" = "auth"."uid"())))));



CREATE POLICY "pets_events_delete" ON "public"."pets_events" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "pets_events"."pet_id") AND ("up"."user_id" = "auth"."uid"())))));



CREATE POLICY "pets_events_insert" ON "public"."pets_events" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "pets_events"."pet_id") AND ("up"."user_id" = "auth"."uid"())))));



CREATE POLICY "pets_events_select" ON "public"."pets_events" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "pets_events"."pet_id") AND ("up"."user_id" = "auth"."uid"())))));



CREATE POLICY "pets_select_own" ON "public"."pets" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "pets"."id_pet") AND ("up"."user_id" = "auth"."uid"())))));



CREATE POLICY "pets_update_own" ON "public"."pets" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "pets"."id_pet") AND ("up"."user_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."users_pets" "up"
  WHERE (("up"."pet_id" = "pets"."id_pet") AND ("up"."user_id" = "auth"."uid"())))));



ALTER TABLE "public"."recommended_vaccines" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "recommended_vaccines_read" ON "public"."recommended_vaccines" FOR SELECT TO "authenticated" USING (true);



ALTER TABLE "public"."subscription_config" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."users" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."users_pets" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."vet_visits" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";






















































































































































GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "anon";
GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "service_role";


















GRANT ALL ON TABLE "public"."event_image" TO "anon";
GRANT ALL ON TABLE "public"."event_image" TO "authenticated";
GRANT ALL ON TABLE "public"."event_image" TO "service_role";



GRANT ALL ON TABLE "public"."event_type" TO "anon";
GRANT ALL ON TABLE "public"."event_type" TO "authenticated";
GRANT ALL ON TABLE "public"."event_type" TO "service_role";



GRANT ALL ON TABLE "public"."events" TO "anon";
GRANT ALL ON TABLE "public"."events" TO "authenticated";
GRANT ALL ON TABLE "public"."events" TO "service_role";



GRANT ALL ON TABLE "public"."health_diary" TO "anon";
GRANT ALL ON TABLE "public"."health_diary" TO "authenticated";
GRANT ALL ON TABLE "public"."health_diary" TO "service_role";



GRANT ALL ON TABLE "public"."health_diary_vaccines" TO "anon";
GRANT ALL ON TABLE "public"."health_diary_vaccines" TO "authenticated";
GRANT ALL ON TABLE "public"."health_diary_vaccines" TO "service_role";



GRANT ALL ON TABLE "public"."health_diary_weight_log" TO "anon";
GRANT ALL ON TABLE "public"."health_diary_weight_log" TO "authenticated";
GRANT ALL ON TABLE "public"."health_diary_weight_log" TO "service_role";



GRANT ALL ON TABLE "public"."notifications" TO "anon";
GRANT ALL ON TABLE "public"."notifications" TO "authenticated";
GRANT ALL ON TABLE "public"."notifications" TO "service_role";



GRANT ALL ON TABLE "public"."pet_icons" TO "anon";
GRANT ALL ON TABLE "public"."pet_icons" TO "authenticated";
GRANT ALL ON TABLE "public"."pet_icons" TO "service_role";



GRANT ALL ON TABLE "public"."pet_race" TO "anon";
GRANT ALL ON TABLE "public"."pet_race" TO "authenticated";
GRANT ALL ON TABLE "public"."pet_race" TO "service_role";



GRANT ALL ON TABLE "public"."pet_species" TO "anon";
GRANT ALL ON TABLE "public"."pet_species" TO "authenticated";
GRANT ALL ON TABLE "public"."pet_species" TO "service_role";



GRANT ALL ON TABLE "public"."pets" TO "anon";
GRANT ALL ON TABLE "public"."pets" TO "authenticated";
GRANT ALL ON TABLE "public"."pets" TO "service_role";



GRANT ALL ON TABLE "public"."pets_events" TO "anon";
GRANT ALL ON TABLE "public"."pets_events" TO "authenticated";
GRANT ALL ON TABLE "public"."pets_events" TO "service_role";



GRANT ALL ON TABLE "public"."recommended_vaccines" TO "anon";
GRANT ALL ON TABLE "public"."recommended_vaccines" TO "authenticated";
GRANT ALL ON TABLE "public"."recommended_vaccines" TO "service_role";



GRANT ALL ON TABLE "public"."subscription_config" TO "anon";
GRANT ALL ON TABLE "public"."subscription_config" TO "authenticated";
GRANT ALL ON TABLE "public"."subscription_config" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";



GRANT ALL ON TABLE "public"."users_pets" TO "anon";
GRANT ALL ON TABLE "public"."users_pets" TO "authenticated";
GRANT ALL ON TABLE "public"."users_pets" TO "service_role";



GRANT ALL ON TABLE "public"."vet_visits" TO "anon";
GRANT ALL ON TABLE "public"."vet_visits" TO "authenticated";
GRANT ALL ON TABLE "public"."vet_visits" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";



































