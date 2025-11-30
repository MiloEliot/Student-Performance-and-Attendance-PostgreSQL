--plot the average exam_score for each subject/grade
create or replace function plot_avg_score()
returns void
as $$
	import pandas as pd
	import matplotlib.pyplot as plt
	import matplotlib.cm as cm
	
	query = plpy.prepare("""
				select p.updated_exam_score, p.subject, s.grade_level
				from performance p
				join students s
				on p.student_id=s.student_id""", [])
	result=plpy.execute(query)
	df=pd.DataFrame([dict(row) for row in result])
	df_grouped=df.groupby(['subject', 'grade_level'])['updated_exam_score'].mean().unstack(fill_value=0)
	
	ax=df_grouped.plot(kind='bar', figsize=(10, 8), colormap='Set3')
	ax.set_ylabel('average_exam_score')
	ax.legend(loc='upper right', fontsize='small')
	ax.set_ylim(0, 100)
	ax.set_yticks(ticks=range(0, 110, 10))
	ax.set_title('Average exam score by grade and subject')
	plt.savefig('./outputs/figures/average_exam_score_by_subject_and_grade_level.png', dpi=300, transparent=True)
$$language plpython3u;


select * from plot_avg_score();