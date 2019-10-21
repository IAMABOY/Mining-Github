
from google.cloud import bigquery
client = bigquery.Client()
query_sql = '''SELECT lang.name,COUNT(*) AS counts FROM `bigquery-public-data.github_repos.languages` , UNNEST(language) as lang
    GROUP BY lang.name 
    ORDER BY counts DESC
    LIMIT 10'''

query_job = client.query(
    query_sql,
    # Location must match that of the dataset(s) referenced in the query.
    location="US",
)  

for row in query_job: 
    print(row['name'],row['counts'])
