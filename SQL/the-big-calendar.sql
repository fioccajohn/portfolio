/* The Big Calendar **********************************************************

John Fiocca

TBC is defined here as a CTE to allow for saving as a view with dynamically valued columns.
If speed is ever an issue (it won't be) we can convert each subsection to staged intermediary tables.
*/

/* Encapsulate holiday logic with functions. */
CREATE TEMP FUNCTION
  determine_fixed_holiday(calendar_date DATE)
  RETURNS STRING AS (
    CASE FORMAT_DATE('%m-%d', calendar_date)
      WHEN "01-01" THEN "New Year's Day"
      WHEN "02-02" THEN "Groundhog Day"
      WHEN "02-14" THEN "Valentine's Day"
      WHEN "03-17" THEN "St. Patrick's Day"
      WHEN "06-19" THEN "Juneteenth"
      WHEN "07-04" THEN "Independence Day"
      WHEN "10-31" THEN "Halloween"
      WHEN "11-11" THEN "Veterans Day"
      WHEN "12-25" THEN "Christmas Day"
      WHEN "12-31" THEN "New Year's Eve"
      ELSE NULL
  END
    ) ;

CREATE TEMP FUNCTION
  determine_floating_holiday(
    calendar_date DATE,
    month INT64,
    nth_monday_of_month INT64,
    nth_thursday_of_month INT64,
    nth_sunday_of_month INT64,
    mondays_in_month INT64,
    elapsed_month_thursdays INT64,
    weekday INT64
    )
  RETURNS STRING AS (
    CASE 
      WHEN month = 1 AND nth_monday_of_month = 3 THEN "Martin Luther King Jr. Day"
      WHEN month = 2 AND nth_monday_of_month = 3 THEN "Presidents' Day"
      WHEN month = 5 AND nth_monday_of_month = mondays_in_month THEN "Memorial Day"
      WHEN month = 9 AND nth_monday_of_month = 1 THEN "Labor Day"
      WHEN month = 10 AND nth_monday_of_month = 2 THEN "Columbus Day"
      WHEN month = 11 AND nth_thursday_of_month = 4 THEN "Thanksgiving Day"
      WHEN month = 5 AND nth_sunday_of_month = 2 THEN "Mother's Day"
      WHEN month = 6 AND nth_sunday_of_month = 3 THEN "Father's Day"
      WHEN month = 11 AND elapsed_month_thursdays = 4 AND weekday = 5 THEN "Black Friday"
      ELSE NULL
    END
);

WITH
preprocessing AS (
  SELECT
	CURRENT_TIMESTAMP AS now,
    CURRENT_DATE AS today,
    CURRENT_DATE + 1 AS tomorrow,
    CURRENT_DATE - 1 AS yesterday,
    calendar_date,
    LAG(calendar_date) OVER (ORDER BY calendar_date) AS previous_day,
    LEAD(calendar_date) OVER (ORDER BY calendar_date) AS next_day,
    EXTRACT(DAYOFWEEK FROM calendar_date) AS weekday,
    EXTRACT(DAY FROM calendar_date) AS day_of_month,
    EXTRACT(DAYOFYEAR FROM calendar_date) AS day_of_year,
  	CEIL(EXTRACT(DAY FROM calendar_date) / 7) AS week_of_month,
    EXTRACT(WEEK FROM calendar_date) AS week,
    EXTRACT(MONTH FROM calendar_date) AS month,
    EXTRACT(QUARTER FROM calendar_date) AS quarter,
    EXTRACT(YEAR FROM calendar_date) AS year,
    EXTRACT(WEEK(SATURDAY) FROM calendar_date) AS retail_week,
    EXTRACT(ISOYEAR FROM calendar_date) AS isoyear,
    EXTRACT(ISOWEEK FROM calendar_date) AS isoweek,
    DATE_TRUNC(calendar_date, WEEK) AS first_day_of_week,
    DATE_TRUNC(calendar_date, MONTH) AS first_day_of_month,
    DATE_TRUNC(calendar_date, QUARTER) AS first_day_of_quarter,
    DATE_TRUNC(calendar_date, YEAR) AS first_day_of_year,
    LAST_DAY(calendar_date, WEEK) AS last_day_of_week,
    LAST_DAY(calendar_date, MONTH) AS last_day_of_month,
    LAST_DAY(calendar_date, QUARTER) AS last_day_of_quarter,
    LAST_DAY(calendar_date, YEAR) AS last_day_of_year,
  FROM
    UNNEST(GENERATE_DATE_ARRAY('1959-06-18', '2060-06-18')) AS calendar_date
), feature_engineering__julian1 AS (
  SELECT
    *,
	ROW_NUMBER() OVER window__quarter AS day_of_quarter,
	7 AS days_in_week,
    EXTRACT(DAY FROM last_day_of_month) AS days_in_month,
    (DATE_DIFF(last_day_of_quarter, first_day_of_quarter, DAY) + 1) AS days_in_quarter,
    (DATE_DIFF(last_day_of_year, first_day_of_year, DAY) + 1) AS days_in_year,
	(weekday = 1) AS is_sunday,
    (weekday = 3) AS is_tuesday,
    (weekday = 2) AS is_monday,
    (weekday = 4) AS is_wednesday,
    (weekday = 5) AS is_thursday,
    (weekday = 6) AS is_friday,
    (weekday = 7) AS is_saturday,
    (weekday BETWEEN 2 AND 6) AS is_weekday,
    (weekday NOT BETWEEN 2 AND 6) AS is_weekend,
    (calendar_date = first_day_of_week) AS is_first_day_of_week,
    (calendar_date = first_day_of_month) AS is_first_day_of_month,
    (calendar_date = first_day_of_quarter) AS is_first_day_of_quarter,
    (calendar_date = first_day_of_year) AS is_first_day_of_year,
    (calendar_date = last_day_of_week) AS is_last_day_of_week,
    (calendar_date = last_day_of_month) AS is_last_day_of_month,
    (calendar_date = last_day_of_quarter) AS is_last_day_of_quarter,
    (calendar_date = last_day_of_year) AS is_last_day_of_year,
  FROM
    preprocessing
  WINDOW
	window__quarter AS (PARTITION BY year, quarter)
), feature_engineering__julian2 AS (
  SELECT
    *,
    weekday / days_in_week AS pct_week_elapsed,
    day_of_month / days_in_month AS pct_month_elapsed,
    day_of_quarter / days_in_quarter AS pct_quarter_elapsed,
    day_of_year / days_in_year AS pct_year_elapsed,
    days_in_week / weekday AS simple_scaling_factor__end_of_week,
    days_in_month / day_of_month AS simple_scaling_factor__end_of_month,
    days_in_quarter / day_of_quarter AS simple_scaling_factor__end_of_quarter,
    days_in_year / day_of_year AS simple_scaling_factor__end_of_year,
    COUNTIF(is_sunday) OVER window__month AS elapsed_month_sundays,
    COUNTIF(is_monday) OVER window__month AS elapsed_month_mondays,
    COUNTIF(is_tuesday) OVER window__month AS elapsed_month_tuesdays,
    COUNTIF(is_wednesday) OVER window__month AS elapsed_month_wednesdays,
    COUNTIF(is_thursday) OVER window__month AS elapsed_month_thursdays,
    COUNTIF(is_friday) OVER window__month AS elapsed_month_fridays,
    COUNTIF(is_saturday) OVER window__month AS elapsed_month_saturdays,
    COUNTIF(is_sunday) OVER window__month__boundless AS sundays_in_month,
    COUNTIF(is_monday) OVER window__month__boundless AS mondays_in_month,
    COUNTIF(is_tuesday) OVER window__month__boundless AS tuesdays_in_month,
    COUNTIF(is_wednesday) OVER window__month__boundless AS wednesdays_in_month,
    COUNTIF(is_thursday) OVER window__month__boundless AS thursdays_in_month,
    COUNTIF(is_friday) OVER window__month__boundless AS fridays_in_month,
    COUNTIF(is_saturday) OVER window__month__boundless AS saturdays_in_month,
  FROM
    feature_engineering__julian1
  WINDOW
  	window__month AS (PARTITION BY year, month ORDER BY calendar_date),
  	window__month__boundless AS (PARTITION BY year, month)
), feature_engineering__julian3 AS (
  SELECT
    *,
    IF(is_sunday, elapsed_month_sundays, NULL) AS nth_sunday_of_month,
    IF(is_monday, elapsed_month_mondays, NULL) AS nth_monday_of_month,
    IF(is_tuesday, elapsed_month_tuesdays, NULL) AS nth_tuesday_of_month,
    IF(is_wednesday, elapsed_month_wednesdays, NULL) AS nth_wednesday_of_month,
    IF(is_thursday, elapsed_month_thursdays, NULL) AS nth_thursday_of_month,
    IF(is_friday, elapsed_month_fridays, NULL) AS nth_friday_of_month,
    IF(is_saturday, elapsed_month_saturdays, NULL) AS nth_saturday_of_month,
  FROM
	feature_engineering__julian2
), feature_engineering__holidays1 AS (
  SELECT
    *,
    /* Fixed */
    determine_fixed_holiday(calendar_date) AS fixed_holidays,
    /* Floating */
    determine_floating_holiday(
      calendar_date,
      month,
      nth_monday_of_month,
      nth_thursday_of_month,
      nth_sunday_of_month,
      mondays_in_month,
      elapsed_month_thursdays,
      weekday) AS floating_holidays,
  FROM
    feature_engineering__julian3
), feature_engineering__holidays2 AS (
  SELECT
    *,
	IF(fixed_holidays IS NOT NULL, calendar_date, NULL) AS holiday_date,
	FIRST_VALUE(IF(fixed_holidays IS NOT NULL, fixed_holidays, NULL) IGNORE NULLS) OVER window__from_here_to_eternity AS next_holiday_name,
	FIRST_VALUE(IF(fixed_holidays IS NOT NULL, calendar_date, NULL) IGNORE NULLS) OVER window__from_here_to_eternity AS next_holiday_date,
	(LAG(fixed_holidays) OVER (ORDER BY calendar_date) IS NOT NULL) AS yesterday_was_a_holiday,
  FROM
    feature_engineering__holidays1
  WINDOW
    window__from_here_to_eternity AS (ORDER BY calendar_date ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
), feature_engineering__holidays3 AS (
	SELECT
		*,
		(next_holiday_date - calendar_date) AS days_until_next_holiday,
		COUNT(*) OVER (PARTITION BY next_holiday_date) AS days_between_previous_and_next_holiday,
		(INTERVAL (COUNT(*) OVER (PARTITION BY next_holiday_date)) DAY - (next_holiday_date - calendar_date)) AS days_since_previous_holiday,
		(
			EXTRACT(DAY FROM (INTERVAL (COUNT(*) OVER (PARTITION BY next_holiday_date)) DAY) - (next_holiday_date - calendar_date))
			/
			COUNT(*) OVER (PARTITION BY next_holiday_date)
		) AS next_holiday_nearness_variable,
		(calendar_date - (INTERVAL (COUNT(*) OVER (PARTITION BY next_holiday_date)) DAY - (next_holiday_date - calendar_date))) AS previous_holiday_date,
		COALESCE(fixed_holidays, floating_holidays) AS holiday,
	FROM
		feature_engineering__holidays2
	ORDER BY
	  calendar_date
), postprocessing AS (
  SELECT
    *,
    (calendar_date = today) AS in_today,
    (week = EXTRACT(MONTH FROM today) AND year = EXTRACT(YEAR FROM today)) AS in_this_week,
    (month = EXTRACT(MONTH FROM today) AND year = EXTRACT(YEAR FROM today)) AS in_this_month,
    (quarter = EXTRACT(QUARTER FROM today) AND year = EXTRACT(YEAR FROM today)) AS in_this_quarter,
    (year = EXTRACT(YEAR FROM today)) AS in_this_year,
    (calendar_date = tomorrow) AS in_tomorrow,
    (calendar_date = yesterday) AS in_yesterday,
    (calendar_date BETWEEN today AND today + 7) AS in_next_7_days,
    (calendar_date BETWEEN today AND today + 30) AS in_next_30_days,
    (calendar_date BETWEEN today AND today + 60) AS in_next_60_days,
    (calendar_date BETWEEN today AND today + 90) AS in_next_90_days,
    (calendar_date BETWEEN today - 7 AND today) AS in_past_7_days,
    (calendar_date BETWEEN today - 30 AND today) AS in_past_30_days,
    (calendar_date BETWEEN today - 60 AND today) AS in_past_60_days,
    (calendar_date BETWEEN today - 90 AND today) AS in_past_90_days,
    COUNTIF(is_first_day_of_month) OVER (PARTITION BY week, year) AS week_contains_first_of_month,
    COUNTIF(holiday IS NOT NULL) OVER (PARTITION BY week, year) AS week_contains_holiday,
  FROM
    feature_engineering__holidays3
)
SELECT
  *
FROM
  postprocessing
;