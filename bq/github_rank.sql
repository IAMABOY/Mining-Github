--事件类型为PushEvent的payload含有email
--中国高校2018年push数量100强
--北大，上交，中科大位列前三甲，盛产工程师的北邮，华科也在前10之列
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
LIMIT 100;


--查看具有国家信息的用户占比
SELECT SUM(country_code!='\\N')/COUNT(*)
FROM [ghtorrent-bq:ght_2018_04_01.users]

--0.07504958728220708 repos by 2018 04/01


--ghtorrent-bq数据集users表记录了注册者的国家信息，有的用户没有
--由于users只更新到2018/04/01，联合users表和githubarchive:year.2017表
--Github 各个国家push数量，用户数量排名
--美国，中国，印度位列2018年以前用户数量前三甲

SELECT country_code, COUNT(*) AS pushes,COUNT(DISTINCT login) as user,INTEGER(COUNT(*)/COUNT(DISTINCT login))
FROM [githubarchive:year.2017] a
JOIN [ghtorrent-bq:ght_2018_04_01.users] b
ON a.actor.login=b.login
WHERE country_code != '\\N'
AND a.type='PushEvent'
GROUP BY country_code
ORDER BY pushes DESC


--公司贡献排名 by 2018.01
--微软近年来在开源社区发力，贡献很多
--Red Hat 以及google德国排名靠前
--中国的百度，腾讯，阿里排名分别为53，59，71
--排名第一是Lombiq Technologies Ltd.

SELECT company , COUNT(*) AS pushes
FROM [githubarchive:year.2017] a
JOIN [ghtorrent-bq:ght_2018_04_01.users] b
ON a.actor.login=b.login
WHERE company  != '\\N'
AND a.type='PushEvent'
GROUP BY company
ORDER BY pushes DESC
LIMIT 100





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
SELECT author.name,COUNT(*) AS commits
FROM [bigquery-public-data:github_repos.commits] 
GROUP BY author.name
ORDER BY commits DESC
--2408004 提交过代码

--2019/01/01以来修改代码次数用户排名
--author 是 patch 的作者，committer 是把 patch 应用到 repository 里的人 (很多项目限制只有少数人可以 apply patch，但大家都可以把 patch 发送给这些人)
SELECT author.name,COUNT(*) AS commits
FROM [bigquery-public-data:github_repos.commits] 
WHERE committer.date.seconds >= 1546272000
GROUP BY author.name
ORDER BY commits DESC