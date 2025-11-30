create extension if not exists plpython3u;
do $$
	import pandas as pd
	import matplotlib.pyplot as plt
	import matplotlib.cm as cm
	query=plpy.prepare("""select unnest(regexp_match(grade_level, '[0-9]+')) as grade from students;""", [])
	result=plpy.execute(query)
	df = pd.DataFrame([dict(row) for row in result])
	counts = df['grade'].value_counts().sort_index()
	colors = cm.tab10(range(len(counts)))
	fig, ax = plt.subplots(figsize=(6, 8))
	ax.bar(counts.index, counts.values, color=colors)
	ax.set_xlabel('Grade')
	ax.set_ylabel('Number of students')
	ax.set_ylim(0, 2500)
	plt.savefig('./outputs/figures/students_distribution_by_grade_level.png', dpi=300, transparent=True)
$$language plpython3u;
