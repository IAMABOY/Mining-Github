import os
import bq_helper
os.environ['GOOGLE_APPLICATION_CREDENTIALS']='xxx.json'
github_repos = bq_helper.BigQueryHelper(active_project= "bigquery-public-data", 
                                       dataset_name = "github_repos")

query_sql= '''SELECT lang.name,COUNT(*) AS counts FROM `bigquery-public-data.github_repos.languages` , UNNEST(language) as lang
    GROUP BY lang.name 
    ORDER BY counts DESC
    LIMIT 10'''
print('estimate query size:',github_repos.estimate_query_size(query_sql))

#BigQuery data as a Pandas DataFrame
github_repo_sizes = github_repos.query_to_pandas_safe(query_sql, max_gb_scanned=23)

print(github_repo_sizes.head(5)['name'])






