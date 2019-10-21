--bq会用到三个关于Github数据集bigquery-public-data:github_repos,githubarchive,ghtorrent-bq
--bigquery-public-data:github_repos,githubarchive更新频繁，ghtorrent-bq好久没有更新，但是可以手动导入其官网数据
--三个数据集都有较为实用的信息，哪个方便使用哪一个



--中国高校2018年push数量100强
--事件类型为PushEvent的payload含有email
--全球教育机构只要将过滤条件改为.edu即可

SELECT REGEXP_EXTRACT(email, r'@(.*)') AS domain, COUNT(*) AS counts
FROM (
  SELECT REGEXP_EXTRACT(payload, r'([a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+)') AS email
  FROM [githubarchive:year.2018]
  WHERE REGEXP_EXTRACT(payload, r'([a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+)') IS NOT null
  GROUP BY email
  HAVING email CONTAINS '.edu.cn'
)
GROUP BY domain
ORDER BY counts DESC
LIMIT 10;


--查看具有国家信息的用户占比
--0.07504958728220708 repos by 2018 04/01

SELECT SUM(country_code!='\\N')/COUNT(*)
FROM [ghtorrent-bq:ght_2018_04_01.users]


--ghtorrent-bq数据集users表记录了注册者的国家信息，有的用户没有
--由于users只更新到2018/04/01，联合users表和githubarchive:year.2017表
--Github 各个国家push数量，用户数量排名

SELECT country_code, COUNT(*) AS pushes,COUNT(DISTINCT login) as user,INTEGER(COUNT(*)/COUNT(DISTINCT login))
FROM [githubarchive:year.2017] a
JOIN [ghtorrent-bq:ght_2018_04_01.users] b
ON a.actor.login=b.login
WHERE country_code != '\\N'
AND a.type='PushEvent'
GROUP BY country_code
ORDER BY pushes DESC


--公司贡献排名 by 2018.01

SELECT company , COUNT(*) AS pushes
FROM [githubarchive:year.2017] a
JOIN [ghtorrent-bq:ght_2018_04_01.users] b
ON a.actor.login=b.login
WHERE company  != '\\N'
AND a.type='PushEvent'
GROUP BY company
ORDER BY pushes DESC
LIMIT 100


--2019年以来被fork次数最多的项目，一定程度上代表了该项目的流行程度

SELECT table2019.repo.name AS repo_name,COUNT(DISTINCT table2019.actor.id) AS fork_counts
FROM 
  (
  SELECT *
  FROM TABLE_QUERY([githubarchive:month],'table_id CONTAINS "2019"')
  ) AS table2019
  WHERE table2019.type = 'ForkEvent'
GROUP BY repo_name
ORDER BY fork_counts DESC
LIMIT 20


--哪个项目被提交的次数最多

SELECT repo_name, COUNT(*) AS commit_num
FROM [bigquery-public-data:github_repos.commits] 
GROUP BY repo_name
ORDER BY commit_num DESC


--2019/01/01年以来提交最频繁的项目

SELECT repo_name, COUNT(*) AS commit_num
FROM [bigquery-public-data:github_repos.commits] 
WHERE committer.date.seconds >= 1546272000
GROUP BY repo_name
ORDER BY commit_num DESC


--查询github修改代码次数最多的大神
--2408004 人提交过代码 by 2019/10/05

SELECT author.name,COUNT(*) AS commits
FROM [bigquery-public-data:github_repos.commits] 
GROUP BY author.name
ORDER BY commits DESC


--2019/01/01以来修改代码次数用户排名
--author 是 patch 的作者，committer 是把 patch 应用到 repository 里的人 (很多项目限制只有少数人可以 apply patch，但大家都可以把 patch 发送给这些人)
--看看有没有你熟悉的大神,我严重怀疑提交次数过万的大概率是全职

SELECT author.name,COUNT(*) AS commits
FROM [bigquery-public-data:github_repos.commits] 
WHERE committer.date.seconds >= 1546272000
GROUP BY author.name
ORDER BY commits DESC


--2019 star数TOP10

SELECT table2019.repo.name AS repo_name,COUNT(DISTINCT table2019.actor.id) AS watch_counts
FROM 
  (
  SELECT *
  FROM TABLE_QUERY([githubarchive:month],'table_id CONTAINS "2019"')
  ) AS table2019
  WHERE table2019.type = 'WatchEvent' AND JSON_EXTRACT_SCALAR(table2019.payload, '$.action') = 'started'
GROUP BY repo_name
ORDER BY watch_counts DESC
LIMIT 10


--996ICU 2019/03 issue 增长,北京属于东八区+8

SELECT DATE(DATE_ADD(created_at, 8, "HOUR")) AS a_day,COUNT(*) as counts
FROM TABLE_QUERY([githubarchive:month],'table_id CONTAINS "2019"')
WHERE type = 'IssuesEvent' AND repo.name = '996icu/996.ICU' AND JSON_EXTRACT_SCALAR(payload, '$.action') = 'opened'
GROUP BY a_day
ORDER BY a_day


--中国程序员的数量

SELECT *
FROM [ghtorrent-bq:ght_2018_04_01.users] 
WHERE country_code = 'cn'

