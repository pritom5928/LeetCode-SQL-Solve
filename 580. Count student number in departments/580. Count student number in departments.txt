Input: Student table:

student_id  student_name    gender  dept_id
--------------------------------------------
    1       Jack               M       1
    2       Jane               F       1
    3       Mark               M       2


Department table:

dept_id dept_name
---------------------
1       Engineering
2       Science
3       Law


Output:

dept_name   student_number
---------------------------
Engineering  2
Science      1
Law          0



Naive solution: 

select d1.dept_name, ifnull(b1.number, 0) as student_number from department d1 left join (       
select d.dept_id as depid, count(*) as number from student as s
		left join department as d on s.dept_id = d.dept_id group by d.dept_id) b1 on d1.dept_id = b1.depid
        order by student_number desc;


optimal solution:;

select d.dept_name, count(s.student_id) as student_number from department as d 
		left join student as s on d.dept_id = s.dept_id 
        group by d.dept_id
        order by student_number desc;