/******************************************************************************
BQ Failure Reruns

John Fiocca

Some queries fail simply because of their running during a data update in BQ.
A simple rerun will succeed.
Procedural logic is a quicker solution for data analysts than ETL engineering.

Instructions:
  1. Paste script between the script start and end banners below.
  2. Adjust the `failure_limit` and `sleep_minutes` parameters as needed.
  3. Schedule.
******************************************************************************/

BEGIN

  DECLARE failure_limit INT64 DEFAULT 5;
  -- DECLARE sleep_seconds INT64 DEFAULT 60;
  DECLARE sleep_seconds INT64 DEFAULT 3; -- Shorter time for demonstration.

  DECLARE failure_count INT64 DEFAULT 0;
  DECLARE sleeping BOOL DEFAULT FALSE;
  DECLARE pause_time TIMESTAMP;

  REPEAT
    BEGIN
      /******************************************************************************
      Script start.
      ******************************************************************************/
      CREATE OR REPLACE TEMP TABLE example_table
      (some_value BOOL)
      ;

      CREATE OR REPLACE TEMP TABLE some_results AS
      SELECT TRUE AS some_value;

      /* Uncomment for example exception raise. */
      SELECT ERROR("A problem occurred.");

      INSERT INTO
        example_table
      SELECT * FROM x
      ;

      /******************************************************************************
      Script end.
      ******************************************************************************/
      BREAK;

    EXCEPTION WHEN ERROR THEN
      SET failure_count = failure_count + 1;
      SET pause_time = CURRENT_TIMESTAMP + INTERVAL sleep_seconds SECOND;
      WHILE CURRENT_TIMESTAMP <= pause_time DO
        SET sleeping = TRUE;
      END WHILE;
      SET sleeping = FALSE;
    END;
  UNTIL failure_count >= failure_limit
  END REPEAT;

IF failure_count >= failure_limit THEN
  RAISE USING MESSAGE = FORMAT("Script reached failure limit of %d.", failure_limit);
END IF;

END;