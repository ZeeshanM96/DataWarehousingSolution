import os
import pandas as pd
import psycopg2
from psycopg2 import sql

# Database connection configuration
DB_CONFIG = {
    'host': 'postgres',  
    'port': 5432,
    'dbname': 'postgres',
    'user': 'postgres',
    'password': 'mysecretpassword'
}

# Directory containing CSV files
DATA_DIR = '/app/data'

# Table-to-CSV mapping
CSV_TABLE_MAP = {
    'Marketing': 'marketing.csv',
    'Members': 'members.csv',
    'Preferences': 'preferences.csv',
    'Orders': 'order.csv',
    'Order_Items': 'order_items.csv',
    'Order_Status': 'order_status.csv',
}

def load_csv_to_db(cursor, table_name, csv_file):
    """
    Load CSV data into a PostgreSQL table.
    Args:
        cursor: Database cursor.
        table_name: Target table name.
        csv_file: Path to the CSV file.
    """
    cursor.execute(f"TRUNCATE TABLE {table_name} CASCADE;")

    print(f"Loading data from {csv_file} into {table_name}...")
    data = pd.read_csv(csv_file)

    # Convert column names to lowercase for compatibility
    data.columns = map(str.lower, data.columns)

    if table_name.lower() == 'members':
        data.rename(columns={'Id': 'memberid'}, inplace=True)
    
    if table_name.lower() == 'orders':
    # Replace NaN values with None
        data['campaignid'] = data['campaignid'].where(pd.notnull(data['campaignid']), None)

    if table_name.lower() == 'order_status':
    # Convert statustimestamp to PostgreSQL-compatible format
        if 'statustimestamp' in data.columns:
            data['statustimestamp'] = pd.to_datetime(
                data['statustimestamp'], format='%d/%m/%Y %H:%M:%S'
            ).dt.strftime('%Y-%m-%d %H:%M:%S')


    # Check for date columns and convert to 'YYYY-MM-DD'
    for column in ['campaignstartdate', 'campaignenddate', 'joindate', 'expirationdate', 'orderdate']:
        if column in data.columns:
            data[column] = pd.to_datetime(data[column], format='%d/%m/%Y').dt.strftime('%Y-%m-%d')

    # Generate the SQL INSERT query
    placeholders = ', '.join(['%s'] * len(data.columns))
    columns = ', '.join(data.columns)
    insert_query = sql.SQL(
        f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"
    )

    # Insert rows
    for _, row in data.iterrows():
        cursor.execute(insert_query, tuple(row))

    print(f"Loaded {len(data)} rows into {table_name}.")

def main():
    """
    Main function to load all CSV files into the database.
    """
    try:
        # Connect to the database
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()

        # Load each table
        for table, csv_file in CSV_TABLE_MAP.items():
            file_path = os.path.join(DATA_DIR, csv_file)
            if os.path.exists(file_path):
                load_csv_to_db(cursor, table, file_path)
            else:
                print(f"File {file_path} not found. Skipping {table}.")

        # Commit changes
        conn.commit()
        print("Data loading complete!")

    except Exception as e:
        print(f"Error: {e}")
        if conn:
            conn.rollback()
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

if __name__ == "__main__":
    main()
