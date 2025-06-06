SELECT skills,
    COUNT(*) AS demand_count,
    ROUND(AVG(salary_year_avg), 0) AS average_pay
FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY average_pay DESC
LIMIT 25