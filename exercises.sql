-- # Projects DB Exercises
--
-- ## Setup
--
-- Create a new database called projects_db or whatever you want. Restore the database from the projects.sql file via the command:
--
-- psql projects_db < projects.sql
--
-- ## Problems

-- * Do a cartesian join between the project table and the tech table

select
  project.name, tech.name
from
  project, tech
where
  project.id = tech.id;

-- * Perform a left outer join between the project table and the project_uses_tech tables

select
	project.name, project.id
from
	project
left outer join
  project_uses_tech on project.id = project_uses_tech.project_id;

--* Perform a left outer join between the tech table and the project_uses_tech table

select
	tech.name, tech.id
from
	tech
left outer join
  project_uses_tech on tech.id = project_uses_tech.project_id;


--* Perform a left outer join from the project table to the project_users_tech table and then left outer join again to the tech table.

select
     project.name, project.id, tech.name, tech.id
from
     project
left outer join
     project_uses_tech on project.id = project_uses_tech.project_id
left outer join
     tech on tech.id = project_uses_tech.tech_id

--* Start from the answer on the previous problem and get the count of how many different tech each project uses

select
     tech.name, tech.id,
     sum(case when tech.id is NULL then 0 else 1 end) as tech_count
from
     project
left outer join
     project_uses_tech on project.id = project_uses_tech.project_id
left outer join
     tech on tech.id = project_uses_tech.tech_id
     group by tech.id

--* For each tech, get the count of how many projects use it
select
     tech.name, tech.id,
     sum(case when tech.id is NULL then 0 else 1 end) as project_count
from
     tech
left outer join
     project_uses_tech on tech.id = project_uses_tech.tech_id
left outer join
     project on project.id = project_uses_tech.project_id
     group by tech.id

--* Rank each project by how many tech it uses
select
     project.id, project.name,
     sum(case when tech.id is NULL then 0 else 1 end) as tech_count
from
     project
left outer join
     project_uses_tech on project.id = project_uses_tech.project_id
left outer join
     tech on tech.id = project_uses_tech.tech_id
     group by project.id
     --group by tech_count
     order by tech_count desc
     limit 10

--* Rank each tech by how many projects use it
select
     tech.name, tech.id,
     sum(case when tech.id is NULL then 0 else 1 end) as project_count
from
     tech
left outer join
     project_uses_tech on tech.id = project_uses_tech.tech_id
left outer join
     project on project.id = project_uses_tech.project_id
     group by tech.id
     order by project_count desc
     limit 10

--* What is the average number of techs used by a project?
select

	avg(project_count)
from
	(select
	     tech.name,
	     sum(case when tech.id is NULL then 0 else 1 end) as project_count
	from
	     tech
	left outer join
	     project_uses_tech on tech.id = project_uses_tech.tech_id
	left outer join
	     project on project.id = project_uses_tech.project_id
	     group by tech.id
	     order by project_count desc
	) as count
