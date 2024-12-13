from datetime import datetime, timedelta
import json
import pendulum
import yfinance as yf
import pandas as pd

from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.decorators import dag, task

@dag(
    schedule="@daily",
    start_date=pendulum.datetime(2024, 12, 1, tz="UTC"),
    catchup=True, # Changed to `True` for an automatic backfill.
    tags=["portfolio"],
)
def john_example_yfinance_dag():
    """
    ### DAG Docs
    John Fiocca

    Demonstrating using temporary files because outputs of this size can be too much for xcoms.

    This is a naïve example of an ETL for a stock API.

    Finance info is notorious for needing heavy engineering work to run correctly.
    Imagine what happens when there's a stock split!

    Todo:
        [] Run time (end of day for latest data?).
        [] Backfills.
        [] Reruns.
        [] Transformations.
        [] Feature engineering.
    """
    @task()
    def extract(**context):
        """
        #### Extract data from API.
        """

        start_date = context['ds']
        end_date = datetime.strptime(context['ds'], '%Y-%m-%d') + timedelta(days=1)

        symbol = 'SPY'
        t = yf.Ticker(symbol)
        ts = yf.Tickers(' '.join(t.funds_data.top_holdings.index))
        df = ts.history(start=start_date, end=end_date)
        df.unstack().reset_index().to_csv(f'/tmp/spy_holdings{context["ds"]}.csv', index=False)

        print('Yahoo Finance API data extracted.')
        print(start_date)
        print(df)

    @task(multiple_outputs=True)
    def transform(**context):
        """
        #### Transform extracted data.
        """

        df = pd.read_csv(f'/tmp/spy_holdings{context["ds"]}.csv')

        (df.query('Price != "Stock Splits"')
             .rename(columns={'0': 'Value'})
             .to_csv(f'/tmp/spy_holdings_transformed{context["ds"]}.csv', index=False)
         )

        print('Extracted data transformed.')

    @task()
    def load(**context):
        """
        #### Load task to database.
        """
        df = pd.read_csv(f'/tmp/spy_holdings_transformed{context["ds"]}.csv')
        
        hook = PostgresHook(postgres_conn_id="postgres_default")  # Replace with your connection ID
        engine = hook.get_sqlalchemy_engine()

        df.to_sql(
            name="spy_top_holdings_history",
            con=engine,
            if_exists="append",
            index=False,
        )

        print("DataFrame loaded into PostgreSQL.")

    # Queue Tasks
    extract()
    transform()
    load()

john_example_yfinance_dag()
