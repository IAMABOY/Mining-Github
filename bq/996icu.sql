
--996ICU 2019/03 日均 issue,北京属于东八区+8

SELECT DATE(DATE_ADD(created_at, 8, "HOUR")) AS a_day,COUNT(*) as counts
FROM TABLE_QUERY([githubarchive:month],'table_id CONTAINS "2019"')
WHERE type = 'IssuesEvent' AND repo.name = '996icu/996.ICU' AND JSON_EXTRACT_SCALAR(payload, '$.action') = 'opened'
GROUP BY a_day
ORDER BY a_day


--所有的issue中title出现次数排名
SELECT JSON_EXTRACT_SCALAR(payload, '$.issue.title') as title,COUNT(*) AS counts
FROM [githubarchive:month.201903] 
WHERE type = 'IssuesEvent' AND repo.name = '996icu/996.ICU' AND JSON_EXTRACT_SCALAR(payload, '$.action') = 'opened'
GROUP BY title
ORDER BY counts DESC

--all issue title
SELECT JSON_EXTRACT_SCALAR(payload, '$.issue.title') as title
FROM [githubarchive:month.201903] 
WHERE type = 'IssuesEvent' AND repo.name = '996icu/996.ICU' AND JSON_EXTRACT_SCALAR(payload, '$.action') = 'opened'
ORDER BY created_at


--每个issue 的comment个数统计
SELECT JSON_EXTRACT_SCALAR(payload, '$.issue.title') AS title,COUNT(*) AS counts
FROM [githubarchive:month.201903] 
WHERE type = 'IssueCommentEvent' AND repo.name = '996icu/996.ICU' AND JSON_EXTRACT_SCALAR(payload, '$.action') = 'created'
GROUP BY title
ORDER BY counts desc


--issue comment 公司员工个数排名
SELECT company, COUNT(*) AS comments,COUNT(DISTINCT login) as user_number
FROM [githubarchive:month.201903]  AS a
JOIN [ghtorrent-bq:ght_2018_04_01.users] AS b
ON a.actor.login=b.login
WHERE b.company != '\\N' AND a.type='IssueCommentEvent' AND a.repo.name = '996icu/996.ICU'
GROUP BY company
ORDER BY user_number DESC


--issue comments 公司总量排名
SELECT company, COUNT(*) AS comments,COUNT(DISTINCT login) as user_number,group_concat(login)
FROM [githubarchive:month.201903]  AS a
JOIN [ghtorrent-bq:ght_2018_04_01.users] AS b
ON a.actor.login=b.login
WHERE b.company != '\\N' AND a.type='IssueCommentEvent' AND a.repo.name = '996icu/996.ICU'
GROUP BY company
ORDER BY pushes DESC

--issue comments 国家排名
SELECT country_code, COUNT(*) AS comments,COUNT(DISTINCT login) as user_number
FROM [githubarchive:month.201903]  AS a
JOIN [ghtorrent-bq:ght_2018_04_01.users] AS b
ON a.actor.login=b.login
WHERE b.country_code != '\\N' AND a.type='IssueCommentEvent' AND a.repo.name = '996icu/996.ICU'
GROUP BY country_code
ORDER BY comments DESC


--commit message内容
SELECT JSON_EXTRACT_SCALAR(payload, '$.commits[0].message') AS message,created_at
FROM TABLE_DATE_RANGE([githubarchive:month.],TIMESTAMP('2019-01'),TIMESTAMP('2019-10'))
WHERE type = 'PushEvent' AND repo.name = '996icu/996.ICU'
ORDER BY created_at


--commit message 出现频率最高的排名
SELECT JSON_EXTRACT_SCALAR(payload, '$.commits[0].message') AS message,COUNT(*) AS counts
FROM TABLE_QUERY([githubarchive:month],'table_id CONTAINS "2019"')
WHERE type = 'PushEvent' AND repo.name = '996icu/996.ICU'
GROUP BY message
ORDER BY counts DESC


--commit记录作者提交次数
SELECT JSON_EXTRACT_SCALAR(payload, '$.commits[0].author.name') AS name,COUNT(*) AS counts
FROM TABLE_QUERY([githubarchive:month],'table_id CONTAINS "2019"')
WHERE type = 'PushEvent' AND repo.name = '996icu/996.ICU'
GROUP BY name
ORDER BY counts desc


--该项目都是由996icu push代码的,其他贡献者有commit权限
SELECT repo.name,actor.id,actor.login,JSON_EXTRACT_SCALAR(payload, '$.commits[0].author.name') AS name,id,other
FROM [githubarchive:month.201903] 
WHERE type = 'PushEvent' AND repo.name = '996icu/996.ICU'
ORDER BY created_at desc

