DO $$ BEGIN RAISE NOTICE '----'; RAISE NOTICE 'Starting v02_01_create_table_tests_rollback.sql ...'; END $$;

DROP TABLE tests;

DO $$ BEGIN RAISE NOTICE 'Ending v02_01_create_table_tests_rollback.sql'; RAISE NOTICE '----'; END $$;
