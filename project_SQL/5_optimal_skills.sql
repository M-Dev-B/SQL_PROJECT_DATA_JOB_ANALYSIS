WITH top_demand AS (
    SELECT skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND job_work_from_home IS TRUE
        AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
),
top_pay AS (
    SELECT skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS average_pay
    FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY skills_job_dim.skill_id
)
SELECT top_demand.skill_id,
    top_demand.skills,
    demand_count,
    average_pay
FROM top_demand
    INNER JOIN top_pay ON top_demand.skill_id = top_pay.skill_id
ORDER BY demand_count DESC,
    average_pay DESC
LIMIT 25