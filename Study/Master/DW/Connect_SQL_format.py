import pandas as pd
import psycopg2

#connect with database
conn = psycopg2.connect(database = 'DW1',
                        user = 'postgres',
                        password = 'Hallo2121',
                        host = '127.0.0.1',
                        port=5432)

cursor = conn.cursor()

#query for fetching a attributes
query = ("SELECT * FROM bbc")
cursor.execute(query)

#Create a DF
df = pd.DataFrame(cursor)
cursor.close()
conn.close()

