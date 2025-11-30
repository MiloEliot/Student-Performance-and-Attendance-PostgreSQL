DO $$
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.cm as cm

query = plpy.prepare("""
    select subject, attendance_status
    from attendance
""", [])

result = plpy.execute(query)
df = pd.DataFrame([dict(row) for row in result])

df_grouped = df.groupby(['subject', 'attendance_status']).size().reset_index(name='counts')

width = 0.1
attendance_status = df_grouped['attendance_status'].unique()
subjects = df_grouped['subject'].unique()

fig, ax = plt.subplots(figsize=(12, 6))

for i, status in enumerate(attendance_status):
    heights = [
        df_grouped.loc[
            (df_grouped['attendance_status'] == status) &
            (df_grouped['subject'] == subject),
            'counts'
        ].sum()
        for subject in subjects
    ]
    ax.bar(
        x=[p + i * width for p in range(len(subjects))],
        height=heights,
        width=width,
        label=status
    )

ax.set_xlabel('Subjects')
ax.set_ylabel('Attendance counts')
ax.set_xticks(
    ticks=[p + (len(attendance_status) - 0.5) * width / 2 for p in range(len(subjects))],
    labels=subjects
)
ax.set_ylim(0, 20000)
ax.legend(loc='upper right', fontsize='small')

plt.savefig('./outputs/figures/attendance_status_by_grade_level.png', dpi=300, transparent=True)
$$ LANGUAGE plpython3u;
