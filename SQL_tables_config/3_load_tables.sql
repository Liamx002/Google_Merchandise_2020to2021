COPY public.events_1
FROM 'C:\Users\Liam McCann\Documents\Project_Folders\Python_Tableau_Project\csv_files\events1.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY public.items
FROM 'C:\Users\Liam McCann\Documents\Project_Folders\Python_Tableau_Project\csv_files\items.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY public.users
FROM 'C:\Users\Liam McCann\Documents\Project_Folders\Python_Tableau_Project\csv_files\users.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

/* OR 

\COPY public.events_1 FROM 'C:\Users\Liam McCann\Documents\Project_Folders\Python_Tableau_Project\csv_files\events1.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\COPY public.items FROM 'C:\Users\Liam McCann\Documents\Project_Folders\Python_Tableau_Project\csv_files\items.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\COPY public.users FROM 'C:\Users\Liam McCann\Documents\Project_Folders\Python_Tableau_Project\csv_files\users.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/