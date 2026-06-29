import pandas as pd
from sqlalchemy import create_engine

# Read CSV
df = pd.read_csv(r"C:\Users\thand\OneDrive\Desktop\Retail_Sales_Analytics Projects\Python\cleaned_superstore.csv")

# MySQL Connection
engine = create_engine(
    "mysql+pymysql://root:root@localhost/retail_sales"
)

# Upload to MySQL
df.to_sql(
    "superstore",
    con=engine,
    if_exists="replace",
    index=False
)

print("✅ Imported Successfully")