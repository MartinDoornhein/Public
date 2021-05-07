import pandas as pd
import psycopg2

#connect with database
conn = psycopg2.connect(database = 'database',
                        user = 'postgres',
                        password = 'password',
                        host = 'host',
                        port=port)

cursor = conn.cursor()

#query for fetching a attributes
query = ("SELECT * FROM bbc")
cursor.execute(query)

#Create a DF
df = pd.DataFrame(cursor)
cursor.close()
conn.close()

