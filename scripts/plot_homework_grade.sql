drop function if exists plot_grade();
create or replace function plot_homework_grade(category text)
returns void 
as $$
	import pandas as pd
	import matplotlib.pyplot as plt
	import numpy as np
	
	query=plpy.prepare("""
		select h.grade_feedback, h.subject, s.grade_level
		from homework h
		join students s
		on h.student_id=s.student_id
		""", [])
	result=plpy.execute(query)
	df=pd.DataFrame([dict(row) for row in result])
	df_grouped = df.groupby([category, 'grade_feedback']).size().reset_index(name='counts')
	categories = df_grouped[category].unique()
	grades = df_grouped['grade_feedback'].unique()
	
	fig, ax = plt.subplots(figsize=(12,5))
	
	width = 0.1
	x = range(len(categories))
	
	for i, grade in enumerate(grades):
	    counts = [df_grouped.loc[(df_grouped[category]==c) & (df_grouped['grade_feedback']==grade), 'counts'].sum() for c in categories]
	    ax.bar([p + width*i for p in x], counts, width=width, label=grade)
	
	ax.set_xticks([p + width*(len(grades)/2-0.5) for p in x])
	ax.set_xticklabels(categories)
	ax.set_xlim(0, len(categories)+0.5)
	ax.set_ylabel('Counts')
	ax.set_title(f'Grade Feedback by {category}')
	ax.legend()

	plt.savefig(f'/outputs/figures/homework_grade_by_{category}.png', dpi=300, transparent=True)
$$ language plpython3u;

select * from plot_homework_grade('subject');

select * from plot_homework_grade('grade_level');
