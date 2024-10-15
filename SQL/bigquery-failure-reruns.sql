/*******************************************************************************
Instructions:
  1. Paste your script code between start and end banners below.
  2. Adjust `failure_limit` and `sleep_minutes` parameters as needed.
  3. Schedule.

Note that this entire procedure can be stored as a named procedure.
*******************************************************************************/

BEGIN

DECLARE failure_limit INT64 DEFAULT 3;
DECLARE sleep_minutes INT64 DEFAULT 1;

DECLARE failure_count INT64 DEFAULT 0;
DECLARE failure_threshold INT64;
DECLARE sleeping BOOL DEFAULT FALSE;
DECLARE pause_time TIMESTAMP;

SET failure_threshold = failure_limit - 1;

REPEAT
  BEGIN
/*******************************************************************************
Script start.
*******************************************************************************/
SELECT TRUE;

/* Failure for examples. */
-- SELECT ERROR("An error occurred.")

/*******************************************************************************
Script end.
*******************************************************************************/
    BREAK;

  EXCEPTION WHEN ERROR THEN
    SET failure_count = failure_count + 1;
    SET pause_time = CURRENT_TIMESTAMP + INTERVAL sleep_minutes MINUTE;
    WHILE CURRENT_TIMESTAMP <= pause_time DO
      SET sleeping = TRUE;
    END WHILE;
    SET sleeping = FALSE;
  END;
UNTIL failure_count >= failure_threshold
END REPEAT;

IF failure_count >= failure_threshold THEN
  RAISE USING MESSAGE = FORMAT("Script reached failure limit of %d.", failure_limit);
END IF;

END;
